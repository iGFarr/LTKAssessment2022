//
//  LTKBlankViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/9/22.
//

import UIKit

class LTKBlankViewController: UIViewController, SearchFilterController {
    var navSearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * LTKConstants.UI.navSearchBarWidthRatio, height: 0))
    
    @objc
    func filterResults(_ sender: UITextField) {
        return
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .LTKTheme.primary
        LTKUIUtilities.setupNavBarForVC(self, selector: #selector(self.filterResults), buttonAction: UIAction(handler: { _ in
            LTKUIUtilities.displayTheRepoFrom(self)
        }))
        let comingSoonLabel = UILabel()
        comingSoonLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(comingSoonLabel)
        comingSoonLabel.xAlignedWith(self.view)
        comingSoonLabel.yAlignedWith(self.view)
        comingSoonLabel.textColor = .LTKTheme.tertiary
        comingSoonLabel.font = .LTKFonts.getPrimaryFontOfSize(35)
        comingSoonLabel.text = "COMING SOON!"
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        LTKUIUtilities.setupNavBarForVC(self, selector: #selector(self.filterResults), buttonAction: UIAction(handler: { _ in
            LTKUIUtilities.displayTheRepoFrom(self)
        }))
    }
}
