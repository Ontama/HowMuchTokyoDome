//
//  MapViewModel.swift
//  HowMuchTokyoDome
//
//  Created by tomoyo_kageyama on 2022/03/14.
//

import CoreLocation
import Combine

enum Event: String {
    case currentLocation
    case oneSize
}

final class MapViewModel: ObservableObject {
    // MapViewのupdateUIViewを呼ばれないようにするフラグ
    // updateUIViewで制御しないとmapViewDidChangeVisibleRegionが呼ばれたときにupdateUIViewが呼ばれループする
    var shouldUpdateView = true
    
    @Published var event = Event.currentLocation
    
//    @Published var authorizationStatus = CLAuthorizationStatus.notDetermined
    @Published var mapCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    // 東京ドーム何個分か
    @Published var tokyoDomeCount = 0.0
    // 面積(km2)
    var dimensions = 0.0
    var centerLocation = CLLocationCoordinate2D()
    
    private(set) var distanceSubject = PassthroughSubject<Double, Never>()
    // 1個分の大きさに戻す
    private(set) var oneSizeChangeTappedSubject = PassthroughSubject<Void, Never>()
    // 現在地を中心に地図を戻す
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
        coordinatePublisher.receive(on: DispatchQueue.main)
            .assign(to: \.mapCenter, on: self)
            .store(in: &cancellableSet)
        currentLocationCenterButtonTappedSubject
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.event = .currentLocation
            }).store(in: &cancellableSet)
        oneSizeChangeTappedSubject
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.event = .oneSize
            }).store(in: &cancellableSet)
        distanceSubject
            .throttle(for: .seconds(0.1), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] distance in
            guard let self = self else { return }
            let radius = distance / 2
            self.dimensions = Double(radius * radius * 3.14)
            self.tokyoDomeCount = self.dimensions / TokyoDomeInfo.squareMeter
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
