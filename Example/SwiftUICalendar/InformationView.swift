//
//  InformationView.swift
//  SwiftUICalendar_Example
//
//  Created by GGJJack on 2021/10/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import SwiftUICalendar

extension YearMonthDay: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.year)
        hasher.combine(self.month)
        hasher.combine(self.day)
    }
}

struct InformationView: View {
    
    var informations = [YearMonthDay: [(String, Color)]]()
    
    init() {
        var date = YearMonthDay.current
        informations[date] = []
        informations[date]?.append(("Hello", Color.orange))
        informations[date]?.append(("World", Color.blue))

        date = date.addDay(value: 3)
        informations[date] = []
        informations[date]?.append(("Test", Color.pink))
        
        date = date.addDay(value: 8)
        informations[date] = []
        informations[date]?.append(("Jack", Color.green))
        
        date = date.addDay(value: 5)
        informations[date] = []
        informations[date]?.append(("Home", Color.red))

        date = date.addDay(value: -23)
        informations[date] = []
        informations[date]?.append(("Meet at 8, Home", Color.purple))
        
        date = date.addDay(value: -5)
        informations[date] = []
        informations[date]?.append(("Home", Color.yellow))

        date = date.addDay(value: -10)
        informations[date] = []
        informations[date]?.append(("Baseball", Color.green))
    }

    var body: some View {
        GeometryReader { reader in
            VStack {
                CalendarView(header: { week in
                    GeometryReader { geometry in
                        Text(week.shortString)
                            .font(.subheadline)
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    }
                }, component: { date in
                    GeometryReader { geometry in
                        VStack(alignment: .leading, spacing: 2) {
                            if date.isToday {
                                Text("\(date.day)")
                                    .font(.system(size: 10, weight: .bold, design: .default))
                                    .padding(4)
                                    .foregroundColor(.white)
                                    .background(Color.red.opacity(0.95))
                                    .cornerRadius(14)
                            } else {
                                Text("\(date.day)")
                                    .font(.system(size: 10, weight: .light, design: .default))
                                    .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
                                    .foregroundColor(getColor(date))
                                    .padding(4)
                            }
                            if let infos = informations[date] {
                                ForEach(infos.indices) { index in
                                    let info = infos[index]
                                    Text(info.0)
                                        .lineLimit(1)
                                        .foregroundColor(.white)
                                        .font(.system(size: 8, weight: .bold, design: .default))
                                        .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
                                        .frame(width: geometry.size.width, alignment: .center)
                                        .background(info.1.opacity(0.75))
                                        .cornerRadius(4)
                                        .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
                                }
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                    }
                })
            }
        }
        .navigationBarTitle("Information")
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

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
