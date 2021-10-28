//
//  CalendarView.swift
//  SwiftUICalendar
//
//  Created by GGJJack on 2021/10/26.
//

import SwiftUI
import Combine

public struct CalendarView<CalendarCell: View, HeaderCell: View>: View {
    
    private var gridItem: [GridItem] = Array(repeating: .init(.flexible(), spacing: 0), count: 7) // columnCount
    private let component: (YearMonthDay) -> CalendarCell
    private let header: (Week) -> HeaderCell?
    private var headerSize: HeaderSize
    @ObservedObject private var controller: CalendarController
    private let isHasHeader: Bool
    
    public init(
        _ controller: CalendarController = CalendarController(),
        @ViewBuilder component: @escaping (YearMonthDay) -> CalendarCell
    ) where HeaderCell == EmptyView {
        self.controller = controller
        self.header = { _ in nil }
        self.component = component
        self.isHasHeader = false
        self.headerSize = .zero
    }
    
    public init(
        _ controller: CalendarController = CalendarController(),
        headerSize: HeaderSize = .fixHeight(40),
        @ViewBuilder header: @escaping (Week) -> HeaderCell,
        @ViewBuilder component: @escaping (YearMonthDay) -> CalendarCell
    ) {
        self.controller = controller
        self.header = header
        self.component = component
        self.isHasHeader = true
        self.headerSize = headerSize
    }
    
    public var body: some View {
        GeometryReader { proxy in
            InfinitePagerView(controller, orientation: controller.orientation) { yearMonth, i in
                LazyVGrid(columns: gridItem, alignment: .center, spacing: 0) {
                    ForEach(0..<(controller.columnCount * (controller.rowCount + (isHasHeader ? 1 : 0))), id: \.self) { j in
                        GeometryReader { geometry in
                            if isHasHeader && j < controller.columnCount {
                                header(Week.allCases[j])
                            } else {
                                let date = yearMonth.cellToDate(j - (isHasHeader ? 7 : 0))
                                self.component(date)
                            }
                        }
                        .frame(height: calculateCellHeight(j, geometry: proxy))
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            }
        }
    }
    
    func calculateCellHeight(_ index: Int, geometry: GeometryProxy) -> CGFloat {
        if !isHasHeader {
            return geometry.size.height / CGFloat(controller.rowCount)
        }

        var headerHeight: CGFloat = 0
        switch headerSize {
        case .zero:
            headerHeight = 0
        case .ratio:
            headerHeight = geometry.size.height / CGFloat(controller.rowCount + 1)
        case .fixHeight(let value):
            headerHeight = value
        }

        if index < controller.columnCount {
            return headerHeight
        } else {
            return (geometry.size.height - headerHeight) / CGFloat(controller.rowCount)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(CalendarController()) { date in
            GeometryReader { geometry in
                Text("\(String(date.year))/\(date.month)/\(date.day)")
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                    .border(.black, width: 1)
                    .font(.system(size: 8))
                    .opacity(date.isFocusYearMonth == true ? 1 : 0.6)
            }
        }
    }
}
