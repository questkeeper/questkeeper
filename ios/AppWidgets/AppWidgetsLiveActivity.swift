//
//  AppWidgetsLiveActivity.swift
//  AppWidgets
//
//  Created by Ishan Misra on 7/14/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct AppWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct AppWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: AppWidgetsAttributes.self) { context in
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

extension AppWidgetsAttributes {
    fileprivate static var preview: AppWidgetsAttributes {
        AppWidgetsAttributes(name: "World")
    }
}

extension AppWidgetsAttributes.ContentState {
    fileprivate static var smiley: AppWidgetsAttributes.ContentState {
        AppWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: AppWidgetsAttributes.ContentState {
         AppWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: AppWidgetsAttributes.preview) {
   AppWidgetsLiveActivity()
} contentStates: {
    AppWidgetsAttributes.ContentState.smiley
    AppWidgetsAttributes.ContentState.starEyes
}
