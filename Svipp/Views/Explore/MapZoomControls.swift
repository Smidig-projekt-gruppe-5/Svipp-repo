import SwiftUI
import MapKit

struct MapZoomControls: View {
    @Binding var region: MKCoordinateRegion
    var bottomPadding: CGFloat = 100
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                zoomIn()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 3)
                    .foregroundColor(Color.svippMain)

            }

            Button {
                zoomOut()
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 3)
                    .foregroundColor(Color.svippMain)

            }
        }
        .padding(.trailing, 16)
        .padding(.bottom, bottomPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
    
    
    private func zoomIn() {
        withAnimation(.easeInOut) {
            region.span.latitudeDelta *= 0.8
            region.span.longitudeDelta *= 0.8
        }
    }
    
    private func zoomOut() {
        withAnimation(.easeInOut) {
            region.span.latitudeDelta *= 1.25
            region.span.longitudeDelta *= 1.25
        }
    }
}

#Preview {
    MapZoomControls(
        region: .constant(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 59.9139, longitude: 10.7522),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        )
    )
}
