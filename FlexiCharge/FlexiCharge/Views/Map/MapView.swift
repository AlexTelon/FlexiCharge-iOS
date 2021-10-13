//
//  MapView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-06.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var chargers: [Charger]
    @Binding var centerUser: Bool
    @StateObject private var manager = LocationManager()
    let chargerStatusPins = [StatusConstants.AVAILABLE: "available-charger-pin", StatusConstants.PREPARING: "unkown-status-charger-pin", StatusConstants.CHARGING: "occupied-charger-pin", StatusConstants.SUSPENDEDEVSE: "unkown-status-charger-pin", StatusConstants.SUSPENDEDEV: "unkown-status-charger-pin", StatusConstants.FINISHING: "unkown-status-charger-pin", StatusConstants.RESERVED: "unkown-status-charger-pin", StatusConstants.UNAVAILABLE: "unkown-status-charger-pin", StatusConstants.FAULTED: "unkown-status-charger-pin"]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 57.778568, longitude: 14.163727),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    init(chargers: Binding<[Charger]>, centerUser: Binding<Bool>) {
        self._chargers = chargers
        self._centerUser = centerUser
    }
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: chargers) { charger in
            MapAnnotation(
                coordinate: CLLocationCoordinate2D(
                    latitude: CLLocationDegrees(charger.location[0]),
                    longitude: CLLocationDegrees(charger.location[1])),
                anchorPoint: CGPoint(x: 0.5, y: 0.5)
            ) {
                Image(chargerStatusPins[charger.status]!)
            }
        }.onChange(of: centerUser, perform: { _ in
            region = manager.region
        })
    }
}
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(chargers: .constant([Charger(chargerID: 999999, location: [57.778568, 14.163727], chargePointID: 9, serialNumber: "%&(/K€OLC:VP", status: "Available")]), centerUser: .constant(true))
    }
}
