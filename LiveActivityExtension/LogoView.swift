//
//  LogoView.swift
//  LiveActivityExtension
//
//  Created by Riff-Tech on 3/21/24.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.post)
    }
}

#Preview {
    LogoView()
}
