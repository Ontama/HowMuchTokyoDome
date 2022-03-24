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

