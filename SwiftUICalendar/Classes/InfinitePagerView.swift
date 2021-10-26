//
//  InfinitePagerView.swift
//  SwiftUICalendar
//
//  Created by GGJJack on 2021/10/22.
//

import Foundation
import SwiftUI
import Combine

internal struct InfinitePagerView<Content: View>: View {
    private let content: (YearMonth, Int) -> Content
    private let flippingAngle: Angle = Angle(degrees: 0)
    @ObservedObject private var controller: CalendarController
    private var _onMoveCenter: ((Int) -> Void)? = nil
    
    init(_ controller: CalendarController, orientation: Orientation, @ViewBuilder content: @escaping (YearMonth, Int) -> Content) {
        self.controller = controller
        self.content = content
    }
    
    var body: some View {
        drawTabView { geometry in
            ForEach(0..<controller.max, id: \.self) { i in
                let yearMonth = controller.internalYearMonth.addMonth(value: i - Global.CENTER_PAGE)
                self.content(yearMonth, i).frame(width: geometry.size.width, height: geometry.size.height)
                    .background(GeometryReader {
                        Color.clear.preference(key: ScrollOffsetKey.self, value: (controller.orientation == .horizontal ? -$0.frame(in: .named("scroll")).origin.x : -$0.frame(in: .named("scroll")).origin.y))
                    })
                    .onPreferenceChange(ScrollOffsetKey.self) { controller.scrollDetector.send($0) }
            }
        }
    }
    
    private func drawTabView<V: View>(@ViewBuilder content: @escaping (GeometryProxy) -> V) -> some View {
        return GeometryReader { proxy in
            if controller.orientation == .horizontal {
                TabView(selection: $controller.position) {
                    content(proxy)
                        .contentShape(Rectangle())
                        .gesture(controller.isLocked ? DragGesture() : nil)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .coordinateSpace(name: "scroll")
            } else {
                TabView(selection: $controller.position) {
                    content(proxy)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .rotationEffect(.degrees(-90))
                        .rotation3DEffect(flippingAngle, axis: (x: 1, y: 0, z: 0))
                        .contentShape(Rectangle())
                        .gesture(controller.isLocked ? DragGesture() : nil)
                }
                .frame(width: proxy.size.height, height: proxy.size.width)
                .rotation3DEffect(flippingAngle, axis: (x: 1, y: 0, z: 0))
                .rotationEffect(.degrees(90), anchor: .topLeading)
                .offset(x: proxy.size.width)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .coordinateSpace(name: "scroll")
            }
        }
    }
    
    func onMoveCenter(callback: ((Int) -> Void)?) -> Self {
        var ret = self
        ret._onMoveCenter = callback
        return ret
    }
}

fileprivate struct ScrollOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
