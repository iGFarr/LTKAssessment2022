//
//  LTKKit.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

class LazyImageView: UIImageView {
    
    private let imageCache = NSCache<AnyObject, UIImage>()
    func loadImage(fromURL imageURL: URL, placeHolderImage: String) {
        imageCache.totalCostLimit = 1024 * 1024 * 50
        self.image = UIImage(named: placeHolderImage)?.withRenderingMode(.alwaysOriginal)
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject) {
            self.image = cachedImage
            print("loaded image from cache for \(imageURL)")
            return
        }

        DispatchQueue.global().async { [weak self] in
            if let imageDate = try? Data(contentsOf: imageURL) {
                print("loaded image from server for \(imageURL)")
                if let image = UIImage(data: imageDate) {
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: imageURL as AnyObject, cost: (image.cgImage?.bytesPerRow ?? 0) * (image.cgImage?.height ?? 0))
                        self?.image = image
                    }
                }
            }
        }
    }
}
