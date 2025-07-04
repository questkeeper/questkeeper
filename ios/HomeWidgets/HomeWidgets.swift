//
//  HomeWidgets.swift
//  HomeWidgets
//
//  Created by Ishan Misra on 7/4/25.
//

import SwiftUI
import WidgetKit

// Force widget refresh when data changes
@objc public class WidgetHelper: NSObject {
    @objc public static func reloadWidgets() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> AssignmentEntry {
    AssignmentEntry(
      date: Date(), dueDate: "Tomorrow", title: "Complete Math Homework",
      description: "Finish problems 1-20 from chapter 5", starred: true)
  }

  func getSnapshot(in context: Context, completion: @escaping (AssignmentEntry) -> Void) {
    let entry: AssignmentEntry
    if context.isPreview {
      entry = placeholder(in: context)
    } else {
      let userDefaults = UserDefaults(suiteName: "group.questkeeper")
      let defaultData = """
        [
            {
                "id": 1,
                "title": "Complete Math Homework",
                "description": "Finish problems 1-20 from chapter 5",
                "dueDate": "Tomorrow",
                "starred": false
            }
        ]
        """
      let data = userDefaults?.string(forKey: "assignments") ?? defaultData

      do {
        let assignments = try JSONDecoder().decode([AssignmentData].self, from: data.data(using: .utf8)!)
        
        // Show the first (most recent/upcoming) assignment
        let assignment = assignments.first ?? AssignmentData(
          id: 0, title: "No upcoming tasks", description: "All caught up!",
          dueDate: "Great job!", starred: false)

        entry = AssignmentEntry(
          date: Date(), dueDate: assignment.dueDate, title: assignment.title,
          description: assignment.description, starred: assignment.starred)
      } catch {
        // Fallback entry if JSON parsing fails
        entry = AssignmentEntry(
          date: Date(), dueDate: "Error", title: "Widget Error",
          description: "Failed to load tasks", starred: false)
      }
    }
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<AssignmentEntry>) -> Void) {
    getSnapshot(
      in: context,
      completion: { (entry) in
        // Create entries for immediate refresh and periodic updates
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        let entries = [entry]
        
        // Use .atEnd policy to allow immediate updates when data changes
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
      })
  }
}

struct AssignmentEntry: TimelineEntry {
  let date: Date
  let dueDate: String
  let title: String
  let description: String
  let starred: Bool
}

struct Assignment: Codable {
  let dueDate: String
  let title: String
  let description: String
  let starred: Bool
}

struct AssignmentData: Decodable {
  let id: Int
  let title: String
  let description: String
  let dueDate: String
  let starred: Bool
}

struct HomeWidgetsEntryView: View {
  var entry: AssignmentEntry

  @Environment(\.widgetFamily) var family

  @ViewBuilder
  var body: some View {
    if family == .systemSmall {
      // Compact layout for small widgets
      VStack(alignment: .leading, spacing: 6) {
        HStack {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
            .font(.caption)
          if entry.starred {
            Image(systemName: "star.fill")
              .foregroundColor(.yellow)
              .font(.caption2)
          }
          Spacer()
        }
        
        Spacer()
        
        Text(entry.title)
          .font(.caption)
          .fontWeight(.semibold)
          .lineLimit(3)
          .multilineTextAlignment(.leading)
        
        Spacer()
        
        HStack {
          Image(systemName: "calendar")
            .foregroundColor(.orange)
            .font(.caption2)
          Text(entry.dueDate)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundColor(.orange)
            .lineLimit(1)
        }
      }
      .padding(8)
      .background(
        LinearGradient(
          gradient: Gradient(colors: [Color.purple.opacity(0.15), Color.blue.opacity(0.15)]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .cornerRadius(12)
    } else {
      // Full layout for medium widgets
      VStack(alignment: .leading, spacing: 8) {
        // Header with app name and icon
        HStack {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
            .font(.title2)
          Text("Next Task")
            .font(.headline)
            .fontWeight(.semibold)
          Spacer()
          if entry.starred {
            Image(systemName: "star.fill")
              .foregroundColor(.yellow)
              .font(.caption)
          }
        }
        
        Spacer()
        
        // Task details
        VStack(alignment: .leading, spacing: 4) {
          Text(entry.title)
            .font(.title3)
            .fontWeight(.medium)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
          
          if !entry.description.isEmpty && entry.description != "No Description Set" {
            Text(entry.description)
              .font(.caption)
              .foregroundColor(.secondary)
              .lineLimit(2)
              .multilineTextAlignment(.leading)
          }
          
          // Due date with appropriate styling
          HStack {
            Image(systemName: "calendar")
              .foregroundColor(.orange)
              .font(.caption)
            Text("Due \(entry.dueDate)")
              .font(.caption)
              .fontWeight(.medium)
              .foregroundColor(.orange)
          }
        }
        
        Spacer()
      }
      .padding()
      .background(
        LinearGradient(
          gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .cornerRadius(16)
    }
  }
}

struct HomeWidgets: Widget {
  let kind: String = "HomeWidgets"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      HomeWidgetsEntryView(entry: entry)
    }
    .configurationDisplayName("Next Task")
    .description("Shows your most recent upcoming task due.")
    .supportedFamilies([.systemMedium, .systemSmall])
  }
}
