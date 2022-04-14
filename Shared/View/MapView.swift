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
    private let defaultMeter = CLLocationDistance(1000)
    
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
        
        let region = MKCoordinateRegion(center: self.coordinate, latitudinalMeters: defaultMeter, longitudinalMeters: defaultMeter)
        view.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        var changeCurrentLocation: ((CLLocationCoordinate2D) -> Void)?
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print(mapView.regionInMeter())
            parent.viewModel.shouldUpdateView = false
            parent.viewModel.distanceSubject.send(mapView.regionInMeter() as Double)
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        }
        
        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        }
        
        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
    }
}

extension MKMapView {
  // 画面上に表示されている東西の距離
  func regionInMeter() -> CLLocationDistance {
      let eastMapPoint = MKMapPoint(x: visibleMapRect.minX, y: visibleMapRect.midY)
      let westMapPoint = MKMapPoint(x: visibleMapRect.maxX, y: visibleMapRect.midY)

      return eastMapPoint.distance(to: westMapPoint)
  }
}
