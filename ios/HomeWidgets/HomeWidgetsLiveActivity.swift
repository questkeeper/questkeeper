//
//  HomeWidgetsLiveActivity.swift
//  HomeWidgets
//
//  Created by Ishan Misra on 7/4/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct HomeWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct HomeWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: HomeWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension HomeWidgetsAttributes {
    fileprivate static var preview: HomeWidgetsAttributes {
        HomeWidgetsAttributes(name: "World")
    }
}

extension HomeWidgetsAttributes.ContentState {
    fileprivate static var smiley: HomeWidgetsAttributes.ContentState {
        HomeWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: HomeWidgetsAttributes.ContentState {
         HomeWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: HomeWidgetsAttributes.preview) {
   HomeWidgetsLiveActivity()
} contentStates: {
    HomeWidgetsAttributes.ContentState.smiley
    HomeWidgetsAttributes.ContentState.starEyes
}
