//
//  ImageUtils.swift
//  LiveActivityOfflineDemo
//
//  Created by Riff-Tech on 11/24/24.
//

import UIKit

func resizeAndCropImage(at url: URL) throws -> UIImage? {
  let originalImage = UIImage(contentsOfFile: url.path)
  guard let image = originalImage else { return nil }
  
  let targetSize = CGSize(width: 48, height: 48)
  let widthRatio = targetSize.width / image.size.width
  let heightRatio = targetSize.height / image.size.height
  let scaleFactor = max(widthRatio, heightRatio)
  
  let scaledImageSize = CGSize(
    width: image.size.width * scaleFactor,
    height: image.size.height * scaleFactor
  )
  
  let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
  let scaledImage = renderer.image { _ in
    image.draw(in: CGRect(origin: .zero, size: scaledImageSize))
  }
  
  return scaledImage
}


func downloadImage(from url: URL) async throws -> URL? {
  guard var destination = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.riff-tech.laappgroup") else { return nil }
  
  destination = destination.appendingPathComponent(url.lastPathComponent)
  
  guard !FileManager.default.fileExists(atPath: destination.path()) else {
    print("File already exists: \(destination)")
    return destination
  }
  
  let (source, _) = try await URLSession.shared.download(from: url)
  try FileManager.default.moveItem(at: source, to: destination)
  
  if let resizedAndCroppedImage = try resizeAndCropImage(at: destination),
     let imageData = resizedAndCroppedImage.pngData() {
    try imageData.write(to: destination)
  }
  
  print("Downloaded \(url.lastPathComponent)")
  return destination
}
