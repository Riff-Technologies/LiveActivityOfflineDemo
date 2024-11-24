//
//  LiveActivityExtensionBundle.swift
//  LiveActivityExtension
//
//  Created by Invitation Homes on 11/24/24.
//

import WidgetKit
import SwiftUI

@main
struct LiveActivityExtensionBundle: WidgetBundle {
    var body: some Widget {
        LiveActivityExtension()
        LiveActivityExtensionControl()
        LiveActivityExtensionLiveActivity()
    }
}
