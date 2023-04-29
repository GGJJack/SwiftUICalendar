//
//  LimitScrollRange.swift
//  SwiftUICalendar_Example
//
//  Created by Benson Wong on 2023-04-28.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftUICalendar
struct LimitScrollRange: View {
    @ObservedObject var controller: CalendarController
    private let range: ClosedRange<YearMonth>
    
    init() {
        let yearMonth = YearMonth.current
        range = yearMonth.addMonth(value: -5)...yearMonth.addMonth(value: 5)
        
        // for one way ranges
        // range = yearMonth.addMonth(value: -6)...yearMonth
        // range = yearMonth...yearMonth.addMonth(value: 6)
        
        self.controller = .init(yearMonth, orientation: .horizontal, dateRange: range)
    }
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: 0) {
                Text("\(controller.yearMonth.monthShortString), \(String(controller.yearMonth.year))")
                    .font(.title)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Button("Drag Lock") {
                        controller.isLocked = true
                    }
                    Spacer()
                    Button("Drag Unlock") {
                        controller.isLocked = false
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Button("Lower") {
                        controller.scrollTo(range.lowerBound)
                    }
                    Spacer()
                    
                    Button("Today Fast") {
                        controller.scrollTo(.current, isAnimate: false)
                    }
                    Spacer()
                    
                    Button("Today") {
                        controller.scrollTo(.current)
                    }
                    Spacer()
                    
                    Button("Upper") {
                        controller.scrollTo(range.upperBound)
                    }
                    Spacer()
                }
                
                HStack(alignment: .center, spacing: 0) {
                    ForEach(0..<7, id: \.self) { i in
                        Text(DateFormatter().shortWeekdaySymbols[i])
                            .font(.headline)
                            .frame(width: reader.size.width / 7)
                    }
                }
                CalendarView(controller) { date in
                    GeometryReader { geometry in
                        ZStack(alignment: .center) {
                            if date.isToday {
                                Circle()
                                    .padding(4)
                                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                    .foregroundColor(.orange)
                                Text("\(date.day)")
                                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                    .font(.system(size: 10, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                            } else {
                                Text("\(date.day)")
                                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                                    .font(.system(size: 10, weight: .light, design: .default))
                                    .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
                            }
                        }
                    }
                }
                .navigationBarTitle("Limit Scroll Range")
            }
        }
    }
}

struct LimitScrollRange_Previews: PreviewProvider {
    static var previews: some View {
        LimitScrollRange()
    }
}
