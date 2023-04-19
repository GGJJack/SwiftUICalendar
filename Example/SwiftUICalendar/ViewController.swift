//
//  ViewController.swift
//  SwiftUICalendar
//
//  Created by ggaljjak on 10/21/2021.
//  Copyright (c) 2021 ggaljjak. All rights reserved.
//

import UIKit
import SwiftUI
import SwiftUICalendar

struct MainView: View {
    @State var defaultProgress: CGFloat = 0
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: BasicUseView()) {
                    Text("Basic use")
                }
                NavigationLink(destination: StartWithMondayView()) {
                    Text("Start With Monday")
                }
                NavigationLink(destination: CalendarScrollView()) {
                    Text("Calendar Scroll")
                }
                NavigationLink(destination: EmbedHeaderView()) {
                    Text("Embed Header")
                }
                NavigationLink(destination: InformationView()) {
                    Text("Information")
                }
                NavigationLink(destination: SelectionView()) {
                    Text("Selection")
                }
                NavigationLink(destination: InformationWithSelectionView()) {
                    Text("Information + Selection")
                }
            }
            .navigationBarTitle("Home")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice(PreviewDevice(rawValue: "iPod touch (7th generation)"))
        MainView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentViewController = UIHostingController(rootView: MainView())
        self.addChildViewController(contentViewController)
        self.view.addSubview(contentViewController.view)
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

