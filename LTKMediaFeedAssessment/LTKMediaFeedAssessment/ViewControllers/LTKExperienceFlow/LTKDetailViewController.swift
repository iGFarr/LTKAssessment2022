//
//  LTKDetailViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

class LTKDetailViewController: UITableViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: LTKConstants.UI.collectionViewItemDimension, height: LTKConstants.UI.collectionViewItemDimension)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(LTKCVCell.self, forCellWithReuseIdentifier: LTKConstants.CellIdentifiers.collectionItem)
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    var heroImage = LazyImageView()
    var profileImage = LazyImageView()
    var products: [Product?]?
    var profile: Profile?
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.setupViews()
        self.collectionView.reloadData()
    }
    
    private func setupViews() {
        self.heroImage.translatesAutoresizingMaskIntoConstraints = false
        self.heroImage.contentMode = .scaleAspectFit
        self.heroImage.layer.cornerRadius = 20
        self.heroImage.clipsToBounds = true
        if let proPicURL = URL(string: self.profile?.avatarURL ?? "") {
            self.profileImage.loadImage(fromURL: proPicURL)
        }
        
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        self.profileImage.contentMode = .scaleAspectFit
        self.profileImage.widthConstant(LTKConstants.UI.profilePicBubbleDimension)
        self.profileImage.heightConstant(LTKConstants.UI.profilePicBubbleDimension)
        self.profileImage.layer.cornerRadius = LTKConstants.UI.profilePicBubbleDimension / 2
        self.profileImage.clipsToBounds = true
        self.view.addSubviews([
            heroImage,
            profileImage,
            collectionView
        ])
        self.profileImage.trailing(self.heroImage.leadingAnchor, constant: -LTKConstants.UI.defaultInset)
        self.profileImage.top(self.heroImage.topAnchor)
        self.heroImage.widthConstant(UIScreen.main.bounds.width / 1.75)
        self.heroImage.heightConstant(UIScreen.main.bounds.width / 2.25)
        self.heroImage.xAlignedWith(self.view)
        self.heroImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
        
        self.collectionView.top(self.heroImage.bottomAnchor, constant: LTKConstants.UI.doubleInset)
        self.collectionView.heightConstant(LTKConstants.UI.collectionViewItemDimension)
        self.collectionView.leading(self.view.safeAreaLayoutGuide.leadingAnchor, constant: LTKConstants.UI.defaultInset)
        self.collectionView.trailing(self.view.safeAreaLayoutGuide.trailingAnchor)
    }
}

extension LTKDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = LTKCVCell()
        if let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: LTKConstants.CellIdentifiers.collectionItem, for: indexPath) as? LTKCVCell {
            cell = customCell
        } else {
            return cell
        }
        guard let products = self.products, let thisProduct = products[indexPath.row] else { return cell }
        if let url = URL(string: thisProduct.imageURL) {
            cell.productImage.loadImage(fromURL: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webView = LTKWebViewController()
        if let url = URL(string: self.products?[indexPath.row]?.hyperlink ?? "google.com") {
            webView.url = url
            webView.name = self.products?[indexPath.row]?.retailerDisplayName ?? "No Name"
            self.show(webView, sender: self)
        }
    }
}