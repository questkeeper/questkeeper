 import SwiftUI
 import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> AssignmentEntry {
        AssignmentEntry(date: Date(), dueDate: "No Date Set", title: "No Title Set", description: "No Description Set", starred: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (AssignmentEntry) -> ()) {
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

            // print("Data: \(data)")
            let assignments = try! JSONDecoder().decode([AssignmentData].self, from: data.data(using: .utf8)!)
            let assignment = assignments[0]
            entry = AssignmentEntry(date: Date(), dueDate: assignment.dueDate, title: assignment.title, description: assignment.description, starred: assignment.starred)
        }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AssignmentEntry>) -> ()) {
        getSnapshot(in: context, completion: { (entry) in
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

     var body: some View {
         VStack {
             if entry.starred {
                 Text("⭐️")
             }
             Text(entry.title)
                 .font(.title)
             Text("Due " + entry.dueDate)
             Text(entry.description)
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
      }
  }
