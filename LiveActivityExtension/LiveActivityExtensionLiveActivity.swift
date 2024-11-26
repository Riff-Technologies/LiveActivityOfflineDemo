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
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text.init(timerInterval: context.attributes.startTime...context.attributes.endTime, countsDown: true)
                        .padding()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    ThumbnailView(image: context.attributes.image)
                        .frame(width: 30, height: 30)
                        .padding([.trailing, .top], 8)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Primary Content \(context.state.emoji)")
                    TimeProgressView(startDate: context.attributes.startTime, endDate: context.attributes.endTime)
                        .padding(.horizontal)
                }
            } compactLeading: {
                Text(context.state.emoji)
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
        .supplementalActivityFamilies([.small])
    }
}

struct TimeProgressView: View {
    let startDate: Date
    let endDate: Date
    let thirdSegmentTime: TimeInterval = 10
    var activityEndDate: Date {
        endDate + thirdSegmentTime
    }
    
    var startActivityDate: Date {
        //
        let thirtyMinutes: TimeInterval = 10
        return startDate - thirtyMinutes
    }
    
    var firstSegmentTime: TimeInterval {
        startDate.timeIntervalSinceReferenceDate - startActivityDate.timeIntervalSinceReferenceDate
    }
    
    var secondSegmentTime: TimeInterval {
        endDate.timeIntervalSinceReferenceDate - startActivityDate.timeIntervalSinceReferenceDate
    }
    
    var totalSegmentTime: TimeInterval {
        activityEndDate.timeIntervalSinceReferenceDate - startActivityDate.timeIntervalSinceReferenceDate
    }
    
    var firstSegmentProportion: Double {
        firstSegmentTime / totalSegmentTime
    }
    
    var secondSegmentProportion: Double {
        secondSegmentTime / totalSegmentTime
    }
    
    var thirdSegmentProportion: Double {
        thirdSegmentTime / totalSegmentTime
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                ProgressView(timerInterval: startActivityDate...activityEndDate, countsDown: false)
                    .progressViewStyle(EndProgressStyle())
                    .frame(width: proxy.size.width)
                    .overlay(alignment: .bottomLeading) {
                        HStack {
                            Spacer()
                                .frame(width: proxy.size.width * (secondSegmentProportion))
                            HStack {
                                Spacer()
                                Text("Post")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color.gray)
                                    .alignmentGuide(.top) { dim in
                                        dim.height
                                    }
                                Spacer()
                            }
                        }
                        .alignmentGuide(.bottom) { dim in
                            dim.height * 1.75
                        }
                    }
                
                ProgressView(timerInterval: startActivityDate...endDate, countsDown: false)
                    .progressViewStyle(MiddleProgressStyle())
                    .frame(width: proxy.size.width * (secondSegmentProportion))
                    .overlay(alignment: .bottomLeading) {
                        HStack {
                            Spacer()
                                .frame(width: proxy.size.width * firstSegmentProportion)
                            HStack(spacing: 0) {
                                Spacer()
                                Text("Mid")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color.gray)
                                Spacer()
                            }
                        }
                        .alignmentGuide(.bottom) { dim in
                            dim.height * 1.75
                        }
                    }
                if firstSegmentTime > 0 {
                    ProgressView(timerInterval: startActivityDate...startDate, countsDown: false)
                        .progressViewStyle(StartProgressStyle())
                        .frame(width: proxy.size.width * firstSegmentProportion)
                        .overlay(alignment: .bottom) {
                            Text("Pre")
                                .foregroundStyle(Color.gray)
                                .font(.system(size: 12, weight: .semibold))
                                .alignmentGuide(.bottom) { dim in
                                    dim.height * 1.75
                                }
                        }
                }
                
            }
        }
        .padding(.top)
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

struct ActivityContentView: View {
    @Environment(\.activityFamily) var activityFamily
    var context: ActivityViewContext<LiveActivityExtensionAttributes>
    
    var body: some View {
        switch activityFamily {
        case .small:
            SmartStackView(context: context)
        case .medium:
            LockScreenView(context: context)
        @unknown default:
            LockScreenView(context: context)
        }
    }
}

struct LockScreenView: View {
    var context: ActivityViewContext<LiveActivityExtensionAttributes>
    
    var body: some View {
        VStack {
            HStack {
                Text.init(timerInterval: context.attributes.startTime...context.attributes.endTime, countsDown: true)
                    .frame(minWidth: 30, maxWidth: 60)
                Text("Primary Content \(context.state.emoji)")
                
                ThumbnailView(image: context.attributes.image)
                    .frame(width: 30, height: 30)
                    .padding([.leading])
            }
            TimeProgressView(startDate: context.attributes.startTime, endDate: context.attributes.endTime)
            Link(destination: URL(string: URLPrefix)!) {
                Text("Take me to the app")
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color.during)
                    .foregroundColor(.white)
                    .clipShape(.capsule)
            }
        }
        .padding()
    }
}

struct SmartStackView: View {
    var context: ActivityViewContext<LiveActivityExtensionAttributes>
    
    var body: some View {
        VStack {
            Grid(horizontalSpacing: 40) {
                GridRow {
                    ThumbnailView(image: context.attributes.image)
                        .frame(width: 20, height: 20)
                    Text.init(timerInterval: context.attributes.startTime...context.attributes.endTime, countsDown: true)
                }
            }
            TimeProgressView(startDate: context.attributes.startTime, endDate: context.attributes.endTime)
        }
        .padding()
    }
}
