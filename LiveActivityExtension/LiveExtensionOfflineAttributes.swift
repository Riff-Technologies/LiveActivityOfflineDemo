//
//  LiveExtensionOfflineAttributes.swift
//  LiveActivityOfflineDemo
//
//  Created by Riff-Tech on 11/24/24.
//

import Foundation
import ActivityKit

struct LiveActivityExtensionAttributes: ActivityAttributes {
    public typealias LiveActivityState = ContentState
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    var startTime: Date
    var endTime: Date
    var name: String
    var image: String?
    var id = UUID()
}
