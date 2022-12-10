//
//  LTKImageCell.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

final class LTKImageCell: UITableViewCell {

    let ltkImageView = LazyImageView()
    var profileImage = LazyImageView(frame: CGRect(origin: .zero, size: CGSize(width: LTKConstants.UI.profilePicBubbleDimension, height: LTKConstants.UI.profilePicBubbleDimension)))
    let container = LTKView()
    var imageHeight: CGFloat = 1
    var imageWidth: CGFloat = 1
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.container.addSubview(self.ltkImageView)
        self.container.addSubview(self.profileImage)
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.ltkImageView.translatesAutoresizingMaskIntoConstraints = false
        self.ltkImageView.contentMode = .scaleAspectFill
        self.ltkImageView.backgroundColor = .clear
        self.ltkImageView.sizeToFit()
        
        self.profileImage.circularize()
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        self.profileImage.contentMode = .scaleAspectFit
        self.profileImage.bottom(self.ltkImageView.topAnchor, constant: -LTKConstants.UI.defaultInset)
        self.profileImage.leading(self.ltkImageView.leadingAnchor)
        self.profileImage.widthConstant(LTKConstants.UI.profilePicBubbleDimension)
        self.profileImage.heightConstant(LTKConstants.UI.profilePicBubbleDimension)
        LTKConstraintHelper.constrain(container, to: self.contentView)

        let hRatio = self.imageHeight / self.imageWidth
        let newImageHeight = (hRatio * UIScreen.main.bounds.width)
        self.container.heightConstant(newImageHeight + LTKConstants.UI.containerSpacer)
        self.ltkImageView.top(self.container.topAnchor, constant: LTKConstants.UI.containerSpacer)
        self.ltkImageView.bottom(self.container.bottomAnchor)
        self.ltkImageView.widthEqualsWidthOf(self.container, constant: -LTKConstants.UI.doubleInset)
        self.ltkImageView.xAlignedWith(self.container)
        self.ltkImageView.addBorder()
        self.ltkImageView.layer.cornerRadius = LTKConstants.UI.heroImageCornerRadiusForTable
        self.ltkImageView.clipsToBounds = true
    }
}

