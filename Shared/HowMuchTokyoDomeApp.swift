//
//  HowMuchTokyoDomeApp.swift
//  Shared
//
//  Created by tomoyo_kageyama on 2022/03/07.
//

import SwiftUI
import CoreLocation

@main
struct HowMuchTokyoDomeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewModel = ViewModel(model: LocationDataSource())
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: viewModel)
        }
    }
}

class Parameter : ObservableObject {
    @Published var locationManager = CLLocationManager()
}

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    @ObservedObject var param = Parameter()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        param.locationManager.delegate = self
        
        param.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            param.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            param.locationManager.distanceFilter = 10
            param.locationManager.activityType = .fitness
            param.locationManager.startUpdatingLocation()
        }
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        let location = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        
        print("緯度: ", location.latitude, "経度: ", location.longitude)

    }
    
}
