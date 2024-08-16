//
//  Licenses.swift
//  EcoNotifyCore
//
//  Created by Yu Takahashi on 8/16/24.
//

import EcoNotifyEntity
import Foundation
import UIKit

extension Licenses {
    public var data: String {
        let url = Bundle.main.url(forResource: self.rawValue, withExtension: "txt")!
        return try! String(contentsOf: url, encoding: .utf8)
    }
}
