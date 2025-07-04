//
//  HomeWidgetsBundle.swift
//  HomeWidgets
//
//  Created by Ishan Misra on 7/4/25.
//

import WidgetKit
import SwiftUI

@main
struct HomeWidgetsBundle: WidgetBundle {
    var body: some Widget {
        HomeWidgets()
        HomeWidgetsControl()
        HomeWidgetsLiveActivity()
    }
}
