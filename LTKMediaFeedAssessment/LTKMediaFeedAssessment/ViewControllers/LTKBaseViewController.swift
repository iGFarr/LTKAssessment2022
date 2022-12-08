//
//  LTKBaseViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

class LTKBaseTableViewController: UITableViewController {
    lazy var navSearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * LTKConstants.UI.navSearchBarWidthRatio, height: 0))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        setupNavBar()
    }
    
    private func setupNavBar() {
        navSearchBar.placeholder = LTKConstants.Strings.searchPlaceholder
        navSearchBar.searchTextField.adjustsFontSizeToFitWidth = true
        navSearchBar.searchTextField.font = UIFont(name: "GeezaPro", size: LTKConstants.UI.navSearchBarTextSize)
        navSearchBar.searchTextField.textColor = .label
        navigationItem.titleView?.tintColor =  .systemBackground
        navSearchBar.backgroundColor = .systemBackground
        navSearchBar.layer.borderColor = UIColor.systemGray.cgColor.copy(alpha: 0.8)
        navSearchBar.layer.borderWidth = LTKConstants.UI.thinBorderWidth
        navSearchBar.layer.cornerRadius = LTKConstants.UI.navSearchBarCornerRadius
        navSearchBar.searchTextField.backgroundColor = .systemBackground
        navSearchBar.searchTextField.clipsToBounds = true
        navSearchBar.searchTextField.addTarget(self, action: #selector(filterResults), for: .editingChanged)
        let rightNavBarButton = UIBarButtonItem(customView:navSearchBar)
        let image = UIImage(named: "ltklogo")?.withRenderingMode(.alwaysOriginal)
        
        let leftNavBarButton = UIBarButtonItem(title: nil, image: image, primaryAction: nil, menu: nil)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    @objc
    func filterResults(_ sender: UITextField) {
        print("default editing event action triggered")
    }
}
