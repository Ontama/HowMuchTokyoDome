//
//  MainView.swift
//  HowMuchTokyoDome
//
//  Created by tomoyo_kageyama on 2022/03/07.
//

import SwiftUI
import MapKit
import Combine

struct MainView: View {
    @StateObject var viewModel = MapViewModel()
    var body: some View {
        ZStack(alignment: .topTrailing) {
            MapView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            VStack {
                CurrentLocationCenterButton(buttonTappedPublisher: viewModel.currentLocationCenterButtonTappedPublisher)
                .frame(width: 80, height: 80)
            }
            VStack(alignment: .center) {
                CircleView()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            }
            VStack {
                Spacer()
                Button {
                    
                } label: {
                    Text("大きさを変更する")
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 20)
            }
        
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            
        }.onAppear {
            viewModel.activate()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
