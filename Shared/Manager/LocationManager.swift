//
//  LocationManager.swift
//  HowMuchTokyoDome (iOS)
//
//  Created by tomoyo_kageyama on 2022/03/30.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    
    // The first location reported by the CLLocationManager.
    @Published var initialUserCoordinate: CLLocationCoordinate2D?
    // The latest location reported by the CLLocationManager.
    @Published var currentUserCoordinate: CLLocationCoordinate2D?
//    let geoCoder = CLGeocoder()

    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .other
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestAuthorization() {
         if locationManager.authorizationStatus == .notDetermined {
             locationManager.requestWhenInUseAuthorization()
         }
     }

     func startTracking() {
         locationManager.startUpdatingLocation()
     }

     func stopTracking() {
         locationManager.stopUpdatingLocation()
     }
//    func geoCode(with location: CLLocation) {
//
//        geoCoder.reverseGeocodeLocation(location) { (placemark, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//            } else {
//                self.placemark = placemark?.first
//            }
//        }
//    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            NSLog("Location authorization status changed to '\(status == .authorizedAlways ? "authorizedAlways" : "authorizedWhenInUse")'")
        case .denied, .restricted:
            NSLog("Location authorization status changed to '\(status == .denied ? "denied" : "restricted")'")
            stopTracking()
        case .notDetermined:
            NSLog("Location authorization status changed to 'notDetermined'")
        default:
            NSLog("Location authorization status changed to unknown status '\(status)'")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//
//        DispatchQueue.main.async {
//            self.location = location
//            self.geoCode(with: location)
//        }
        // We are only interested in the user's most recent location.
        guard let location = locations.last else { return }
        // Use the location to update the location manager's published state.
        let coordinate = location.coordinate
        if initialUserCoordinate == nil {
            initialUserCoordinate = coordinate
        }
        currentUserCoordinate = coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Location manager failed with error: \(error)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        authorizationSubject.send(manager.authorizationStatus)
    }
}
