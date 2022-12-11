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
        /// MARK: - WHAT IS HAPPENING HERE. Sorry for the caps, but I'm blown away by the readout of some of the CV cells. Not sure if some magic from the LTK API or magic from Apple.
        ///  Remind me to demo!
        ///  update: after checking out the raw API data, I don't see any way an accessibility label is being attached to the image, so my guess is Apple is using CoreML to generate voiceover readouts where possible
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
