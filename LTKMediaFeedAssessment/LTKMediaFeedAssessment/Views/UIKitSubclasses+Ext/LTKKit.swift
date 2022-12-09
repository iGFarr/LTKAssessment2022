//
//  LTKKit.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

class LazyImageView: UIImageView {
    
    private let imageCache = NSCache<AnyObject, UIImage>()
    func loadImage(fromURL imageURL: URL, placeHolderImage: String = "Wrench") {
        imageCache.totalCostLimit = LTKConstants.cacheLimitTwentyMb
        imageCache.countLimit = LTKConstants.cacheObjectLimit
        self.image = UIImage(named: placeHolderImage)?.withRenderingMode(.alwaysOriginal)
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject) {
            self.image = cachedImage
            print("loaded image from cache")
            return
        }

        DispatchQueue.global(qos: .utility).async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL) {
                print("loaded image from server")
                if var image = UIImage(data: imageData) {
                    /// MARK: - no matter the compression or the size of the cache, either the cache is still evicting items for some reason, or the image url is not consistent enough for use as a key maybe?
                    image = UIImage(data: image.jpegData(compressionQuality: 0.35) ?? imageData) ?? UIImage()
                    self?.imageCache.setObject(image, forKey: imageURL as AnyObject, cost: image.jpegData(compressionQuality: 1.0)?.count ?? 0)
                    DispatchQueue.main.async {
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

struct LTKConstraintHelper {
    static func constrain(_ subView: UIView, to view: UIView, usingInsets: Bool = false, leadingTrailingInset: CGFloat = LTKConstants.UI.defaultInset, topBottomInset: CGFloat = LTKConstants.UI.defaultInset) {
        view.addSubview(subView)
        var horizontalInsets: CGFloat = 0
        var verticalInsets: CGFloat = 0
        if usingInsets {
            horizontalInsets = leadingTrailingInset
            verticalInsets = topBottomInset
        }
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: view.topAnchor, constant: verticalInsets),
            subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -verticalInsets),
            subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalInsets),
            subView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalInsets)
        ])
    }
    
    static func constrain(_ subView: UIView, toSafeAreaOf view: UIView, usingInsets: Bool = false, leadingTrailingInset: CGFloat = LTKConstants.UI.defaultInset, topBottomInset: CGFloat = LTKConstants.UI.defaultInset) {
        view.addSubview(subView)
        var horizontalInsets: CGFloat = 0
        var verticalInsets: CGFloat = 0
        if usingInsets {
            horizontalInsets = leadingTrailingInset
            verticalInsets = topBottomInset
        }
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: verticalInsets),
            subView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -verticalInsets),
            subView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalInsets),
            subView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalInsets)
        ])
    }
    
    static func constrainWithCustomInsets(subView: UIView, to view: UIView, leftInset: CGFloat = 0, rightInset: CGFloat = 0, topInset: CGFloat = 0, bottomInset: CGFloat = 0) {
        view.addSubview(subView)
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: view.topAnchor, constant: topInset),
            subView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomInset),
            subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftInset),
            subView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightInset)
        ])
    }
}

extension UIFont {
    struct LTKFonts {
        static let primary = UIFont(name: "GeezaPro", size: LTKConstants.UI.navTitleTextSize) ?? .systemFont(ofSize: LTKConstants.UI.navTitleTextSize)
        static func getPrimaryFontOfSize(_ size: CGFloat) -> UIFont {
            return primary.withSize(size)
        }
    }
}

extension UIColor {
    struct LTKTheme {
        static let primary: UIColor = .systemBackground
        static let secondary: UIColor = .label
        static let tertiary: UIColor = UIColor(named: "LTKTertiary") ?? .systemMint
    }
}

struct LTKUIUtilities {
    static func setupNavBarForVC(_ vc: SearchFilterController, selector: Selector, buttonAction: UIAction? = nil) {
        vc.navSearchBar.searchTextField.adjustsFontSizeToFitWidth = true
        vc.navSearchBar.backgroundColor = .systemBackground
        vc.navSearchBar.layer.borderColor = UIColor.LTKTheme.tertiary.cgColor.copy(alpha: LTKConstants.UI.slightTranslucency)
        vc.navSearchBar.layer.borderWidth = LTKConstants.UI.thinBorderWidth
        vc.navSearchBar.layer.cornerRadius = LTKConstants.UI.navSearchBarCornerRadius
        vc.navSearchBar.searchTextField.backgroundColor = .systemBackground
        vc.navSearchBar.searchTextField.clipsToBounds = true
        vc.navSearchBar.searchTextField.leftView?.tintColor = .LTKTheme.tertiary
        vc.navSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: LTKConstants.Strings.searchPlaceholder, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.LTKTheme.tertiary,
            NSAttributedString.Key.font: UIFont.LTKFonts.getPrimaryFontOfSize(LTKConstants.UI.navSearchBarTextSize)
        ])
        /// MARK: - I think I like using search/return better than updating with every change.
//        vc.navSearchBar.searchTextField.addTarget(vc, action: selector, for: .editingChanged)
        let image = UIImage(named: LTKConstants.ImageNames.ltkLogo)?.withRenderingMode(.alwaysOriginal)
        let leftNavBarButton = UIBarButtonItem(title: nil, image: image, primaryAction: buttonAction, menu: nil)
        vc.navigationItem.leftBarButtonItem = leftNavBarButton
        
        let rightNavBarButton = UIBarButtonItem(customView: vc.navSearchBar)
        vc.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    static func displayTheRepoFrom(_ vc: UIViewController) {
        let webView = LTKWebViewController()
        if let url = URL(string: "https://github.com/iGFarr/LTKAssessment2022") {
            webView.url = url
            webView.name = "This App's Repo"
            vc.navigationController?.show(webView, sender: vc)
        }
    }
}
