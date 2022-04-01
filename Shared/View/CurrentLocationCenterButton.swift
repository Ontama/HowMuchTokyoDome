//
//  CurrentLocationCenterButton.swift
//  HowMuchTokyoDome (iOS)
//
//  Created by tomoyo_kageyama on 2022/04/01.
//

import SwiftUI
import Combine

struct CurrentLocationCenterButton: View {
    var buttonTappedPublisher: PassthroughSubject<Bool, Never>

    var body: some View {
        Button(action: {
            self.buttonTappedPublisher.send(true)
        }) {
            Image(systemName: "location.fill")
                .imageScale(.large)
                .accessibility(label: Text("Center map"))
        }
    }
}

struct CurrentLocationCenterButton_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationCenterButton(buttonTappedPublisher: MapViewModel().currentLocationCenterButtonTappedPublisher)
    }
}
