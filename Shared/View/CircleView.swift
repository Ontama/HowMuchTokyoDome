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
            .frame(width: UIScreen.width, height: UIScreen.width )
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}
