//
//  ProgressViewStyles.swift
//  LiveActivityOfflineDemo
//
//  Created by Invitation Homes on 11/24/24.
//

import SwiftUI

struct StartProgressStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    ProgressView(configuration)
      .tint(Color.blue)
      .cornerRadius(0)
      .labelsHidden()
      .scaleEffect(x: 1, y: 1.5, anchor: .center)
  }
}


struct MiddleProgressStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    ProgressView(configuration)
      .tint(Color.green)
      .cornerRadius(0)
      .labelsHidden()
      .scaleEffect(x: 1, y: 1.5, anchor: .center)
  }
}


struct EndProgressStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    ProgressView(configuration)
      .tint(Color.yellow)
      .cornerRadius(0)
      .labelsHidden()
      .scaleEffect(x: 1, y: 1.5, anchor: .center)
  }
}
 
#Preview {
    VStack {
        ProgressView(timerInterval: Date.now...Date.now + 15, countsDown: false)
            .progressViewStyle(StartProgressStyle())
        ProgressView(timerInterval: Date.now...Date.now + 15, countsDown: false)
            .progressViewStyle(MiddleProgressStyle())
        ProgressView(timerInterval: Date.now...Date.now + 15, countsDown: false)
            .progressViewStyle(EndProgressStyle())
    }
    .padding()
}
