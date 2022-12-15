//
//  LTKUIUtilities.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/10/22.
//
import UIKit

struct LTKUIUtilities {
    static func setupNavBarForVC(_ vc: SearchFilterController, action: ()? = nil) {
        vc.navSearchBar.searchTextField.adjustsFontSizeToFitWidth = true
        vc.navSearchBar.backgroundColor = .systemBackground
        vc.navSearchBar.layer.borderColor = UIColor.LTKTheme.tertiary.cgColor.copy(alpha: LTKConstants.UI.slightTranslucency)
        vc.navSearchBar.layer.borderWidth = LTKConstants.UI.thinBorderWidth
        vc.navSearchBar.layer.cornerRadius = LTKConstants.UI.navSearchBarCornerRadius
        vc.navSearchBar.searchTextField.backgroundColor = .systemBackground
        vc.navSearchBar.searchTextField.clipsToBounds = true
        vc.navSearchBar.widthConstant(UIScreen.main.bounds.width * LTKConstants.UI.navSearchBarWidthRatio)
        vc.navSearchBar.heightConstant(LTKConstants.UI.navSearchBarHeight)
        vc.navSearchBar.searchTextField.leftView?.tintColor = .LTKTheme.tertiary
        vc.navSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search-Placeholder".localized(), attributes: LTKUIUtilities.getDefaultTitleAttributes(font: .LTKFonts.primary.withSize(LTKConstants.UI.navSearchBarTextSize), italicized: 0, kern: 0.5))
        let image = UIImage(named: LTKConstants.ImageNames.ltkLogo)?.withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: CGFloat(80).scaled).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: CGFloat(40).scaled).isActive = true
        let leftNavBarButton = UIBarButtonItem(customView: imageView)
        /// MARK:-  needed a custom view. size was changing slightly between launch screne an the other tabs. Was driving me crazy!
//        let leftNavBarButton = UIBarButtonItem(title: nil, image: image, primaryAction: buttonAction, menu: nil)
        leftNavBarButton.accessibilityLabel = "Go to repo"
        leftNavBarButton.customView?.addTapGestureRecognizer {
            action != nil ? action : displayTheRepoFrom(vc)
        }
        vc.navigationItem.leftBarButtonItem = leftNavBarButton
        
        let rightNavBarButton = UIBarButtonItem(customView: vc.navSearchBar)
        vc.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    static func displayTheRepoFrom(_ vc: UIViewController){
        let webView = LTKWebViewController()
        if let url = URL(string: "https://github.com/iGFarr/LTKAssessment2022") {
            webView.url = url
            webView.name = "This-Repo".localized()
            vc.navigationController?.show(webView, sender: vc)
        }
    }
    
    static func getDefaultTitleAttributes(font: UIFont = .LTKFonts.primary.withSize(CGFloat(16).scaled), italicized: CGFloat = LTKConstants.UI.italicizeFontNSKey, color: UIColor = .LTKTheme.tertiary, kern: CGFloat = 1.0) -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.obliqueness: italicized,
            NSAttributedString.Key.kern: kern,
            NSAttributedString.Key.foregroundColor: color
        ]
    }
}
