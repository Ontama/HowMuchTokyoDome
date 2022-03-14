//
//  Location.swift
//  HowMuchTokyoDome
//
//  Created by tomoyo_kageyama on 2022/03/07.
//

import Foundation
import CoreLocation

class Location : ObservableObject {
    @Published var coordinate = CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868)
}
