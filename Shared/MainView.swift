//
//  MainView.swift
//  HowMuchTokyoDome
//
//  Created by tomoyo_kageyama on 2022/03/07.
//

import SwiftUI
import MapKit

struct MainView: View {
    var latitude: Double // 緯度
    var longitude: Double // 経度
    var body: some View {
        MapView(latitude: latitude, longitude: latitude)
    }
}

