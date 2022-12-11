//
//  LTKUIUtilities.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/10/22.
//
import UIKit

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
        vc.navSearchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search-Placeholder".localized(), attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.LTKTheme.tertiary,
            NSAttributedString.Key.font: UIFont.LTKFonts.primary.withSize(LTKConstants.UI.navSearchBarTextSize)
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
    
    static func getDefaultTitleAttributes(font: UIFont = .LTKFonts.primary.withSize(14), italicized: CGFloat = LTKConstants.UI.italicizeFontNSKey, color: UIColor = .LTKTheme.tertiary) -> [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.obliqueness: italicized,
            NSAttributedString.Key.foregroundColor: color
        ]
    }
}
