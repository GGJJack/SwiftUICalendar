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
    @Published internal var position: Int
    @Published internal var internalYearMonth: YearMonth
    
    internal let orientation: Orientation
    internal let columnCount = 7
    internal let rowCount = 6
    internal let max: Int
    internal let center: Int
    internal let scrollDetector: CurrentValueSubject<CGFloat, Never>
    internal var cancellables = Set<AnyCancellable>()
    
    private let dateRange: ClosedRange<YearMonth>?
    
    public init(
        _ yearMonth: YearMonth = .current,
        orientation: Orientation = .horizontal,
        isLocked: Bool = false,
        dateRange: ClosedRange<YearMonth>? = nil
    ) {
        let detector = CurrentValueSubject<CGFloat, Never>(0)
        
        self.scrollDetector = detector
        self.orientation = orientation
        self.isLocked = isLocked
        self.internalYearMonth = yearMonth
        self.yearMonth = yearMonth
        self.dateRange = dateRange
        
        if let limit = dateRange {
            let count = limit.lowerBound.distance(to: limit.upperBound) + 1
            
            // just crash, rather than introduce strange behaviour
            guard limit.contains(yearMonth) else { fatalError("yearMonth not in dateRange")}
            
            self.max = count
            
            let dates = limit.map { $0 }
            
            // set the tab position to the right place
            let index = dates.firstIndex(of: yearMonth)!
            self.position = index
            
            // due to the way InfinitePager draws the TabView content
            // setting center to self.position creates correct month dates to be drawn
            self.center = index
            
            detector
                .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
                .dropFirst()
                .sink { [weak self] value in
                    guard let self = self else { return }
                    self.yearMonth = dates[position]
                    self.objectWillChange.send()
                }
                .store(in: &cancellables)
            
        } else {
            
            // infinite scroll
            // the position is always at the center tab of all the TabView content
            // when scrolled, all the views are redrawn around the new center
            //
            // make 100 content tabs for the TabView
            self.max = 100
            self.center = 50
            self.position = 50
            
            detector
                .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
                .dropFirst()
                .sink { [weak self] value in
                    guard let self = self else { return }
                    let move = self.position - self.center
                    self.internalYearMonth = self.internalYearMonth.addMonth(value: move)
                    self.yearMonth = self.internalYearMonth
                    self.position = self.center
                    self.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    }
    
    public func setYearMonth(year: Int, month: Int) {
        self.setYearMonth(YearMonth(year: year, month: month))
    }
    
    public func setYearMonth(_ yearMonth: YearMonth) {
        self.yearMonth = yearMonth
        self.internalYearMonth = yearMonth
        self.position = self.center
        self.objectWillChange.send()
    }
    
    public func scrollTo(year: Int, month: Int, isAnimate: Bool = true) {
        self.scrollTo(YearMonth(year: year, month: month), isAnimate: isAnimate)
    }
    
    public func scrollTo(_ yearMonth: YearMonth, isAnimate: Bool = true) {
        
        // a range limited scrol
        if let range = dateRange {
            guard range.contains(yearMonth) else { return }
            
            let dates = range.map { $0 }
            guard let index = dates.firstIndex(of: yearMonth) else { return }
            
            if isAnimate {
                withAnimation { [weak self] in
                    guard let self = self else { return }
                    self.position = index
                    self.objectWillChange.send()
                }
            } else {
                self.position = index
            }
            
        } else {
            // Infinite scroll
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
                self.objectWillChange.send()
                withAnimation { [weak self] in
                    guard let self = self else { return }
                    self.position = diff
                    self.objectWillChange.send()
                }
            } else {
                self.internalYearMonth = yearMonth
                self.yearMonth = yearMonth
                self.objectWillChange.send()
            }
        }
    }
}
