//
//  VerticalView.swift
//  SwiftUICalendar_Example
//
//  Created by GGJJack on 2021/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftUICalendar

struct EmbedHeaderView: View {
    
    @ObservedObject var controller: CalendarController = CalendarController()

    var body: some View {
        GeometryReader { reader in
            VStack {
                HStack(alignment: .center, spacing: 0) {
                    Button("Prev") {
                        controller.scrollTo(controller.yearMonth.addMonth(value: -1), isAnimate: true)
                    }
                    .padding(8)
                    Spacer()
                    Text("\(controller.yearMonth.monthShortString), \(String(controller.yearMonth.year))")
                        .font(.title)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    Spacer()
                    Button("Next") {
                        controller.scrollTo(controller.yearMonth.addMonth(value: 1), isAnimate: true)
                    }
                    .padding(8)
                }
                CalendarView(controller, header: { week in
                    GeometryReader { geometry in
                        Text(week.shortString)
                            .font(.subheadline)
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                }, component: { date in
                    GeometryReader { geometry in
                        Text("\(date.day)")
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                            .font(.system(size: 10, weight: .light, design: .default))
                            .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
                    }
                })
            }
        }
        .navigationBarTitle("Embed header")
    }
}

struct EmbedHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        EmbedHeaderView()
    }
}
