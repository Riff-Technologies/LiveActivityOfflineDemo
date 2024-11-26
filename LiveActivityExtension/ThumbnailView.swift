//
//  ThumbnailView.swift
//  LiveActivityExtension
//
//  Created by Riff-Tech on 3/21/24.
//

import SwiftUI

struct ThumbnailView: View {
  var image: String?
  
  var body: some View {
    GeometryReader { proxy in
      if let image, let url = URL(string: image), let imageData = try? Data(contentsOf: url),
         let uiImage = UIImage(data: imageData) {
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(1, contentMode: .fill)
          .scaledToFit()
          .clipShape(RoundedRectangle(cornerRadius: 4))
          .overlay(alignment: .topLeading) {
            LogoView()
              .frame(width: proxy.size.width / 2)
              .alignmentGuide(.top) { dim in
                dim.height / 3
              }
              .alignmentGuide(.leading) { dim in
                dim.width / 3
              }
              .shadow(radius: 3, y: 3)
          }
      } else {
        Image(systemName: "car")
          .resizable()
          .aspectRatio(1, contentMode: .fill)
          .scaledToFill()
          .clipShape(RoundedRectangle(cornerRadius: 4))
          .overlay(alignment: .topLeading) {
            LogoView()
              .frame(width: proxy.size.width / 2)
              .alignmentGuide(.top) { dim in
                dim.height / 4
              }
              .alignmentGuide(.leading) { dim in
                dim.width / 4
              }
              .shadow(radius: 3, y: 3)
          }
      }
    }
  }
}

#Preview {
    VStack {
      ThumbnailView()
    }.frame(width: 48)
    
}
