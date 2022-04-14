//
//  MapViewModel.swift
//  HowMuchTokyoDome
//
//  Created by tomoyo_kageyama on 2022/03/14.
//

import CoreLocation
import Combine

final class MapViewModel: ObservableObject {
    // MapViewのupdateUIViewを呼ばれないようにするフラグ
    // updateUIViewで制御しないとmapViewDidChangeVisibleRegionが呼ばれたときにupdateUIViewが呼ばれループする
    var shouldUpdateView: Bool = true
    
//    @Published var authorizationStatus = CLAuthorizationStatus.notDetermined
    @Published var mapCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    // 東京ドーム何個分か
    @Published var tokyoDomeCount = 0.0
    // 面積(km2)
    var dimensions = 0.0
    // 画面上に表示されている東西の距離
//    @Published var distance = Double(0)
    private(set) var distanceSubject = PassthroughSubject<Double, Never>()
    // 東京ドームの大きさ(平方m)
    private let tokyoDomeSquareMeter = Double(46755)
    
    
    
    // A subject whose `send(_:)` method is being called from within the CurrentLocationCenterButton view to center the map on the user's location.
    private(set) var currentLocationCenterButtonTappedSubject = PassthroughSubject<Void, Never>()
    
    // A publisher that turns a "center button tapped" event into a coordinate.
    private var currentLocationCenterButtonTappedCoordinatePublisher: AnyPublisher<CLLocationCoordinate2D?, Never> {
        currentLocationCenterButtonTappedSubject
            .map { _ in
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
//        self.distanceSubject
//            .assign(to: \.distance, on: self)
//            .store(in: &cancellableSet)
        self.distanceSubject.sink { [weak self] distance in
            print("distance \(distance)")
            guard let self = self else { return }
            let radius = distance / 2
            self.dimensions = Double(radius * radius * 3.14)
            self.tokyoDomeCount = self.dimensions / self.tokyoDomeSquareMeter
        }.store(in: &cancellableSet)
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
