//
//  CollectionDate.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import SwiftData

@Model
public final class CollectionDate: Equatable {
    public var frequency: Frequency
    public var dayOfWeek: DayOfWeek
    public var trash: Trash?
    
    public init(on frequency: Frequency, _ dayOfWeek: DayOfWeek, in trash: Trash) {
        self.frequency = frequency
        self.dayOfWeek = dayOfWeek
        self.trash = trash
    }
    
    public init(on frequency: Frequency, _ dayOfWeek: DayOfWeek) {
        self.frequency = frequency
        self.dayOfWeek = dayOfWeek
    }
}

extension Array where Element == CollectionDate {
    public func sort() -> [Element] {
        self.sorted { $0.dayOfWeek.rawValue < $1.dayOfWeek.rawValue }
    }
}
