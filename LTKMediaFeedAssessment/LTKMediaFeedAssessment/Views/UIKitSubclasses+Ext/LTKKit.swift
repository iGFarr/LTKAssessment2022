//
//  LTKKit.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

class LazyImageView: UIImageView {
    
    private let imageCache = NSCache<AnyObject, UIImage>()
    func loadImage(fromURL imageURL: URL, placeHolderImage: String) {
        imageCache.totalCostLimit = LTKConstants.cacheLimitFiftyMb
        imageCache.countLimit = LTKConstants.cacheLimitTwentyObjects
        self.image = UIImage(named: placeHolderImage)?.withRenderingMode(.alwaysOriginal)
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject) {
            self.image = cachedImage
            print("loaded image from cache")
            return
        }

        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL) {
                print("loaded image from server")
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: imageURL as AnyObject, cost: image.pngData()?.count ?? 0)
                        self?.image = image
                    }
                }
            }
        }
    }
}

class LTKView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Convenience functions brought in from my personal projects
extension UIView {
    public func addSubviews(_ views: [UIView]){
        for view in views {
            addSubview(view)
        }
    }
    
    public func top(_ yConstraint: NSLayoutYAxisAnchor) {
        topAnchor.constraint(equalTo: yConstraint).isActive = true
    }
    
    public func bottom(_ yConstraint: NSLayoutYAxisAnchor) {
        bottomAnchor.constraint(equalTo: yConstraint).isActive = true
    }
    
    public func leading(_ xConstraint: NSLayoutXAxisAnchor) {
        leadingAnchor.constraint(equalTo: xConstraint).isActive = true
    }
    
    public func trailing(_ xConstraint: NSLayoutXAxisAnchor) {
        trailingAnchor.constraint(equalTo: xConstraint).isActive = true
    }
    
    public func top(_ yConstraint: NSLayoutYAxisAnchor, constant: CGFloat) {
        topAnchor.constraint(equalTo: yConstraint, constant: constant).isActive = true
    }
    
    public func bottom(_ yConstraint: NSLayoutYAxisAnchor, constant: CGFloat) {
        bottomAnchor.constraint(equalTo: yConstraint, constant: constant).isActive = true
    }
    
    public func leading(_ xConstraint: NSLayoutXAxisAnchor, constant: CGFloat) {
        leadingAnchor.constraint(equalTo: xConstraint, constant: constant).isActive = true
    }
    
    public func trailing(_ xConstraint: NSLayoutXAxisAnchor, constant: CGFloat) {
        trailingAnchor.constraint(equalTo: xConstraint, constant: constant).isActive = true
    }
    
    public func heightEqualsHeightOf(_ view: UIView) {
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    public func heightEqualsHeightOf(_ view: UIView, constant: CGFloat) {
        heightAnchor.constraint(equalTo: view.heightAnchor, constant: constant).isActive = true
    }
    
    public func heightConstant(_ constant: CGFloat) {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    public func widthEqualsWidthOf(_ view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    public func widthEqualsWidthOf(_ view: UIView, constant: CGFloat) {
        widthAnchor.constraint(equalTo: view.widthAnchor, constant: constant).isActive = true
    }
    
    public func widthConstant(_ constant: CGFloat) {
        widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    public func xAlignedWith(_ view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    public func yAlignedWith(_ view: UIView) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func constrainToEdgePosition(_ corner: EdgePosition, in view: UIView, insetBy inset: CGFloat = LTKConstants.UI.doubleInset, safeArea: Bool = false) {
        view.addSubview(self)
        switch corner {
        case .topLeft:
            top(safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: inset/2)
            leading(safeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor, constant: inset)
        case .topRight:
            top(safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: inset/2)
            trailing(safeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor, constant: -inset)
        case .bottomLeft:
            bottom(safeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: -inset/2)
            leading(safeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor, constant: inset)
        case .bottomRight:
            bottom(safeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: -inset/2)
            trailing(safeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor, constant: -inset)
        case .topCenter:
            top(safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: inset/2)
            xAlignedWith(view)
        }
    }
}

enum EdgePosition {
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
    case topCenter
}
