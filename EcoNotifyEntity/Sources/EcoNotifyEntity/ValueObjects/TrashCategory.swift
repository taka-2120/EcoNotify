//
//  TrashCategory.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftUI

public enum TrashCategory: CaseIterable, Codable {
    case burnable
    case notBurnable
    case plastic
    case plasticBottle
    case bottle
    case newspaper
    case magazine
    case cardboard
}
