# SwiftUICalendar

[![Version](https://img.shields.io/cocoapods/v/SwiftUICalendar.svg?style=flat)](https://cocoapods.org/pods/SwiftUICalendar)
[![License](https://img.shields.io/cocoapods/l/SwiftUICalendar.svg?style=flat)](https://cocoapods.org/pods/SwiftUICalendar)
[![Platform](https://img.shields.io/cocoapods/p/SwiftUICalendar.svg?style=flat)](https://cocoapods.org/pods/SwiftUICalendar)

## Installation

### [CocoaPods](https://cocoapods.org)

```ruby
pod 'SwiftUICalendar'
```

### import

```swift
import SwiftUICalendar
```

## Features

- Infinite scroll
- Support horizontal and vertical scroll
- Full custom calendar cell
- Pager lock

## Example

### Basic

```swift
CalendarView() { date in
    Text("\(date.day)")
}
```

### Basic use

![Basic Use](https://github.com/GGJJack/SwiftUICalendar/blob/master/img/basic_use.gif?raw=true)

<details>
<summary>Show example code</summary>
<p>

```swift
struct BasicUseView: View {
    @ObservedObject var controller: CalendarController = CalendarController(orientation: .vertical)
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: 0) {
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
            }
        }
    }
}
```

</p>
</details>

### Calendar scroll

![Basic Use](https://github.com/GGJJack/SwiftUICalendar/blob/master/img/calendar_scroll.gif?raw=true)

<details>
<summary>Show example code</summary>
<p>

```swift
struct CalendarScrollView: View {
    @ObservedObject var controller: CalendarController = CalendarController()
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Button("Older") {
                        controller.scrollTo(YearMonth(year: 1500, month: 1), isAnimate: true)
                    }
                    Spacer()
                    Button("Today") {
                        controller.scrollTo(YearMonth.current, isAnimate: false)
                    }
                    Spacer()
                    Button("Today Scroll") {
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
```

</p>
</details>

### Embed Header

![Basic Use](https://github.com/GGJJack/SwiftUICalendar/blob/master/img/embed_header.gif?raw=true)

<details>
<summary>Show example code</summary>
<p>

```swift

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
```

</p>
</details>

### Information

![Basic Use](https://github.com/GGJJack/SwiftUICalendar/blob/master/img/information.gif?raw=true)

<details>
<summary>Show example code</summary>
<p>

```swift
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
```

</p>
</details>

### Selection

![Basic Use](https://github.com/GGJJack/SwiftUICalendar/blob/master/img/selection.gif?raw=true)

<details>
<summary>Show example code</summary>
<p>

```swift

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
```

</p>
</details>

### Information + Selection

![Basic Use](https://github.com/GGJJack/SwiftUICalendar/blob/master/img/info_with_select.gif?raw=true)

<details>
<summary>Show example code</summary>
<p>

```swift

struct InformationWithSelectionView: View {
    let controller = CalendarController()
    var informations = [YearMonthDay: [(String, Color)]]()
    @State var focusDate: YearMonthDay? = nil
    @State var focusInfo: [(String, Color)]? = nil

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
                CalendarView(controller, header: { week in
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
                                    if focusInfo != nil {
                                        Rectangle()
                                            .fill(info.1.opacity(0.75))
                                            .frame(width: geometry.size.width, height: 4, alignment: .center)
                                            .cornerRadius(2)
                                            .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
                                    } else {
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
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                        .border(.green.opacity(0.8), width: (focusDate == date ? 1 : 0))
                        .cornerRadius(2)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                if focusDate == date {
                                    focusDate = nil
                                    focusInfo = nil
                                } else {
                                    focusDate = date
                                    focusInfo = informations[date]
                                }
                            }
                        }
                    }
                })
                if let infos = focusInfo {
                    List(infos.indices, id: \.self) { index in
                        let info = infos[index]
                        HStack(alignment: .center, spacing: 0) {
                            Circle()
                                .fill(info.1.opacity(0.75))
                                .frame(width: 12, height: 12)
                            Text(info.0)
                                .padding(.leading, 8)
                        }
                    }
                    .frame(width: reader.size.width, height: 160, alignment: .center)
                }
            }
        }
        .navigationBarTitle("Info + Select")
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

```

</p>
</details>



## Struct

### CalendarView

```Swift
public struct CalendarView<CalendarCell: View, HeaderCell: View>: View {
    public init(
        _ controller: CalendarController = CalendarController(),
        @ViewBuilder component: @escaping (YearMonthDay) -> CalendarCell
    ) {
        ...
    }
    public init(
        _ controller: CalendarController = CalendarController(),
        headerSize: HeaderSize = .fixHeight(40),
        @ViewBuilder header: @escaping (Week) -> HeaderCell,
        @ViewBuilder component: @escaping (YearMonthDay) -> CalendarCell
    ) {
        ...
    }
    
    ...
}
```

### HeaderSize

```Swift
public enum HeaderSize {
    case zero
    case ratio
    case fixHeight(CGFloat)
}
```

### CalendarController

```Swift
public class CalendarController: ObservableObject {
    public init(
        _ yearMonth: YearMonth = .current, 
        orientation: Orientation = .horizontal,
        isLocked: Bool = false
    )
    
    ...
}

var verticalController = CalendarController(
    YearMonth.current,
    orientation: .vertical,
    isLocked: true
)

var controller = CalendarController()

// Scroll with animate
controller.scrollTo(year: 1991, month: 2, isAnimate: true)

// Scroll without animate
controller.scrollTo(YearMonth.current, isAnimate: false)

// Lock Pager
controller.isLocked = true

```

### YearMonth

```Swift
public struct YearMonth: Equatable {
    public let year: Int
    public let month: Int
    
    public init(year: Int, month: Int) { ... }
    
    ...
}

let date = YearMonth(year: 2021, month: 10)
let now = YearMonth.current // Now

print(date.monthShortString) // Oct // Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

let nextMonth = date.addMonth(value: 1) // {year: 2021, month: 11}

let diff = nextMonth.diffMonth(value: date) // 2021/11 - 2021/10 = 1

let components: DateComponents = nextMonth.toDateComponents()

```

### YearMonthDay

```Swift
public struct YearMonthDay: Equatable {
    public let year: Int
    public let month: Int
    public let day: Int
    public let isFocusYearMonth: Bool?
    
    public init(year: Int, month: Int, day: Int) { ... }
        
    public init(year: Int, month: Int, day: Int, isFocusYearMonth: Bool) { ... }
    
    ...
}

let date = YearMonthDay(year: 2021, month: 10, day: 26)
let now = YearMonthDay.current

let isToday = now.isToday // true

let dayOfWeek: Week = date.dayOfWeek // Tue // Sun, Mon, Tue, Wed, Thu, Fri, Sat

let toDate = date.date! // { 2021/10/26 }

let components: DateComponents = date.toDateComponents()

let tomorrow = date.addDay(value: 1) // {year: 2021, month: 10, day: 27}

let diff = tomorrow.diffDay(value: date) // 2021/10/27 - 2021/10/26 = 1
```

### Week

```Swift
public enum Week: Int, CaseIterable {
    case sun = 0
    case mon = 1
    case tue = 2
    case wed = 3
    case thu = 4
    case fri = 5
    case sat = 6
    
    public var shortString: String // Sun, Mon, Tue, Wed, Thu, Fri, Sat
}
```

## Author

GGJJack, ggaljjak.choi@gmail.com

## License

SwiftUICalendar is available under the MIT license. See the LICENSE file for more info.
