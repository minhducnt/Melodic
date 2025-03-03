//
//  ListView.swift
//  Melodic
//
//  Created by Admin on 3/3/25.
//

import SwiftUI

extension View {
    func hasScrollEnabled(_ value: Bool) -> some View {
        self.onAppear {
            UITableView.appearance().isScrollEnabled = value
        }
    }
}
