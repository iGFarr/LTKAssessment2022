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
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private var roundedContainer = LTKView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isAccessibilityElement = true
        /// MARK: - Cool stuff here. I left the "test" label just to demo how Apple seems to be using Machine Learning to generate accessibility labels for images when possible. Unless it's just
        ///  in the images meta data somehow? Not sure, but it's cool either way!
        self.accessibilityLabel = "test"
        self.roundedContainer.backgroundColor = .white
        self.roundedContainer.addSubview(self.productImage)
        self.roundedContainer.addBorder()
        let radius: CGFloat = LTKConstants.UI.collectionViewItemCornerRadiusForDimensionSize()
        self.roundedContainer.layoutMargins = UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius)
        self.roundedContainer.layer.cornerRadius = radius
        self.addSubview(self.roundedContainer)
        LTKConstraintHelper.constrain(self.productImage, to: self.roundedContainer)
        LTKConstraintHelper.constrain(self.roundedContainer, to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("initialized from coder")
    }
}
