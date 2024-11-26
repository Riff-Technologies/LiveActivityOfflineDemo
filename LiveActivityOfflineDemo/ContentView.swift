//
//  ContentView.swift
//  LiveActivityOfflineDemo
//
//  Created by Riff-Tech on 11/24/24.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var activities = Activity<LiveActivityExtensionAttributes>.activities
        
    var body: some View {
        NavigationView {
            Form {
                Section("Activity Management") {
                    Button(action: {
                        Task {
                            await createLiveActivity()
                            refreshActivitiesState()
                        }
                    }) {
                        Text("Create Live Activity")
                    }
                    Button(action: {
                        endAllActivities()
                        refreshActivitiesState()
                    }) {
                        Text("End Live Activities")
                    }
                }
                Section("Running Activities") {
                    if activities.isEmpty {
                       Text("No Live Activities")
                    }
                    activitiesView()
                }
            }
            .navigationTitle("Live Activity Demo")
        }
    }
    
    func createLiveActivity() async {
        // attempt to download the image
        var localImageUrl: URL? = nil
        if let imageUrl = URL(string: "https://picsum.photos/200") {
          localImageUrl = try? await downloadImage(from: imageUrl)
          print("saved resized image successfully")
        }
        
        let startTime = Date.now + 10
        let endTime = .now + 50
        let attributes = LiveActivityExtensionAttributes(startTime: startTime, endTime: endTime, name: "smiley", image: localImageUrl?.absoluteString)
        let state = LiveActivityExtensionAttributes.LiveActivityState(emoji: "😄")
        let content = ActivityContent(state: state, staleDate: endTime)
        
        do {
            let _ = try Activity<LiveActivityExtensionAttributes>.request(
                attributes: attributes,
                content: content
            )
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func endAllActivities() {
        Task {
            for activity in Activity<LiveActivityExtensionAttributes>.activities{
                // We need to set a "final" state before end the activity
                let state = LiveActivityExtensionAttributes.LiveActivityState(emoji: "😄")
                let content = ActivityContent(state: state, staleDate: .now)
                await activity.end(content, dismissalPolicy: .immediate)
            }
        }
    }
    
    func refreshActivitiesState() {
        Task {
            // Allow the activity changes to complete before refreshing the list
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            // find all the current activities and sort them
            var activities = Activity<LiveActivityExtensionAttributes>.activities
            activities.sort { $0.id < $1.id }
            self.activities = activities
        }
    }
}

extension ContentView {
    func activitiesView() -> some View {
        List {
            ForEach(activities) { activity in
                Text(activity.id)
            }
        }
    }
}

#Preview {
    ContentView()
}
