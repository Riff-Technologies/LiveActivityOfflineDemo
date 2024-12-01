//
//  LiveActivityExtensionLiveActivity.swift
//  LiveActivityExtension
//
//  Created by Riff-Tech on 11/24/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

let URLPrefix = "lademo://"

struct LiveActivityExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            ActivityContentView(context: context)
                .activityBackgroundTint(Color.widgetBackground.opacity(0.4))
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text.init(timerInterval: context.attributes.startTime...context.attributes.endTime, countsDown: true)
                        .padding([.leading])
                        .padding([.top], 35)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    ThumbnailView(image: context.attributes.image)
                        .frame(width: 30, height: 30)
                        .padding([.trailing], 8)
                        .padding([.top], 30)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Label("ROOM \(context.attributes.name)", systemImage: "cup.and.heat.waves.fill").offset(y: -30)
                    TimeProgressView(startDate: context.attributes.startTime, endDate: context.attributes.endTime)
                        .padding(.horizontal)
                }
            } compactLeading: {
                Text.init(timerInterval: context.attributes.startTime...context.attributes.endTime, countsDown: true)
                    .frame(maxWidth: 50)
            } compactTrailing: {
                ThumbnailView(image: context.attributes.image)
                    .frame(width: 14, height: 14)
                    .padding([.leading, .trailing], 4)
            } minimal: {
                ThumbnailView(image: context.attributes.image)
                    .frame(width: 14, height: 14)
                    .padding([.leading, .trailing], 4)
            }
            // Open the app with a deeplink
            .widgetURL(URL(string: URLPrefix))
            .keylineTint(Color.pre)
        }
        .supplementalActivityFamilies([.small, .medium])
    }
}

extension LiveActivityExtensionAttributes {
    fileprivate static var preview: LiveActivityExtensionAttributes {
        LiveActivityExtensionAttributes(startTime: Date(), endTime: Date() + 10, name: "smiley")
    }
}

extension LiveActivityExtensionAttributes.ContentState {
    fileprivate static var smiley: LiveActivityExtensionAttributes.ContentState {
        LiveActivityExtensionAttributes.ContentState(emoji: "😀")
    }
    
    fileprivate static var starEyes: LiveActivityExtensionAttributes.ContentState {
        LiveActivityExtensionAttributes.ContentState(emoji: "🤩")
    }
}

#Preview("Notification", as: .content, using: LiveActivityExtensionAttributes.preview) {
    LiveActivityExtensionLiveActivity()
} contentStates: {
    LiveActivityExtensionAttributes.ContentState.smiley
    LiveActivityExtensionAttributes.ContentState.starEyes
}
