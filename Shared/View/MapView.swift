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
    private var coordinate: CLLocationCoordinate2D
    private let mapView = MKMapView(frame: .zero)
    private let defaultMeter = CLLocationDistance(TokyoDomeInfo.diameter)
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        self.coordinate = viewModel.mapCenter
    }
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.isPitchEnabled = false
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        guard viewModel.shouldUpdateView else {
            viewModel.shouldUpdateView = true
            return
        }
        
        switch viewModel.event {
        case .currentLocation:
            let region = MKCoordinateRegion(center: self.coordinate, latitudinalMeters: defaultMeter, longitudinalMeters: defaultMeter)
            view.setRegion(region, animated: true)
        case .oneSize:
            let region = MKCoordinateRegion(center: viewModel.centerLocation, latitudinalMeters: defaultMeter, longitudinalMeters: defaultMeter)
            view.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.viewModel.shouldUpdateView = false
            parent.viewModel.distanceSubject.send(mapView.regionInMeter() / 2 as Double)
            parent.viewModel.centerLocation = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        }
        
        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
            guard mapView.centerCoordinate.latitude < 0,
               mapView.centerCoordinate.latitude > -3.85,
               mapView.centerCoordinate.longitude < 0,
               mapView.centerCoordinate.longitude > -7.71 else {
                return
            }
            
            let center = CLLocationCoordinate2D(latitude: TokyoDomeInfo.lat, longitude: TokyoDomeInfo.lon)
            let region = MKCoordinateRegion(center: center, latitudinalMeters: parent.defaultMeter, longitudinalMeters: parent.defaultMeter)
            mapView.setRegion(region, animated: true)
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        }
        
        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        }

//
//        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//
//            parent.viewModel.shouldUpdateView = false
//            parent.viewModel.distanceSubject.send(mapView.regionInMeter() as Double)
//        }
//
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
    }
}

extension MKMapView {
  // 画面上に表示されている東西の距離(m)
  func regionInMeter() -> CLLocationDistance {
      return region.span.latitudeDelta * 111 * 1000
  }
}
