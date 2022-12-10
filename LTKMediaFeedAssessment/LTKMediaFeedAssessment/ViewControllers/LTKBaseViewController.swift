//
//  LTKBaseViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

protocol SearchFilterController: UIViewController {
    var navSearchBar: UISearchBar { get set }
}

class LTKBaseTableViewController: UITableViewController, SearchFilterController, UISearchBarDelegate {
    /// MARK: - Had initially marked this as lazy, but that seems kind of pointless considering the initial launch screen is of this class.
    var navSearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * LTKConstants.UI.navSearchBarWidthRatio, height: 0))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .LTKTheme.primary
        self.navSearchBar.delegate = self
        LTKUIUtilities.setupNavBarForVC(self, selector: #selector(self.filterResults), buttonAction: UIAction(handler: { _ in
            LTKUIUtilities.displayTheRepoFrom(self)
        }))
    }
    
    @objc
    func filterResults() {
        print("default editing event action triggered")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        LTKUIUtilities.setupNavBarForVC(self, selector: #selector(self.filterResults), buttonAction: UIAction(handler: { _ in
            LTKUIUtilities.displayTheRepoFrom(self)
        }))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navSearchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.filterResults()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            searchBar.endEditing(true)
        }
    }
}
