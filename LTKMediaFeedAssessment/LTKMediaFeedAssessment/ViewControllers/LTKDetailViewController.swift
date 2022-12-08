//
//  LTKDetailViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
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
        self.roundedContainer.addSubview(self.productImage)
        self.roundedContainer.layer.borderColor = UIColor.systemMint.cgColor
        self.roundedContainer.layer.borderWidth = 2
        let radius: CGFloat = 15
        self.roundedContainer.layoutMargins = UIEdgeInsets(top: radius, left: radius, bottom: radius, right: radius)
        self.roundedContainer.clipsToBounds = true
        self.roundedContainer.layer.cornerRadius = radius
        self.addSubview(self.roundedContainer)
        if let superviewForContainer = self.roundedContainer.superview {
            NSLayoutConstraint.activate([
                self.productImage.leadingAnchor.constraint(equalTo: self.roundedContainer.leadingAnchor),
                self.productImage.trailingAnchor.constraint(equalTo: self.roundedContainer.trailingAnchor),
                self.productImage.topAnchor.constraint(equalTo: self.roundedContainer.topAnchor),
                self.productImage.bottomAnchor.constraint(equalTo: self.roundedContainer.bottomAnchor),
                
                self.roundedContainer.leadingAnchor.constraint(equalTo: superviewForContainer.leadingAnchor),
                self.roundedContainer.trailingAnchor.constraint(equalTo: superviewForContainer.trailingAnchor),
                self.roundedContainer.topAnchor.constraint(equalTo: superviewForContainer.topAnchor),
                self.roundedContainer.bottomAnchor.constraint(equalTo: superviewForContainer.bottomAnchor)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("initialized from coder")
    }
}
class LTKDetailViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(LTKCVCell.self, forCellWithReuseIdentifier: "LTKCVItem")
        
        return cv
    }()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = LTKCVCell()
        if let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LTKCVItem", for: indexPath) as? LTKCVCell {
            cell = customCell
        } else {
            return cell
        }
        guard let products = products, let thisProduct = products[indexPath.row] else { return cell }
        print("number of products")
        print(products.count)
        if let url = URL(string: thisProduct.imageURL) {
            cell.productImage.loadImage(fromURL: url, placeHolderImage: "Wrench")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let webView = LTKWebViewController()
        if let url = URL(string: products?[indexPath.row]?.hyperlink ?? "google.com") {
            webView.url = url
            webView.name = products?[indexPath.row]?.retailerDisplayName ?? "No Name"
            show(webView, sender: self)
        }
    }
    
    var heroImage = LazyImageView()
    var profileImage = LazyImageView()
    var products: [Product?]?
    var profile: Profile?
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        setupViews()
        collectionView.reloadData()
    }
    
    private func setupViews() {
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroImage.contentMode = .scaleAspectFit
        heroImage.layer.cornerRadius = 30
        heroImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        if let proPicURL = URL(string: profile?.avatarURL ?? "") {
            profileImage.loadImage(fromURL: proPicURL, placeHolderImage: "Wrench")
        }
        profileImage.contentMode = .scaleAspectFit
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.clipsToBounds = true
        collectionView.backgroundColor = .clear
        view.addSubview(heroImage)
        view.addSubview(profileImage)
        view.addSubview(collectionView)
        profileImage.trailingAnchor.constraint(equalTo: heroImage.leadingAnchor, constant: -8).isActive = true
        profileImage.topAnchor.constraint(equalTo: heroImage.topAnchor).isActive = true
        heroImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.75).isActive = true
        heroImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2.25).isActive = true
        heroImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        heroImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        collectionView.topAnchor.constraint(equalTo: heroImage.bottomAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
    }
}
