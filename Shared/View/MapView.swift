//
//  MapView.swift
//  HowMuchTokyoDome (iOS)
//
//  Created by tomoyo_kageyama on 2022/03/07.
//

import SwiftUI
import MapKit
import Combine
import UIKit

struct MapView: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel
    // The center of the map.
    var coordinate: CLLocationCoordinate2D
    let mapView = MKMapView(frame: .zero)
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        self.coordinate = viewModel.mapCenter
    }
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        print("map new coordinate", coordinate)
        view.setRegion(region, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var subscribers: [AnyCancellable] = []
        
        var changeCurrentLocation: ((CLLocationCoordinate2D) -> Void)?

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            //print(mapView.centerCoordinate)
            print("** mapViewDidChangeVisibleRegion ** \(parent.viewModel.latitude)")
            
        }

        func mapView(_ mapView: MKMapView,
                     didUpdate userLocation: MKUserLocation) {
            print("User location\(userLocation.coordinate) \(parent.viewModel.latitude)")
        }

        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
            print("Map will start loading \(parent.viewModel.latitude)")
        }
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            print("Map did finish loading \(parent.viewModel.latitude)")
        }

        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
            print("Map will start locating user \(parent.viewModel.latitude)")
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
    }
}
