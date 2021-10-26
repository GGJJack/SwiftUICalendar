//
//  CalendarProxy.swift
//  SwiftUICalendar
//
//  Created by GGJJack on 2021/10/25.
//

import SwiftUI
import Combine

public class CalendarController: ObservableObject {
    @Published public var yearMonth: YearMonth
    @Published public var isLocked: Bool
    @Published internal var position: Int = Global.CENTER_PAGE
    @Published internal var internalYearMonth: YearMonth
    
    internal let orientation: Orientation
    internal let columnCount = 7
    internal let rowCount = 6
    internal let max: Int = Global.MAX_PAGE
    internal let center: Int = Global.CENTER_PAGE
    internal let scrollDetector: CurrentValueSubject<CGFloat, Never>
    internal var cancellables = Set<AnyCancellable>()
    
    public init(_ yearMonth: YearMonth = .current, orientation: Orientation = .horizontal, isLocked: Bool = false) {
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        
        self.scrollDetector = detector
        self.internalYearMonth = yearMonth
        self.yearMonth = yearMonth
        self.orientation = orientation
        self.isLocked = isLocked
        
        detector
            .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] value in
                if let self = self {
                    let move = self.position - self.center
                    self.internalYearMonth = self.internalYearMonth.addMonth(value: move)
                    self.yearMonth = self.internalYearMonth
                    self.position = self.center
                }
            }
            .store(in: &cancellables)
    }
    
    public func setYearMonth(year: Int, month: Int) {
        self.setYearMonth(YearMonth(year: year, month: month))
    }
    
    public func setYearMonth(_ yearMonth: YearMonth) {
        self.yearMonth = yearMonth
        self.internalYearMonth = yearMonth
        self.position = self.center
    }
    
    public func scrollTo(year: Int, month: Int, isAnimate: Bool = true) {
        self.scrollTo(YearMonth(year: year, month: month), isAnimate: isAnimate)
    }
    
    public func scrollTo(_ yearMonth: YearMonth, isAnimate: Bool = true) {
        if isAnimate {
            var diff = self.position - yearMonth.diffMonth(value: self.yearMonth)
            if diff < 0 {
                self.internalYearMonth = yearMonth.addMonth(value: self.center)
                diff = 0
                // 4 * 12 + 2 50
            } else if self.max <= diff {
                self.internalYearMonth = yearMonth.addMonth(value: -self.center + 1)
                diff = self.max - 1
            }
            withAnimation { [weak self] in
                if let self = self {
                    self.position = diff
                }
            }
        } else {
            self.internalYearMonth = yearMonth
            self.yearMonth = yearMonth
        }
    }
}
