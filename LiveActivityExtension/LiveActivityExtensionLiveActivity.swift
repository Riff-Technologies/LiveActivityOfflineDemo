//
//  LiveActivityExtensionLiveActivity.swift
//  LiveActivityExtension
//
//  Created by Invitation Homes on 11/24/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LiveActivityExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text.init(timerInterval: context.attributes.startTime...context.attributes.endTime, countsDown: true)
                Text("Hello \(context.state.emoji)")
                TimeProgressView(startDate: context.attributes.startTime, endDate: context.attributes.endTime)
            }
            .activityBackgroundTint(nil)
            .padding()
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text.init(timerInterval: context.attributes.startTime...context.attributes.endTime, countsDown: true)
                        .padding()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                        .padding()
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    TimeProgressView(startDate: context.attributes.startTime, endDate: context.attributes.endTime)
                        .padding(.horizontal)
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "lademo://"))
            .keylineTint(Color.red)
        }
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
                                Text("During")
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
