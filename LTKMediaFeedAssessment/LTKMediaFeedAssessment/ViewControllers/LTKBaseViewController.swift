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
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        setupNavBar()
    }
    
    private func setupNavBar() {
        navSearchBar.placeholder = LTKConstants.Strings.searchPlaceholder
        navSearchBar.searchTextField.adjustsFontSizeToFitWidth = true
        navSearchBar.searchTextField.font = UIFont(name: "GeezaPro", size: LTKConstants.UI.navSearchTextSize)
        navSearchBar.searchTextField.backgroundColor = .white
        navSearchBar.layer.borderColor = UIColor.systemGray.cgColor.copy(alpha: 0.8)
        navSearchBar.layer.borderWidth = 1
        navSearchBar.layer.cornerRadius = 22
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
