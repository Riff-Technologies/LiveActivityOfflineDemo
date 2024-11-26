//
//  ProgressViewStyles.swift
//  LiveActivityOfflineDemo
//
//  Created by Riff-Tech on 11/24/24.
//

import SwiftUI

struct StartProgressStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    ProgressView(configuration)
      .tint(Color.pre)
      .cornerRadius(0)
      .labelsHidden()
      .scaleEffect(x: 1, y: 2.5, anchor: .center)
  }
}


struct MiddleProgressStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    ProgressView(configuration)
      .tint(Color.during)
      .cornerRadius(0)
      .labelsHidden()
      .scaleEffect(x: 1, y: 2.5, anchor: .center)
  }
}


struct EndProgressStyle: ProgressViewStyle {
  func makeBody(configuration: Configuration) -> some View {
    ProgressView(configuration)
      .tint(Color.post)
      .cornerRadius(0)
      .labelsHidden()
      .scaleEffect(x: 1, y: 2.5, anchor: .center)
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
