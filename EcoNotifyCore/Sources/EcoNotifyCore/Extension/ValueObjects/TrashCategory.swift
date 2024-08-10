//
//  TrashCategory.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUI
import EcoNotifyEntity

extension TrashCategory {
    public var label: LocalizedStringResource {
        switch self {
        case .burnable: "burnable"
        case .notBurnable: "notBurnable"
        case .plastic: "plastic"
        case .plasticBottle: "plasticBottle"
        case .bottle: "bottle"
        case .newspaper: "newspaper"
        case .magazine: "magazine"
        case .cardboard: "cardboard"
        }
    }
    
    public var image: ImageResource {
        switch self {
        case .burnable: .burnable
        case .notBurnable: .notBurnable
        case .plastic: .plastic
        case .plasticBottle: .plasticBottle
        case .bottle: .burnable
        case .newspaper: .newspaper
        case .magazine: .magazine
        case .cardboard: .cardboard
        }
    }
}
