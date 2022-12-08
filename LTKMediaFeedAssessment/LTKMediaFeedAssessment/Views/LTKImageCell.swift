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
        ltkImageView.sizeToFit()
        contentView.addSubview(ltkImageView)
        let hRatio = imageHeight / imageWidth
        let newImageHeight = (hRatio * UIScreen.main.bounds.width).rounded() * 1.5
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: newImageHeight + LTKConstants.UI.doubleInset),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            ltkImageView.topAnchor.constraint(equalTo: topAnchor),
            ltkImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -LTKConstants.UI.doubleInset),
            ltkImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
        ltkImageView.layoutIfNeeded()
    }
}

