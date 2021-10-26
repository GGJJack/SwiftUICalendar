//
//  Week.swift
//  SwiftUICalendar
//
//  Created by GGJJack on 2021/10/26.
//

public enum Week: Int, CaseIterable {
    case sun = 0
    case mon = 1
    case tue = 2
    case wed = 3
    case thu = 4
    case fri = 5
    case sat = 6
    
    public var shortString: String {
        get {
            return DateFormatter().shortWeekdaySymbols[self.rawValue]
        }
    }
}
