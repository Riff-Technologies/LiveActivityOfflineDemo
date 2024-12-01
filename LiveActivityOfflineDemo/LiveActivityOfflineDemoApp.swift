//
//  LiveActivityOfflineDemoApp.swift
//  LiveActivityOfflineDemo
//
//  Created by Riff-Tech on 11/24/24.
//

import SwiftUI
import BackgroundTasks

let BG_TASK_ID = "my_background_task"

func scheduleBackgroundTask() {
    do {
        print("setting background task")
        let today = Calendar.current.startOfDay(for: .now)
        let thirtySecondsFromNow = Calendar.current.date(byAdding: .second, value: 30, to: today)!
        
        let request = BGAppRefreshTaskRequest(identifier: BG_TASK_ID)
        request.earliestBeginDate = thirtySecondsFromNow
        try BGTaskScheduler.shared.submit(request)
        
        // For testing, break on this line and force a background task to be executed
        // in LLDB: e -l objc -- (void)[[BGTaskScheduler shared] _simulateLaunchForTaskWithIdentifier:@"test"]
        print("task scheduled")
    } catch {
        print(error.localizedDescription)
    }
}

@main
struct LiveActivityOfflineDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { url in
                guard let url = URLComponents(string: url.absoluteString) else { return }
                print(url)
            }
        }
        .backgroundTask(.appRefresh(BG_TASK_ID)) {
            print("Do something...")
        }
    }
}
