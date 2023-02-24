//
//  TestWidget.swift
//  TestWidget
//
//  Created by Renat Sarymsakov on 24.02.2023.
//

import WidgetKit
import SwiftUI
import Flutter

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        print("YOYOYO - placeholder")
        return SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        print("YOYOYO - getSnapshot")
        let entry = SimpleEntry(date: Date())
        completion(entry)
        
        print("Create flutter engine")
        let helloWorldEngine = FlutterEngine(name: "com.lol.widgets")

        helloWorldEngine.run(
                withEntrypoint: "initPlatformChannel",
                libraryURI: "lib/main.dart"
        )

        print("Create flutter engine")

        let channel = FlutterMethodChannel(
            name: "com.lol/api", binaryMessenger: helloWorldEngine.binaryMessenger
        )
        channel.invokeMethod("getData", arguments: "") { result in
            print("Receive result from flutter engine")
            print(result)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("YOYOYO - getTimeline")
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
        
        print("Create flutter engine")
        let helloWorldEngine = FlutterEngine(name: "com.lol.widgets")

        helloWorldEngine.run(
                withEntrypoint: "initPlatformChannel",
                libraryURI: "lib/main.dart"
        )

        print("Create flutter engine")

        let channel = FlutterMethodChannel(
            name: "com.lol/api", binaryMessenger: helloWorldEngine.binaryMessenger
        )
        channel.invokeMethod("getData", arguments: "") { result in
            print("Receive result from flutter engine")
            print(result)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TestWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text("\(Int.random(in: 0..<1000))")
    }
}

struct TestWidget: Widget {
    let kind: String = "TestWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TestWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct TestWidget_Previews: PreviewProvider {
    static var previews: some View {
        TestWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
