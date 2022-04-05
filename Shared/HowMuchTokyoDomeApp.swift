//
//  HowMuchTokyoDomeApp.swift
//  Shared
//
//  Created by tomoyo_kageyama on 2022/03/07.
//

import SwiftUI

@main
struct HowMuchTokyoDomeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
