//
//  CurrentLocationCenterButton.swift
//  HowMuchTokyoDome (iOS)
//
//  Created by tomoyo_kageyama on 2022/04/01.
//

import SwiftUI
import Combine

struct CurrentLocationCenterButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "location.fill")
                .imageScale(.large)
                .accessibility(label: Text("Center map"))
        }
    }
}

struct CurrentLocationCenterButton_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationCenterButton(action: {})
    }
}
