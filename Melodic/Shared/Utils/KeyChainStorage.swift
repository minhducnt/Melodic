//
//  KeyChainStorage.swift
//  Melodic
//
//  Created by TMA on 26/2/25.
//

import Foundation
import Valet

func getValet() -> Valet {
    return Valet.valet(with: Identifier(nonEmpty: "firstfm")!, accessibility: .whenUnlocked)
}
