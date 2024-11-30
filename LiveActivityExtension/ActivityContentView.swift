//
//  ActivityContentView.swift
//  LiveActivityOfflineDemo
//
//  Created by Riff-Tech on 11/30/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

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
            HStack(spacing: 30) {
                Text.init(timerInterval: context.attributes.startTime...context.attributes.endTime, countsDown: true)
                    .frame(minWidth: 30, maxWidth: 60)
                Label("ROOM \(context.attributes.name)", systemImage: "cup.and.heat.waves.fill")
                
                ThumbnailView(image: context.attributes.image)
                    .frame(width: 30, height: 30)
                    .padding([.leading])
            }
            TimeProgressView(startDate: context.attributes.startTime, endDate: context.attributes.endTime)
            Link(destination: URL(string: URLPrefix)!) {
                Text("I'M TOAST")
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
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
