//
//  LTKImageCell.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

final class LTKHomeFeedCell: UITableViewCell {

    let ltkImageView = LazyImageView()
    var profileImage = LazyImageView(frame: CGRect(origin: .zero, size: CGSize(width: LTKConstants.UI.profilePicBubbleDimension, height: LTKConstants.UI.profilePicBubbleDimension)))
    let profileNameLabel = LTKLabel()
    let followButton = LTKButton()
    let favoriteButton = LTKButton(frame: CGRect(origin: .zero, size: CGSize(width: LTKConstants.UI.heroImageButtonsSize, height: LTKConstants.UI.heroImageButtonsSize)))
    let shareButton = LTKButton(frame: CGRect(origin: .zero, size: CGSize(width: LTKConstants.UI.heroImageButtonsSize, height: LTKConstants.UI.heroImageButtonsSize)))
    var creatorId: String?
    var ltkId: String?
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
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.container.addSubviews([
            self.ltkImageView,
            self.profileImage,
            self.profileNameLabel,
            self.followButton,
            self.favoriteButton,
            self.shareButton
        ])
        let newImageHeight = (LTKConstants.UI.heroImageHeightRatioAvgEstimate * (UIScreen.main.bounds.width - LTKConstants.UI.doubleInset))
        self.container.heightConstant(CGFloat(newImageHeight).scaled + LTKConstants.UI.containerSpacer)
        LTKConstraintHelper.constrain(container, to: self.contentView)
        
        self.profileNameLabel.leading(self.profileImage.trailingAnchor, constant: LTKConstants.UI.doubleInset)
        self.profileNameLabel.yAlignedWith(self.profileImage, offset: LTKConstants.UI.halfInset)
        self.profileNameLabel.trailing(self.followButton.leadingAnchor, constant: LTKConstants.UI.doubleInset)
        self.profileNameLabel.heightEqualsHeightOf(profileImage)
        
        self.followButton.heightConstant(CGFloat(30).scaled)
        self.followButton.widthConstant(CGFloat(85).scaled)
        self.followButton.trailing(self.container.trailingAnchor, constant: -LTKConstants.UI.doubleInset)
        self.followButton.yAlignedWith(self.profileNameLabel)
        self.followButton.layer.cornerRadius = CGFloat(10).scaled

        self.favoriteButton.configuration = .bordered()
        self.favoriteButton.tintColor = .LTKTheme.tertiary.withAlphaComponent(LTKConstants.UI.slightTranslucency)
        self.favoriteButton.heightConstant(LTKConstants.UI.heroImageButtonsSize)
        self.favoriteButton.widthConstant(LTKConstants.UI.heroImageButtonsSize)
        self.favoriteButton.circularize()
        self.favoriteButton.constrainToEdgePosition(.bottomRight, in: self.container)
        self.favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.LTKTheme.tertiary), for: .normal)
        
        self.shareButton.configuration = .bordered()
        self.shareButton.tintColor = .LTKTheme.tertiary.withAlphaComponent(LTKConstants.UI.slightTranslucency)
        self.shareButton.heightConstant(LTKConstants.UI.heroImageButtonsSize)
        self.shareButton.widthConstant(LTKConstants.UI.heroImageButtonsSize)
        self.shareButton.circularize()
        self.shareButton.bottom(self.favoriteButton.topAnchor, constant: -LTKConstants.UI.doubleInset)
        self.shareButton.xAlignedWith(self.favoriteButton)
        self.shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        self.profileImage.contentMode = .scaleAspectFit
        self.profileImage.circularize()
        self.profileImage.bottom(self.ltkImageView.topAnchor, constant: -LTKConstants.UI.defaultInset)
        self.profileImage.leading(self.ltkImageView.leadingAnchor)
        self.profileImage.widthConstant(LTKConstants.UI.profilePicBubbleDimension)
        self.profileImage.heightConstant(LTKConstants.UI.profilePicBubbleDimension)

        self.ltkImageView.translatesAutoresizingMaskIntoConstraints = false
        self.ltkImageView.contentMode = .scaleAspectFill
        self.ltkImageView.backgroundColor = .clear
        self.ltkImageView.sizeToFit()
        self.ltkImageView.top(self.container.topAnchor, constant: LTKConstants.UI.containerSpacer)
        self.ltkImageView.bottom(self.container.bottomAnchor)
        self.ltkImageView.widthEqualsWidthOf(self.container, constant: -LTKConstants.UI.doubleInset)
        self.ltkImageView.xAlignedWith(self.container)
        self.ltkImageView.addBorder()
        self.ltkImageView.layer.cornerRadius = LTKConstants.UI.heroImageCornerRadiusForTable
    }
}

