//
//  Trash.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/11/24.
//

import Foundation
import SwiftData
import WidgetKit

@Model
public final class Trash {
    @Attribute(.unique)
    public var name: String
    public var category: TrashCategory
    public var next: Date
    @Relationship(deleteRule: .cascade, inverse: \CollectionDate.trash)
    public var date = [CollectionDate]()
    public var notifyDay: NotifyBefore
    public var notifyTime: Date
    public var comment: String
    public var url: String
    
    public init(
        _ name: String,
        category: TrashCategory,
        nextFrom: Date,
        collectOn collectionDates: [CollectionDate],
        notifyOn notifyDay: NotifyBefore,
        at notifyTime: Date,
        comment: String,
        url: String
    ) {
        self.name = name
        self.category = category
        self.next = nextFrom.nextCollection(for: collectionDates)
        self.notifyDay = notifyDay
        self.notifyTime = notifyTime
        self.comment = comment
        self.url = url
    }
}

extension Trash {
    public func update(
        _ name: String,
        category: TrashCategory,
        nextFrom: Date,
        collectOn collectionDates: [CollectionDate],
        notifyOn notifyDay: NotifyBefore,
        at notifyTime: Date,
        comment: String,
        url: String
    ) {
        self.name = name
        self.category = category
        self.next = nextFrom.nextCollection(for: collectionDates)
        self.notifyDay = notifyDay
        self.notifyTime = notifyTime
        self.comment = comment
        self.url = url
    }
    
    public func setNext() {
        let nextCollection = Calendar.current.date(byAdding: .day, value: 1, to: self.next)!
        self.next = nextCollection.nextCollection(for: self.date)
        try? modelContext?.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}

extension Date {
    fileprivate func nextCollection(for collectionDate: [CollectionDate]) -> Date {
        let selfDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
        let todayOfWeek = Calendar.current.dateComponents([.weekday], from: selfDate).weekday!
        var minRemaining = 100
        var nextOrdinalDate: Date? = nil
        
        for date in collectionDate {
            if date.frequency == .every {
                var remaining = date.dayOfWeek.rawValue - todayOfWeek
                if remaining == 0 {
                    return self
                } else if remaining < 0 {
                    remaining += 7
                }
                
                if minRemaining > abs(remaining) {
                    minRemaining = remaining
                }
            } else {
                var count = 0
                
                while nextOrdinalDate == nil || nextOrdinalDate! < selfDate {
                    var calendar = Calendar.current
                    calendar.timeZone = .current
                    let today = calendar.dateComponents([.year, .month], from: selfDate)
                    
                    var components = DateComponents()
                    components.year = today.year!
                    components.month = today.month! + count
                    components.weekday = date.dayOfWeek.rawValue
                    components.weekdayOrdinal = date.frequency.rawValue

                    let nextDate = Calendar.current.date(from: components) ?? selfDate
                    nextOrdinalDate = nextDate
                    count += 1
                }
            }
        }
        
        let nextDate = Calendar.current.date(byAdding: .day, value: minRemaining, to: selfDate)!
        guard let nextOrdinalDate = nextOrdinalDate else {
            return nextDate
        }
        return nextOrdinalDate < nextDate ? nextOrdinalDate : nextDate
    }
}
