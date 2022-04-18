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
            CurrentLocationCenterButton(action: {
                viewModel.currentLocationCenterButtonTappedSubject.send()
            })
            .frame(width: 80, height: 80)
            VStack(alignment: .center) {
                Spacer()
                CircleView()
                    .frame(width: UIScreen.width, height: UIScreen.width, alignment: .center)
                HStack(alignment: .center) {
                    Text("東京ドーム")
                    Text(String(format: "%.1f", viewModel.tokyoDomeCount))
                    Text("個分の大きさ")
                }
                Button("1個分に戻す") {
                    viewModel.oneSizeChangeTappedSubject.send()
                }
                Spacer()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
