//
//  LTKKit.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

final class LazyImageView: UIImageView {
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = LTKConstants.Caching.cacheDataSizeLimit
        cache.countLimit = LTKConstants.Caching.cacheObjectLimit
        return cache
    }()
    static let shared = LazyImageView()
    func loadImage(fromURL imageURL: URL, compressionRatio: CGFloat = LTKConstants.Caching.defaultImageCompression) {
        if let cachedImage = Self.shared[imageURL.absoluteString] {
            self.image = cachedImage
            print("\nloaded image from cache - URL:\n\(imageURL)\n")
            return
        }
        
        self.showLoadingIndicator()
        DispatchQueue.global(qos: .utility).async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL) {
                print("\n**loaded image from Server - URL:\n\(imageURL)\n")
                if var image = UIImage(data: imageData) {
                    let initialData = image.jpegData(compressionQuality: 1.0)?.count ?? 0
                    image = UIImage(data: image.jpegData(compressionQuality: compressionRatio) ?? imageData) ?? UIImage()
                    let finalData = image.jpegData(compressionQuality: 1.0)?.count ?? 0
                    print("\nData compressed from \(initialData) bytes to \(finalData)\n")
                    Self.shared[imageURL.absoluteString, finalData] = image
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                        self?.stopLoadingIndicator()
                    }
                }
            }
        }
    }
    
    public subscript(key: String, cost: Int? = nil) -> UIImage? {
        get {
            return Self.shared.imageCache.object(forKey: key as NSString)
        }
        set {
            if let newValue = newValue {
                Self.shared.imageCache.setObject(newValue, forKey: key as NSString, cost: cost ?? 0)
            }
            else {
                Self.shared.imageCache.removeObject(forKey: key as NSString)
            }
        }
    }
}

final class LTKView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class LTKLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = .LTKFonts.primary
        self.textColor = .LTKTheme.tertiary
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("no coder implemented")
    }
}

final class LTKButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configuration = .filled()
        self.tintColor = .LTKTheme.tertiary.withAlphaComponent(LTKConstants.UI.substantiallyTranslucent)
        self.addBorder(LTKConstants.UI.thinBorderWidth)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// Convenience functions brought in from my personal projects
extension UIView {
    public func addSubviews(_ views: [UIView]){
        for view in views {
            self.addSubview(view)
        }
    }
    
    public func circularize(addingBorder: Bool = true, ratio: CGFloat = 2) {
        guard self.frame.size != .zero else {
            print("MUST SET FRAME TO CIRCULARIZE")
            return
        }
        self.layer.cornerRadius = self.frame.size.width / ratio
        if addingBorder {
            self.addBorder()
        }
        self.clipsToBounds = true
    }
    
    func addBorder(_ size: CGFloat = LTKConstants.UI.thickBorderWidth) {
        self.layer.borderColor = UIColor.LTKTheme.tertiary.cgColor
        self.layer.borderWidth = size
        self.clipsToBounds = true
    }

    public func top(_ yConstraint: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
        self.topAnchor.constraint(equalTo: yConstraint, constant: constant).isActive = true
    }
    
    public func bottom(_ yConstraint: NSLayoutYAxisAnchor, constant: CGFloat = 0) {
        self.bottomAnchor.constraint(equalTo: yConstraint, constant: constant).isActive = true
    }
    
    public func leading(_ xConstraint: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        self.leadingAnchor.constraint(equalTo: xConstraint, constant: constant).isActive = true
    }
    
    public func trailing(_ xConstraint: NSLayoutXAxisAnchor, constant: CGFloat = 0) {
        self.trailingAnchor.constraint(equalTo: xConstraint, constant: constant).isActive = true
    }
    
    public func heightEqualsHeightOf(_ view: UIView, constant: CGFloat = 0) {
        self.heightAnchor.constraint(equalTo: view.heightAnchor, constant: constant).isActive = true
    }
    
    public func heightConstant(_ constant: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    public func widthEqualsWidthOf(_ view: UIView, constant: CGFloat = 0) {
        self.widthAnchor.constraint(equalTo: view.widthAnchor, constant: constant).isActive = true
    }
    
    public func widthConstant(_ constant: CGFloat) {
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    public func xAlignedWith(_ view: UIView, offset: CGFloat = 0) {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset).isActive = true
    }
    
    public func yAlignedWith(_ view: UIView, offset: CGFloat = 0) {
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive = true
    }
    
    func constrainToEdgePosition(_ corner: EdgePosition, in view: UIView, insetBy inset: CGFloat = LTKConstants.UI.doubleInset, safeArea: Bool = false) {
        view.addSubview(self)
        switch corner {
        case .topLeft:
            self.top(safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: inset/2)
            self.leading(safeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor, constant: inset)
        case .topRight:
            self.top(safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: inset/2)
            self.trailing(safeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor, constant: -inset)
        case .bottomLeft:
            self.bottom(safeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: -inset/2)
            self.leading(safeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor, constant: inset)
        case .bottomRight:
            self.bottom(safeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: -inset/2)
            self.trailing(safeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor, constant: -inset)
        case .topCenter:
            self.top(safeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, constant: inset/2)
            self.xAlignedWith(view)
        }
    }
}

extension UIView {
    static let loadingViewTag = 1938123987
    func showLoadingIndicator(style: UIActivityIndicatorView.Style = .large) {
        var loading = self.viewWithTag(UIImageView.loadingViewTag) as? UIActivityIndicatorView
        if loading == nil {
            loading = UIActivityIndicatorView(style: style)
            loading?.color = .LTKTheme.tertiary
        }

        loading?.translatesAutoresizingMaskIntoConstraints = false
        loading?.startAnimating()
        loading?.hidesWhenStopped = true
        loading?.tag = UIView.loadingViewTag
        self.addSubview(loading ?? UIView())
        loading?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loading?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

    func stopLoadingIndicator() {
        let loading = self.viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
        loading?.stopAnimating()
        loading?.removeFromSuperview()
    }
}

// Streamlines tap gestures on views
extension UIView {
        // In order to create computed properties for extensions, we need a key to
        // store and access the stored property
        fileprivate struct AssociatedObjectKeys {
            static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
        }
        
        fileprivate typealias Action = (() -> Void)?
        
        // Set our computed property type to a closure
        fileprivate var tapGestureRecognizerAction: Action? {
            set {
                if let newValue = newValue {
                    // Computed properties get stored as associated objects
                    objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                }
            }
            get {
                let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
                return tapGestureRecognizerActionInstance
            }
        }
        
        // This is the meat of the sauce, here we create the tap gesture recognizer and
        // store the closure the user passed to us in the associated object we declared above
        public func addTapGestureRecognizer(action: (() -> Void)?) {
            self.isUserInteractionEnabled = true
            self.tapGestureRecognizerAction = action
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
            self.addGestureRecognizer(tapGestureRecognizer)
        }
        
        // Every time the user taps on the UIImageView, this function gets called,
        // which triggers the closure we stored
        @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
            if let action = self.tapGestureRecognizerAction {
                action?()
            } else {
                print("no action")
            }
        }
}

extension Array where Element: Hashable {
    mutating func remove(_ values: [Element]) {
        let set = Set(values)
        self.removeAll { set.contains($0) }
    }
}

extension String {
    public func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}

enum EdgePosition {
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
    case topCenter
}

extension CGFloat {
    var scaled: CGFloat {
        self * LTKConstants.UI.scaleMultiplier
    }
}
extension UIFont {
    struct LTKFonts {
        static let primary = UIFont(name: "Noteworthy-Light", size: LTKConstants.UI.navTitleTextSize) ?? .systemFont(ofSize: LTKConstants.UI.navTitleTextSize)
    }
}

extension UIColor {
    struct LTKTheme {
        static let primary: UIColor = .systemBackground
        static let secondary: UIColor = .label
        static let tertiary: UIColor = UIColor(named: "LTKTertiary") ?? .systemMint
    }
}
