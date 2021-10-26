//
//  HorizontalView.swift
//  SwiftUICalendar_Example
//
//  Created by GGJJack on 2021/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftUICalendar

struct CalendarScrollView: View {
    
    @ObservedObject var controller: CalendarController = CalendarController()
    @State var focusDate: YearMonth = YearMonth.current
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Button("Older") {
                        controller.scrollTo(YearMonth(year: 1500, month: 1), isAnimate: true)
                    }
                    Spacer()
                    Button("Not Ani") {
                        controller.scrollTo(YearMonth.current, isAnimate: false)
                    }
                    Spacer()
                    Button("Animate") {
                        controller.scrollTo(YearMonth.current, isAnimate: true)
                    }
                    Spacer()
                    Button("Future") {
                        controller.scrollTo(YearMonth(year: 2500, month: 1), isAnimate: true)
                    }
                    Spacer()
                }
                Text("\(controller.yearMonth.monthShortString), \(String(controller.yearMonth.year))")
                    .font(.title)
                    .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                HStack(alignment: .center, spacing: 0) {
                    ForEach(0..<7, id: \.self) { i in
                        Text(DateFormatter().shortWeekdaySymbols[i])
                            .font(.headline)
                            .frame(width: reader.size.width / 7)
                    }
                }
                CalendarView(controller) { date in
                    GeometryReader { geometry in
                        Text("\(date.day)")
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                            .font(.system(size: 10, weight: .light, design: .default))
                            .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
                    }
                }
                .navigationBarTitle("Calendar Scroll")
            }
        }
    }
}

struct CalendarScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarScrollView()
    }
}
