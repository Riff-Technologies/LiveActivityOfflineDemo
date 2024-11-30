//
//  TimeProgressView.swift
//  LiveActivityOfflineDemo
//
//  Created by Riff-Tech on 11/30/24.
//

import ActivityKit
import SwiftUI

struct TimeProgressView: View {
    let startDate: Date
    let endDate: Date
    let thirdSegmentTime: TimeInterval = 20
    var activityEndDate: Date {
        endDate + thirdSegmentTime
    }
    
    var startActivityDate: Date {
        let preSeconds: TimeInterval = 20
        return startDate - preSeconds
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
                                Text("COOL")
                                    .font(.system(size: 12, weight: .semibold))
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
                                Text("STEAM")
                                    .font(.system(size: 12, weight: .semibold))
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
                            Text("READY")
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
