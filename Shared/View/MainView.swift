//
//  MainView.swift
//  HowMuchTokyoDome
//
//  Created by tomoyo_kageyama on 2022/03/07.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MainView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        ZStack(alignment: .topTrailing) {
            MapView(viewModel: viewModel)
            LocationButton {
                viewModel.changeCurrentLocation()
            }
            .labelStyle(.iconOnly)
            .cornerRadius(24)
            .frame(width: 80, height: 80)
        }.onAppear {
            viewModel.activate()
        }.onDisappear {
            viewModel.deactivate()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: ViewModel(model: LocationDataSource()))
    }
}


