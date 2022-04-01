//
//  MapViewModel.swift
//  HowMuchTokyoDome
//
//  Created by tomoyo_kageyama on 2022/03/14.
//

import CoreLocation
import Combine
import SwiftUI

final class MapViewModel: ObservableObject {
    @Published var authorizationStatus = CLAuthorizationStatus.notDetermined
    @Published var mapCenter : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    // A subject whose `send(_:)` method is being called from within the CurrentLocationCenterButton view to center the map on the user's location.
    public var currentLocationCenterButtonTappedPublisher = PassthroughSubject<Bool, Never>()
    
    // A publisher that turns a "center button tapped" event into a coordinate.
    private var currentLocationCenterButtonTappedCoordinatePublisher: AnyPublisher<CLLocationCoordinate2D?, Never> {
        currentLocationCenterButtonTappedPublisher
            .map { _ in
                print ("new loc in pub: ", LocationManager.shared.currentUserCoordinate)
                return LocationManager.shared.currentUserCoordinate
            }
            .eraseToAnyPublisher()
    }
    
    private var coordinatePublisher: AnyPublisher<CLLocationCoordinate2D, Never> {
        Publishers.Merge(LocationManager.shared.$initialUserCoordinate, currentLocationCenterButtonTappedCoordinatePublisher)
            .replaceNil(with: CLLocationCoordinate2D(latitude: 2.0, longitude: 2.0))
            .eraseToAnyPublisher()
    }
    private var cancellableSet = Set<AnyCancellable>()
    
    init() {
        self.coordinatePublisher.receive(on: DispatchQueue.main)
            .assign(to: \.mapCenter, on: self)
            .store(in: &cancellableSet)
    }
    
    var latitude: CLLocationDegrees {
        mapCenter.latitude
    }
    
    var longitude: CLLocationDegrees {
        mapCenter.longitude
    }
    
    func requestAuthorization() {
        LocationManager.shared.requestAuthorization()
    }
    
    func startTracking() {
        LocationManager.shared.startTracking()
    }
    
    func stopTracking() {
        LocationManager.shared.stopTracking()
    }
}
