//
//  CardView.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import SwiftUI

struct CardView: View {
    // MARK: - Properties

    var title = "Title"
    var subTitle = "SubTitle"
    var backgroundColor = Color.background
    var cornerRadius = 10.0
    var shadowRadius = 5.0
    var infoAction: () -> Void = {}
    var conditionImage: String = "sun.max"
    var conditionColor: Color = .primarySof

    // MARK: - Body

    var body: some View {
        HStack {
            VStack {
                Spacer()
                Image(systemName: conditionImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .foregroundColor(conditionColor)
                Spacer()
            }
            .padding(.trailing, 16)

            VStack(spacing: 20) {
                Spacer()
                Text(title)
                    .font(.notoSansBold20)
                    .foregroundColor(.primarySof)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(subTitle)
                    .font(.notoSansMedium16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondarySof)
                    .multilineTextAlignment(.leading)
                Spacer()
            }

            VStack {
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.secondarySof)
                Spacer()
            }
        }
        .frame(height: 80)
        .padding()
        .background(backgroundColor)
        .cornerRadius(cornerRadius)
        .shadow(color: .gray.opacity(0.5), radius: shadowRadius)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CardView(
        infoAction: {},
        conditionImage: "sun.max",
        conditionColor: .primarySof
    )
    .padding()
}
