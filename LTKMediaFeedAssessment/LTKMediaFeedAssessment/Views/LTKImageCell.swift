//
//  LTKImageCell.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

class LTKImageCell: UITableViewCell {

    let ltkImageView = LazyImageView()
    var imageHeight: CGFloat = 1
    var imageWidth: CGFloat = 1
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        ltkImageView.image = UIImage(named: "Wrench")
        ltkImageView.translatesAutoresizingMaskIntoConstraints = false
        ltkImageView.contentMode = .scaleAspectFit
        ltkImageView.backgroundColor = .clear
        contentView.addSubview(ltkImageView)
        let hRatio = imageHeight / imageWidth
        let newImageHeight = (hRatio * UIScreen.main.bounds.width).rounded() * 1.5
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: newImageHeight + 16),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            ltkImageView.topAnchor.constraint(equalTo: topAnchor),
            ltkImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            ltkImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        ltkImageView.layoutIfNeeded()
    }
}

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
