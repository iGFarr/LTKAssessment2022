//
//  LTKBlankViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/9/22.
//

import UIKit

class LTKBlankViewController: UIViewController, SearchFilterController, UISearchBarDelegate {
    var navSearchBar: LTKSearchBar = LTKSearchBar()
    
    @objc
    func filterResults(_ sender: UITextField) {
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .LTKTheme.primary
        LTKUIUtilities.setupNavBarForVC(self)
        let comingSoonLabel = LTKLabel()
        self.view.addSubview(comingSoonLabel)
        self.navSearchBar.delegate = self
        comingSoonLabel.xAlignedWith(self.view)
        comingSoonLabel.yAlignedWith(self.view)
        comingSoonLabel.font = .LTKFonts.primary.withSize(35)
        comingSoonLabel.text = "Coming-Soon".localized()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        LTKUIUtilities.setupNavBarForVC(self)
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
