//
//  AppIntent.swift
//  QuestKeeperWidgets
//
//  Created by Ishan Misra on 4/12/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}

var index = 0;
var length = 1;

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct WidgetScrollerUp: AppIntent {
    
    static var title: LocalizedStringResource = "Widget Scroller"
    static var description = IntentDescription("Scroll through widgets")
    
    func perform() async throws -> some IntentResult {
        if index > 0 {
            index -= 1
        }

        return .result()
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct WidgetScrollerDown: AppIntent {
    
    static var title: LocalizedStringResource = "Widget Scroller"
    static var description = IntentDescription("Scroll through widgets")
    
    func perform() async throws -> some IntentResult {
        if index < length - 1 {
            index += 1
        }

        return .result()
    }
}
