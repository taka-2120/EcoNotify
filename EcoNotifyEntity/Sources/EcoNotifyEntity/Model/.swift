//
//  ActivityAttributes.swift
//  EcoNotifyEntity
//
//  Created by Yu Takahashi on 7/21/24.
//

import ActivityKit

public struct EcoNotifyActivityAttributes: ActivityAttributes {
    public init(name: String, color colorCode: String) {
        self.name = name
        self.colorCode = colorCode
    }
    
    public struct ContentState: Codable, Hashable {
        public init() {}
    }
    
    public var name: String
    public var colorCode: String
}
