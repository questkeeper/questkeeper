import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> AssignmentEntry {
    AssignmentEntry(
      date: Date(), dueDate: "No Date Set", title: "No Title Set",
      description: "No Description Set", starred: false)
  }

  func getSnapshot(in context: Context, completion: @escaping (AssignmentEntry) -> Void) {
    let entry: AssignmentEntry
    if context.isPreview {
      entry = placeholder(in: context)
    } else {
      let userDefaults = UserDefaults(suiteName: "group.assigngo")
      let defaultData = """
        [
            {
                "id": 1,
                "title": "Test Assignment",
                "description": "This is a test assignment",
                "dueDate": "2021-01-01",
                "starred": true
            }
        ]
        """
      let data = userDefaults?.string(forKey: "assignments") ?? defaultData

      let assignments = try! JSONDecoder().decode(
        [AssignmentData].self, from: data.data(using: .utf8)!)
      length = assignments.count
      let assignment = assignments[index]

      entry = AssignmentEntry(
        date: Date(), dueDate: assignment.dueDate, title: assignment.title,
        description: assignment.description, starred: assignment.starred)
    }
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<AssignmentEntry>) -> Void) {
    getSnapshot(
      in: context,
      completion: { (entry) in
        let timeline = Timeline(entries: [entry], policy: .atEnd)
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

struct AssignGoWidgetsEntryView: View {
  var entry: AssignmentEntry

  @Environment(\.widgetFamily) var family

  @ViewBuilder
  var body: some View {

    HStack {
      VStack {
        Text("\(entry.starred ? "⭐️" : "") \(entry.title)")
        Text("Due " + entry.dueDate).font(Font.body.weight(.light))
      }.padding(
        EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4)
      ).background(
        Color.purple.opacity(Double(0.5))
      ).cornerRadius(12)

      if #available(iOS 17.0, *) {
        if family == .systemMedium || family == .systemLarge {

          VStack(spacing: 4) {
            Button(intent: WidgetScrollerUp()) {
              Image(systemName: "arrow.up")
            }
            Button(intent: WidgetScrollerDown()) {
              Image(systemName: "arrow.down")
            }
          }
          .buttonStyle(.bordered)
          .foregroundColor(.white)
          .tint(.white)
        }
      }
    }
  }
}

struct AssignGoWidgets: Widget {
  let kind: String = "AssignGoWidgets"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      AssignGoWidgetsEntryView(entry: entry)
    }
    .configurationDisplayName("AssignGo Widget")
    .description("This is an example widget.")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}
