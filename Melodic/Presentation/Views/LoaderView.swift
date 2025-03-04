//
//  LoaderView.swift
//  Melodic
//
//  Created by Admin on 28/2/25.
//

import SwiftUI

struct LoaderView: View {
    var isLoading = true

    var body: some View {
        if isLoading {
            VStack {
                ProgressView()
            }
            .padding(40)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct LoaderViewModifier: ViewModifier {
    var isLoading: Bool

    func body(content: Content) -> some View {
        content
            .overlay(LoaderView(isLoading: isLoading))
    }
}

extension View {
    func loader(_ value: Bool) -> some View {
        modifier(LoaderViewModifier(isLoading: value))
    }
}

#Preview {
    Rectangle()
        .loader(true)
}
