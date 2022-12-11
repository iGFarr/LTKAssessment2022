//
//  LTKMenuViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/10/22.
//

import UIKit

class LTKMenuViewController: UIViewController, SearchFilterController, UISearchBarDelegate {
    var navSearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * LTKConstants.UI.navSearchBarWidthRatio, height: 0))
    
    @objc
    func filterResults(_ sender: UITextField) {
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .LTKTheme.primary
        LTKUIUtilities.setupNavBarForVC(self, selector: #selector(self.filterResults), buttonAction: UIAction(handler: { _ in
            LTKUIUtilities.displayTheRepoFrom(self)
        }))
        let comingSoonLabel = UILabel()
        comingSoonLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(comingSoonLabel)
        self.navSearchBar.delegate = self
        comingSoonLabel.xAlignedWith(self.view)
        comingSoonLabel.yAlignedWith(self.view)
        comingSoonLabel.textColor = .LTKTheme.tertiary
        comingSoonLabel.font = .LTKFonts.primary.withSize(35)
        comingSoonLabel.text = "Coming-Soon".localized()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        LTKUIUtilities.setupNavBarForVC(self, selector: #selector(self.filterResults), buttonAction: UIAction(handler: { _ in
            LTKUIUtilities.displayTheRepoFrom(self)
        }))
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navSearchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchBar.endEditing(true)
        }
    }
}

