//
//  MapView.swift
//  HowMuchTokyoDome (iOS)
//
//  Created by tomoyo_kageyama on 2022/03/07.
//

import SwiftUI
import MapKit

struct PinItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @State private var region = MKCoordinateRegion() // 座標領域
    @State private var userTrackingMode: MapUserTrackingMode = .none
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        Map(coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode,
            annotationItems: [
                PinItem(coordinate: .init(latitude: viewModel.latitude, longitude: viewModel.longitude))
            ],
            annotationContent: { item in
            MapMarker(coordinate: item.coordinate)
        })
            .onAppear(perform: {
                setRegion(coordinate: CLLocationCoordinate2D(latitude: viewModel.latitude, longitude: viewModel.longitude))
                
            })
        
    }
    
    // 引数で取得した緯度経度を使って動的に表示領域の中心位置と、縮尺を決める
    private func setRegion(coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(center: coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.0009, longitudeDelta: 0.0009)
        )
    }
}
