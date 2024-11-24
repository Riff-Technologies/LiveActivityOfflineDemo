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
                Text("Hello \(context.state.emoji)")
                TimeProgressView(startDate: context.attributes.startTime, endDate: context.attributes.endTime)
            }
            .activityBackgroundTint(Color.accentColor)
            .activitySystemActionForegroundColor(Color.secondary)
            .padding()

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
            .widgetURL(URL(string: "lademo://"))
            .keylineTint(Color.red)
        }
    }
}

struct TimeProgressView: View {
    let startDate: Date
    let endDate: Date
    let thirdSegmentTime: TimeInterval = 15
    var activityEndDate: Date {
        endDate + thirdSegmentTime
    }
    
    var firstSegmentTime: TimeInterval {
        startDate.timeIntervalSinceReferenceDate - Date.now.timeIntervalSinceReferenceDate
    }
    
    var secondSegmentTime: TimeInterval {
        endDate.timeIntervalSinceReferenceDate - startDate.timeIntervalSinceReferenceDate
    }
    
    var totalSegmentTime: TimeInterval {
        activityEndDate.timeIntervalSinceReferenceDate - Date.now.timeIntervalSinceReferenceDate
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
            VStack(spacing: 0) {
                ZStack {
                    
                    Text("Start")
                        .font(.system(size: 8))
                        .position(x: proxy.size.width * firstSegmentProportion, y: -5)
                    
                    Text("Scheduled Time (\(getDateRange(date1: startDate, date2: endDate)))")
                        .font(.system(size: 8))
                        .position(x: proxy.size.width / 2.0, y: -5)
                    
                    Text("End")
                        .font(.system(size: 8))
                        .position(x: proxy.size.width * (firstSegmentProportion + secondSegmentProportion), y: -5)
                    
                }
                
                // Align the progress views horizontally, each starting where the previous ended
                // Visually, this presents a single background color for the progress bar, with a small break between each bar
                // The issue is that on Pro model iPhones with an always-on display (not an issue without always-on)
                // when the display "turns on" each progress bar starts full and goes back to it's current value,
                // which makes it feel like a hack because 3 different progress views can be seen in the transition from "off" to "on"
                
//                HStack(spacing: -1) { // overlap the views by a point to reduce the visual separation due to corner radius of the views
//
//                    ProgressView(timerInterval: .now...startDate, countsDown: false)
//                        .progressViewStyle(StartProgressStyle())
//                        .frame(width: proxy.size.width * firstSegmentProportion)
//
//                    ProgressView(timerInterval: startDate...endDate, countsDown: false)
//                        .progressViewStyle(MiddleProgressStyle())
//                        .frame(width: proxy.size.width * secondSegmentProportion)
//
//                    ProgressView(timerInterval: endDate...activityEndDate, countsDown: false)
//                        .progressViewStyle(EndProgressStyle())
//                        .frame(width: proxy.size.width * thirdSegmentProportion)
//
//                }
                
                // Stack the progressviews and adjust the length of each to correspond with the proportion of time for which they run
                // The issue with this presentation is that the background "unfilled" progress bar darkens when they are overlayed on top
                // of eachother, so we can see where each bar ends
                // this is less jarring than the HStack version for an "always on" display
                
                // NOTE: apparently having more than 1 progressview prevents the `stale` state from working properly
                // it will just put a static activity indicator on the activity - tested on iOS 17.2
                // workaround is to not use a staleDate when creating the activity
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                    
                    ProgressView(timerInterval: .now...activityEndDate, countsDown: false)
                        .progressViewStyle(EndProgressStyle())
                        .frame(width: proxy.size.width)
                    
                    ProgressView(timerInterval: .now...endDate, countsDown: false)
                        .progressViewStyle(MiddleProgressStyle())
                        .frame(width: proxy.size.width * (firstSegmentProportion + secondSegmentProportion))
                    
                    ProgressView(timerInterval: .now...startDate, countsDown: false)
                        .progressViewStyle(StartProgressStyle())
                        .frame(width: proxy.size.width * firstSegmentProportion)
                    
                }
            }
        }
    }
    
    func getDateRange(date1: Date, date2: Date) -> String {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "h"
        
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "h a"
        
        let startDateString = startDateFormatter.string(from: date1)
        let endDateString = endDateFormatter.string(from: date2)
        
        return "\(startDateString)-\(endDateString)"
    }
    
}

extension LiveActivityExtensionAttributes {
    fileprivate static var preview: LiveActivityExtensionAttributes {
        LiveActivityExtensionAttributes(startTime: Date() + 15, endTime: Date() + 45, name: "smiley")
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
