//
//  MusixWidget.swift
//  MusixWidget


import WidgetKit
import SwiftUI

// MARK: - Timeline Entry (Data Model)

struct SongEntry: TimelineEntry {
    let date: Date
    let title: String
    let artist: String
    let artPath: String
}

// MARK: - Timeline Provider

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SongEntry {
        SongEntry(
            date: Date(),
            title: "Song Title",
            artist: "Artist Name",
            artPath: ""
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SongEntry) -> ()) {

        let entry = loadEntry()
        completion(entry)

    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SongEntry>) -> ()) {

        let entry = loadEntry()

        let timeline = Timeline(
            entries: [entry],
            policy: .after(Date().addingTimeInterval(300)) // refresh every 5 minutes
        )

        completion(timeline)
    }

    // Load song info from shared App Group storage
    func loadEntry() -> SongEntry {

        let defaults = UserDefaults(
            suiteName: "group.MusixWidget"
        )

        let title = defaults?.string(forKey: "title") ?? "No Song"
        let artist = defaults?.string(forKey: "artist") ?? ""
        let art = defaults?.string(forKey: "art") ?? ""

        return SongEntry(
            date: Date(),
            title: title,
            artist: artist,
            artPath: art
        )
    }
}

// MARK: - Widget View

struct MusixWidgetEntryView : View {

    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {

        switch family {

        case .systemSmall:
            smallWidget

        case .systemMedium:
            mediumWidget

        default:
            smallWidget
        }
    }

    // Small widget (album cover only)
    var smallWidget: some View {

        ZStack {

            if let image = UIImage(contentsOfFile: entry.artPath) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.black
            }
        }
    }

    // Medium widget (cover + song info)
    var mediumWidget: some View {

        HStack {

            if let image = UIImage(contentsOfFile: entry.artPath) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading) {

                Text(entry.title)
                    .font(.headline)
                    .lineLimit(1)

                Text(entry.artist)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding()
    }
}

// MARK: - Widget Definition

struct MusixWidget: Widget {

    let kind: String = "MusixWidget"

    var body: some WidgetConfiguration {

        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in

            MusixWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)

        }
        .configurationDisplayName("Musix Player")
        .description("Shows the currently playing song.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    MusixWidget()
} timeline: {
    SongEntry(
        date: .now,
        title: "Blinding Lights",
        artist: "The Weeknd",
        artPath: ""
    )
}

