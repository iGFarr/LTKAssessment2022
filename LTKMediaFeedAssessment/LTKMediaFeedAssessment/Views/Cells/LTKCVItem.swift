//
//  LTKCVItem.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/9/22.
//

import UIKit

class LTKCVCell: UICollectionViewCell {
    var image: UIImage?
    lazy var productImage: LazyImageView = {
        let imageView = LazyImageView()
        imageView.image = self.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var roundedContainer = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.roundedContainer.translatesAutoresizingMaskIntoConstraints = false
        self.roundedContainer.backgroundColor = .white
        self.roundedContainer.addSubview(self.productImage)
        self.roundedContainer.layer.borderColor = UIColor.LTKTheme.tertiary.cgColor
        self.roundedContainer.layer.borderWidth = LTKConstants.UI.thickBorderWidth
        let radius: CGFloat = LTKConstants.UI.collectionViewItemCornerRadiusForDimensionSize(LTKConstants.UI.collectionViewItemDimension)
        self.roundedContainer.layoutMargins = UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius)
        self.roundedContainer.clipsToBounds = true
        self.roundedContainer.layer.cornerRadius = radius
        self.addSubview(self.roundedContainer)
        if let superviewForContainer = self.roundedContainer.superview {
            LTKConstraintHelper.constrain(self.productImage, to: self.roundedContainer)
            LTKConstraintHelper.constrain(self.roundedContainer, to: superviewForContainer)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("initialized from coder")
    }
}
