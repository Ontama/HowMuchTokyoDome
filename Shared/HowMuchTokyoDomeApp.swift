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
    @StateObject var locationManager = LocationManager()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
