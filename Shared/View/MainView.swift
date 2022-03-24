//
//  MainView.swift
//  HowMuchTokyoDome
//
//  Created by tomoyo_kageyama on 2022/03/07.
//

import SwiftUI
import MapKit

struct MainView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Button("request") {
                    viewModel.requestAuthorization()
                }
                Button("start") {
                    viewModel.startTracking()
                    viewModel.changeCurrentLocation()
                }
                Button("stop") {
                    viewModel.stopTracking()
                }
                Button("現在地") {
                    viewModel.changeCurrentLocation()
                }
            }
            Text(viewModel.authorizationStatus.description)
            Text(String(format: "longitude: %f", viewModel.longitude))
            Text(String(format: "latitude: %f", viewModel.latitude))
            MapView(viewModel: viewModel)
        }.onAppear {
            viewModel.activate()
        }.onDisappear {
            viewModel.deactivate()
        }
    }
}


