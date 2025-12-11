import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class AuthService: ObservableObject {
    static let shared = AuthService()
    
    @Published var authError: String?
    @Published var isLoading: Bool = false
    
    @Published var user: FirebaseAuth.User?
    @Published var currentUserProfile: UserInfo?
    
    // Global liste med sjåfører fra firestore
    @Published var previousDrivers: [DriverInfo] = []
    @Published var bookings: [SvippBooking] = []

    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private init() {
        self.user = Auth.auth().currentUser
        
        if let user = self.user {
            loadUserProfile(uid: user.uid)
        }
        
        loadPreviousDrivers()
    }
    
    // Log Inn
    func signIn(email: String, password: String) {
        authError = nil
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.authError = error.localizedDescription
                } else if let user = result?.user {
                    self.user = user
                    self.loadUserProfile(uid: user.uid)
                    // sjåfører er fortsatt globale
                    self.loadPreviousDrivers()
                }
            }
        }
    }
    
    // log ut
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.currentUserProfile = nil
            self.previousDrivers = []
        } catch {
            self.authError = error.localizedDescription
        }
    }

    
    // opprette og lagre bruker
    func createAccount(name: String, birthdate: String, email: String, password: String) {
        authError = nil
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.authError = error.localizedDescription
                    return
                }
                
                guard let user = result?.user else { return }
                self.user = user
                
                let profile = UserInfo(
                    id: user.uid,
                    name: name,
                    birthdate: birthdate,
                    email: email,
                    profileImageURL: nil,
                    phoneNumber: nil,
                    addressLine: nil,
                    postalCode: nil,
                    city: nil,
                    carMake: nil,
                    carModel: nil,
                    carYear: nil
                )
                
                self.saveUserProfile(profile)
            }
        }
    }
    
    // lagre profile i firestore
    func saveUserProfile(_ profile: UserInfo) {
        do {
            let data = try JSONEncoder().encode(profile)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
            
            db.collection("users").document(profile.id).setData(json) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Feil ved lagring av profil:", error)
                        self?.authError = error.localizedDescription
                    } else {
                        self?.currentUserProfile = profile
                    }
                }
            }
        } catch {
            print("Feil ved encoding av profil:", error)
            DispatchQueue.main.async {
                self.authError = "Kunne ikke lagre brukerprofil"
            }
        }
    }
    
    // laste profile i firestore
    func loadUserProfile(uid: String) {
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("Feil ved henting av profil:", error)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let profile = try JSONDecoder().decode(UserInfo.self, from: jsonData)
                DispatchQueue.main.async {
                    self?.currentUserProfile = profile
                }
            } catch {
                print("Feil ved decoding av profil:", error)
            }
        }
    }
    
    // oppdatere profile
    func updateUserProfile(
        name: String,
        birthdate: String,
        phoneNumber: String?,
        addressLine: String?,
        postalCode: String?,
        city: String?,
        carMake: String?,
        carModel: String?,
        carYear: String?,
        completion: ((Error?) -> Void)? = nil
    ) {
        guard let user = user else {
            let error = NSError(
                domain: "AuthService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Ingen innlogget bruker"]
            )
            completion?(error)
            return
        }
        
        let updatedProfile = UserInfo(
            id: user.uid,
            name: name,
            birthdate: birthdate,
            email: currentUserProfile?.email ?? user.email ?? "",
            profileImageURL: currentUserProfile?.profileImageURL,
            phoneNumber: phoneNumber,
            addressLine: addressLine,
            postalCode: postalCode,
            city: city,
            carMake: carMake,
            carModel: carModel,
            carYear: carYear
        )
        
        do {
            let data = try JSONEncoder().encode(updatedProfile)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
            
            db.collection("users").document(updatedProfile.id).setData(json) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Feil ved oppdatering av profil:", error)
                        self?.authError = error.localizedDescription
                        completion?(error)
                    } else {
                        self?.currentUserProfile = updatedProfile
                        completion?(nil)
                    }
                }
            }
        } catch {
            print("Feil ved encoding av oppdatert profil:", error)
            DispatchQueue.main.async {
                self.authError = "Kunne ikke oppdatere brukerprofil"
            }
            completion?(error)
        }
    }
    
    // opplasting av profilbilde
    func uploadProfileImage(_ image: UIImage, completion: ((Error?) -> Void)? = nil) {
        guard let user = user else {
            let error = NSError(
                domain: "AuthService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Ingen innlogget bruker"]
            )
            completion?(error)
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            let error = NSError(
                domain: "AuthService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Kunne ikke konvertere bilde"]
            )
            completion?(error)
            return
        }
        
        let ref = storage.reference()
            .child("profileImages")
            .child("\(user.uid).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metadata) { [weak self] _, error in
            if let error = error {
                print(" Feil ved opplasting av bilde:", error)
                DispatchQueue.main.async {
                    self?.authError = error.localizedDescription
                }
                completion?(error)
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print(" Feil ved henting av downloadURL:", error)
                    DispatchQueue.main.async {
                        self?.authError = error.localizedDescription
                    }
                    completion?(error)
                    return
                }
                
                guard let url = url else {
                    let err = NSError(
                        domain: "AuthService",
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: "Mangler URL"]
                    )
                    completion?(err)
                    return
                }
                
                DispatchQueue.main.async {
                    let old = self?.currentUserProfile
                    
                    let updatedProfile = UserInfo(
                        id: user.uid,
                        name: old?.name ?? "",
                        birthdate: old?.birthdate ?? "",
                        email: old?.email ?? user.email ?? "",
                        profileImageURL: url.absoluteString,
                        phoneNumber: old?.phoneNumber,
                        addressLine: old?.addressLine,
                        postalCode: old?.postalCode,
                        city: old?.city,
                        carMake: old?.carMake,
                        carModel: old?.carModel,
                        carYear: old?.carYear
                    )
                    
                    self?.saveUserProfile(updatedProfile)
                    completion?(nil)
                }
            }
        }
    }
    
    @discardableResult
    func addBooking(from: String, to: String, pickupTime: Date, note: String? = nil) -> SvippBooking? {
        guard let user = user else { return nil }
        
        let booking = SvippBooking(
            id: UUID().uuidString,
            userId: user.uid,
            fromAddress: from,
            toAddress: to,
            pickupTime: pickupTime,
            createdAt: Date(),
            note: note
        )
        
        
        bookings.append(booking)
        return booking
    }
    
    // slette booking
    func deleteBooking(_ booking: SvippBooking) {
        bookings.removeAll { $0.id == booking.id }
        
    }
    
    // lese alle sjåfører fra firestore
    func loadPreviousDrivers() {
        db.collection("drivers")
            .order(by: "lastTripAt", descending: true)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("Feil ved henting av sjåfører:", error)
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                var loaded: [DriverInfo] = []
                
                for doc in documents {
                    let data = doc.data()
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let driver = try JSONDecoder().decode(DriverInfo.self, from: jsonData)
                        loaded.append(driver)
                    } catch {
                        print("Feil ved decoding av DriverInfo:", error)
                    }
                }
                
                DispatchQueue.main.async {
                    self?.previousDrivers = loaded
                }
            }
    }
    
    // lagrer en sjåfør
    func addPreviousDriver(_ driver: DriverInfo, completion: ((Error?) -> Void)? = nil) {
        do {
            let data = try JSONEncoder().encode(driver)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
            
            db.collection("drivers")
                .document(driver.id)
                .setData(json) { [weak self] error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Feil ved lagring av sjåfør:", error)
                            completion?(error)
                        } else {
                            self?.previousDrivers.insert(driver, at: 0)
                            completion?(nil)
                        }
                    }
                }
        } catch {
            print("Feil ved encoding av DriverInfo:", error)
            completion?(error)
        }
    }
    
    // oppdaterer en sjåfør
    func updateDriver(_ driver: DriverInfo, completion: ((Error?) -> Void)? = nil) {
        do {
            let data = try JSONEncoder().encode(driver)
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
            
            db.collection("drivers")
                .document(driver.id)
                .setData(json, merge: true) { [weak self] error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Feil ved oppdatering av sjåfør:", error)
                            completion?(error)
                        } else {
                            if let index = self?.previousDrivers.firstIndex(where: { $0.id == driver.id }) {
                                self?.previousDrivers[index] = driver
                            }
                            completion?(nil)
                        }
                    }
                }
        } catch {
            print("Feil ved encoding av DriverInfo i updateDriver:", error)
            completion?(error)
        }
    }
    
}

extension AuthService {
    func addReview(
        for driver: DriverInfo,
        rating: Int,
        comment: String? = nil,
        completion: ((Error?) -> Void)? = nil
    ) {
        guard let profile = currentUserProfile else {
            print("Ingen innlogget profil – kan ikke legge til review")
            completion?(NSError(
                domain: "AuthService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Ingen innlogget brukerprofil"]
            ))
            return
        }
        
        let review = DriverReview(
            reviewerName: profile.name,
            reviewerAge: 0,
            rating: Double(rating),
            comment: comment,
            createdAt: Date()
        )
        
        var updatedReviews = driver.reviews ?? []
        updatedReviews.append(review)
        
        let updatedDriver = DriverInfo(
            id: driver.id,
            name: driver.name,
            rating: driver.rating,
            address: driver.address,
            experienceYears: driver.experienceYears,
            totalTrips: driver.totalTrips,
            price: driver.price,
            imageName: driver.imageName,
            lastTripAt: driver.lastTripAt,
            age: driver.age,
            employmentDate: driver.employmentDate,
            tripCount: driver.tripCount,
            about: driver.about,
            reviews: updatedReviews
        )
        
        // Bruker firestore logikk
        updateDriver(updatedDriver) { [weak self] error in
            if error == nil {
                if let index = self?.previousDrivers.firstIndex(where: { $0.id == driver.id }) {
                    self?.previousDrivers[index] = updatedDriver
                }
            }
            completion?(error)
        }
    }
}
