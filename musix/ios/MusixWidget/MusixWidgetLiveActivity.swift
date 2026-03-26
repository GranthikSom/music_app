//
//  MusixWidgetLiveActivity.swift
//  MusixWidget
//
//  Created by Granthik Som on 14/03/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MusixWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MusixWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MusixWidgetAttributes.self) { context in
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

extension MusixWidgetAttributes {
    fileprivate static var preview: MusixWidgetAttributes {
        MusixWidgetAttributes(name: "World")
    }
}

extension MusixWidgetAttributes.ContentState {
    fileprivate static var smiley: MusixWidgetAttributes.ContentState {
        MusixWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MusixWidgetAttributes.ContentState {
         MusixWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MusixWidgetAttributes.preview) {
   MusixWidgetLiveActivity()
} contentStates: {
    MusixWidgetAttributes.ContentState.smiley
    MusixWidgetAttributes.ContentState.starEyes
}
