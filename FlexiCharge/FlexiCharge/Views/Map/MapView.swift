//
//  MapView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-06.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var chargePoints: [ChargerHub]
    @Binding var centerUser: Bool
    @StateObject private var manager = LocationManager()
    let chargerStatusPins = [StatusConstants.AVAILABLE: "available-charger-pin", StatusConstants.PREPARING: "unkown-status-charger-pin", StatusConstants.CHARGING: "occupied-charger-pin", StatusConstants.SUSPENDEDEVSE: "unkown-status-charger-pin", StatusConstants.SUSPENDEDEV: "unkown-status-charger-pin", StatusConstants.FINISHING: "unkown-status-charger-pin", StatusConstants.RESERVED: "unkown-status-charger-pin", StatusConstants.UNAVAILABLE: "unkown-status-charger-pin", StatusConstants.FAULTED: "unkown-status-charger-pin"]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 57.778568, longitude: 14.163727),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    init(chargePoints: Binding<[ChargerHub]>, centerUser: Binding<Bool>) {
        self._chargePoints = chargePoints
        self._centerUser = centerUser
    }
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: chargePoints) { chargePoint in
            MapAnnotation(
                coordinate: CLLocationCoordinate2D(
                    latitude: CLLocationDegrees(chargePoint.location[0]),
                    longitude: CLLocationDegrees(chargePoint.location[1])),
                anchorPoint: CGPoint(x: 0.5, y: 0.5)
            ) {
                Image(chargerStatusPins[StatusConstants.AVAILABLE]!)
            }
        }.onChange(of: centerUser, perform: { _ in
            region = manager.region
        })
    }
}
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(chargePoints: .constant([ChargerHub(chargePointID: 9, name: "Name", location: [0, 0], price: "99", klarnaReservationAmount: 300)]), centerUser: .constant(false))
    }
}
