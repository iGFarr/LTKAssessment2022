//
//  LTKImageCell.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

final class LTKImageCell: UITableViewCell {

    let ltkImageView = LazyImageView()
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
        self.ltkImageView.translatesAutoresizingMaskIntoConstraints = false
        self.ltkImageView.contentMode = .scaleAspectFit
        self.ltkImageView.backgroundColor = .clear
        self.ltkImageView.sizeToFit()
        self.contentView.addSubview(self.ltkImageView)
        let hRatio = self.imageHeight / self.imageWidth
        let newImageHeight = (hRatio * UIScreen.main.bounds.width)
        self.contentView.heightConstant(newImageHeight + LTKConstants.UI.doubleInset)
        self.ltkImageView.top(self.topAnchor)
        self.ltkImageView.bottom(self.bottomAnchor, constant: -LTKConstants.UI.doubleInset)
        self.ltkImageView.widthEqualsWidthOf(self.contentView, constant: -LTKConstants.UI.doubleInset)
        self.ltkImageView.xAlignedWith(self.contentView)
        self.ltkImageView.addBorder()
    }
}

