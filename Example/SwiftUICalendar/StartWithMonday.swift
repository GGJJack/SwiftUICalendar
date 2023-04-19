//
//  StartWithMonday.swift
//  SwiftUICalendar_Example
//
//  Created by Jack on 2023/04/19.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftUICalendar

struct StartWithMondayView: View {
    
    @ObservedObject var controller: CalendarController = CalendarController(orientation: .vertical)
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: 0) {
                Text("\(controller.yearMonth.monthShortString), \(String(controller.yearMonth.year))")
                    .font(.title)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                HStack(alignment: .center, spacing: 0) {
                    ForEach(0..<7, id: \.self) { i in
                        Text(DateFormatter().shortWeekdaySymbols[(i + 1) % 7])
                            .font(.headline)
                            .frame(width: reader.size.width / 7)
                    }
                }
                CalendarView(controller, startWithMonday: true) { date in
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
                                    .foregroundColor(getColor(date))
                                    .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
                            }
                        }
                    }
                }
                .navigationBarTitle("Start With Monday")
            }
        }
    }
    
    private func getColor(_ date: YearMonthDay) -> Color {
        if date.dayOfWeek == .sun {
            return Color.red
        } else if date.dayOfWeek == .sat {
            return Color.blue
        } else {
            return Color.black
        }
    }
}

struct StartWithMondayView_Previews: PreviewProvider {
    static var previews: some View {
        StartWithMondayView()
    }
}
