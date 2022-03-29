//
//  CircleView.swift
//  HowMuchTokyoDome (iOS)
//
//  Created by tomoyo_kageyama on 2022/03/28.
//

import SwiftUI

struct CircleView: View {
    var body: some View {
        Circle()
            .stroke(lineWidth: 3)
            .fill(Color.red)
            .frame(width: 200, height: 200)
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}
