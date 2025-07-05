//
//  HomeWidgets.swift
//  HomeWidgets
//
//  Created by Ishan Misra on 7/4/25.
//

import SwiftUI
import WidgetKit

var defaultBackgroundColor = "WidgetBackground"

// Force widget refresh when data changes
@objc public class WidgetHelper: NSObject {
  @objc public static func reloadWidgets() {
    WidgetCenter.shared.reloadAllTimelines()
  }
}

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> TaskEntry {
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    return TaskEntry(
      date: Date(),
      dueDate: tomorrow,
      title: "Complete Math Homework",
      id: 1,
      backgroundColor: defaultBackgroundColor)
  }

  func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> Void) {
    let entry: TaskEntry
    if context.isPreview {
      entry = placeholder(in: context)
    } else {
      let userDefaults = UserDefaults(suiteName: "group.questkeeper")
      let defaultData = """
        {
            "id": 1,
            "title": "Complete Math Homework",
            "dueDate": "\(ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!))"
        }
        """
      let data = userDefaults?.string(forKey: "data") ?? defaultData

      do {
        let task = try JSONDecoder().decode(
          TaskData.self, from: data.data(using: .utf8)!)

        // Parse the ISO8601 date string
        let dateFormatter = ISO8601DateFormatter()
        // split from . and take the first part
        let dueDate =
          dateFormatter.date(
            from: String(task.dueDate.split(separator: ".").first ?? "") + "Z") ?? Date()

        print(
          "Due date: \(dueDate) from \(task.dueDate) with \(task.dueDate.split(separator: ".").first ?? "" + "Z")"
        )

        entry = TaskEntry(
          date: Date(),
          dueDate: dueDate,
          title: task.title,
          id: task.id,
          backgroundColor: task.backgroundColor ?? defaultBackgroundColor)
      } catch {
        // Fallback entry if JSON parsing fails
        entry = TaskEntry(
          date: Date(),
          dueDate: Date(),
          title: "Widget Error",
          id: 0,
          backgroundColor: defaultBackgroundColor)
      }
    }
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> Void) {
    getSnapshot(
      in: context,
      completion: { (entry) in
        // Create multiple entries for frequent updates to show real-time "In X time"
        let currentDate = Date()
        var entries: [TaskEntry] = []

        // Create entries every minute for the next 10 minutes for real-time updates
        for i in 0..<10 {
          let entryDate = Calendar.current.date(byAdding: .minute, value: i, to: currentDate)!
          entries.append(
            TaskEntry(
              date: entryDate,
              dueDate: entry.dueDate,
              title: entry.title,
              id: entry.id,
              backgroundColor: entry.backgroundColor ?? defaultBackgroundColor
            ))
        }

        // Then create entries every 5 minutes for the next hour
        for i in 1..<12 {
          let entryDate = Calendar.current.date(
            byAdding: .minute, value: 10 + (i * 5), to: currentDate)!
          entries.append(
            TaskEntry(
              date: entryDate,
              dueDate: entry.dueDate,
              title: entry.title,
              id: entry.id,
              backgroundColor: entry.backgroundColor ?? defaultBackgroundColor
            ))
        }

        let nextRefresh = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        let timeline = Timeline(entries: entries, policy: .after(nextRefresh))
        completion(timeline)
      })
  }
}

struct TaskEntry: TimelineEntry {
  let date: Date
  let dueDate: Date
  let title: String
  let id: Int
  let backgroundColor: String?
}

struct TaskData: Decodable {
  let id: Int
  let title: String
  let dueDate: String
  let backgroundColor: String?
}

// Helper function to format relative time
func formatRelativeTime(from currentDate: Date, to dueDate: Date) -> String {
  let interval = dueDate.timeIntervalSince(currentDate)

  if interval < 0 {
    // Past due
    let pastInterval = abs(interval)
    if pastInterval < 60 {
      return "Overdue"
    } else if pastInterval < 3600 {
      let minutes = Int(pastInterval / 60)
      return "\(minutes) min ago"
    } else if pastInterval < 86400 {
      let hours = Int(pastInterval / 3600)
      return "\(hours) hr ago"
    } else {
      let days = Int(pastInterval / 86400)
      return "\(days) day\(days == 1 ? "" : "s") ago"
    }
  } else {
    // Future
    if interval < 60 {
      return "Due now"
    } else if interval < 3600 {
      let minutes = Int(interval / 60)
      return "In \(minutes) min"
    } else if interval < 86400 {
      let hours = Int(interval / 3600)
      return "In \(hours) hr"
    } else {
      let days = Int(interval / 86400)
      return "In \(days) day\(days == 1 ? "" : "s")"
    }
  }
}

struct HomeWidgetsEntryView: View {
  var entry: TaskEntry

  @Environment(\.widgetFamily) var family

  @ViewBuilder
  var body: some View {
    let relativeTime = formatRelativeTime(from: entry.date, to: entry.dueDate)
    let isOverdue = entry.dueDate < entry.date

    if family == .systemSmall {
      // Small widget: Title (small text) + Time (large text)
      VStack(alignment: .center, spacing: 8) {
        Spacer()

        Text(entry.title)
          .font(.footnote)
          .fontWeight(.medium)
          .lineLimit(2)
          .multilineTextAlignment(.center)
          .foregroundColor(.primary)

        Text(relativeTime)
          .font(.title2)
          .fontWeight(.bold)
          .foregroundColor(isOverdue ? .red : .blue)
          .lineLimit(2)
          .minimumScaleFactor(0.8)

        Spacer()
      }
      .padding(12)
      .cornerRadius(16)
    } else {
      // Medium widget: Title (left) + Time (right)
      HStack(alignment: .center, spacing: 12) {
        VStack(alignment: .leading, spacing: 4) {
          Text("Next Task")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)

          Text(entry.title)
            .font(.headline)
            .fontWeight(.semibold)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .foregroundColor(.primary)
        }

        Spacer()

        VStack(alignment: .trailing, spacing: 4) {
          Text("Due")
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.secondary)

          Text(relativeTime)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(isOverdue ? .red : .blue)
            .lineLimit(1)
            .multilineTextAlignment(.trailing)
        }
      }
      .padding(16)
      .cornerRadius(20)
    }
  }
}

struct HomeWidgets: Widget {
  let kind: String = "HomeWidgets"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      let contentView: some View = HomeWidgetsEntryView(entry: entry)
      if #available(iOS 17.0, *) {
        contentView.containerBackground(for: .widget) {
          Color(hexStringToUIColor(hex: entry.backgroundColor ?? defaultBackgroundColor))
        }
      } else {
        ZStack {
          Color(hexStringToUIColor(hex: entry.backgroundColor ?? defaultBackgroundColor))
            .ignoresSafeArea()
            .cornerRadius(16)
          contentView
        }
      }
    }
    .configurationDisplayName("Next Task")
    .description("Shows your most recent upcoming task due.")
    .supportedFamilies([.systemMedium, .systemSmall])
  }
}

func hexStringToUIColor(hex: String) -> UIColor {
  var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

  if cString.hasPrefix("#") {
    cString.remove(at: cString.startIndex)
  }

  if (cString.count) != 6 {
    return UIColor(named: "WidgetBackground")!
  }

  var rgbValue: UInt64 = 0
  Scanner(string: cString).scanHexInt64(&rgbValue)

  return UIColor(
    red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
    green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
    blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
    alpha: CGFloat(1.0)
  )
}
