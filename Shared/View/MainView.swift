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
    @State var isEditing = false
    @State var searchText = ""
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            MapView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("検索したい地点を入れてください",
                              text: $searchText,
                              onEditingChanged: { isEditing in
                        self.isEditing = isEditing
                    })
                    HStack {
                        Button("検索") {
                            
                        }
                        if isEditing {
                            Button(action: {
                                self.searchText = ""
                            }){
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            
                        }
                    }
                }
                HStack {
                    Spacer()
                    CurrentLocationCenterButton(action: {
                        viewModel.currentLocationCenterButtonTappedSubject.send()
                    })
                    .frame(width: 80, height: 80)
                }

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
