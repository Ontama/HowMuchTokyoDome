//
//  PinItem.swift
//  HowMuchTokyoDome
//
//  Created by tomoyo_kageyama on 2022/03/14.
//

import CoreLocation
import Foundation

struct PinItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
