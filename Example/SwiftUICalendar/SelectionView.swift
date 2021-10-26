//
//  SelectionView.swift
//  SwiftUICalendar_Example
//
//  Created by GGJJack on 2021/10/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftUICalendar

struct SelectionView: View {
    @ObservedObject var controller: CalendarController = CalendarController()
    @State var focusDate: YearMonthDay? = YearMonthDay.current
    
    var body: some View {
        GeometryReader { reader in
            VStack {
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
                            .border(.green.opacity(0.8), width: (focusDate == date ? 1 : 0))
                            .cornerRadius(2)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                focusDate = (date != focusDate ? date : nil)
                            }
                    }
                })
            }
        }
        .navigationBarTitle("Selection")
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView()
    }
}
