//
//  LTKBaseViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

protocol SearchFilterController: UIViewController {
    var navSearchBar: LTKSearchBar { get set }
}

class LTKBaseTableViewController: UITableViewController, SearchFilterController, UISearchBarDelegate {
    var navSearchBar: LTKSearchBar = LTKSearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .LTKTheme.primary
        self.navSearchBar.delegate = self
        LTKUIUtilities.setupNavBarForVC(self)
    }
    
    @objc
    func filterResults() {
        print("default editing event action triggered")
    }
    
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        LTKUIUtilities.setupNavBarForVC(self)
        self.reloadTableView()
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

class LTKBaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
