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
    
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        LTKUIUtilities.setupNavBarForVC(self, selector: #selector(self.filterResults), buttonAction: UIAction(handler: { _ in
            LTKUIUtilities.displayTheRepoFrom(self)
        }))
        for view in self.view.subviews {
            if view.layer.borderWidth > 0 {
                view.layer.borderColor = UIColor.LTKTheme.tertiary.cgColor
            }
        }
        
        for num in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: num, section: 0))
            if let cell = cell as? LTKImageCell {
                cell.ltkImageView.layer.borderColor = UIColor.LTKTheme.tertiary.cgColor
                cell.profileImage.layer.borderColor = UIColor.LTKTheme.tertiary.cgColor
            }
        }
        
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        for view in self.view.subviews {
            if view.layer.borderWidth > 0 {
                view.layer.borderColor = UIColor.LTKTheme.tertiary.cgColor
            }
        }
    }
}
