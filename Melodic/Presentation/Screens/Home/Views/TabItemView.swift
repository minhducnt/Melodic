//
//  TabItemView.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import SwiftUI

struct TabItemView: View {
    // MARK: - Properties

    var title: String
    var icon: String

    // MARK: - Body

    var body: some View {
        VStack {
            ZStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Text(title)
                .font(FontFamily.NotoSans.regular.swiftUIFont(size: 12))
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TabItemView(title: "Home", icon: "house.circle.fill")
}
