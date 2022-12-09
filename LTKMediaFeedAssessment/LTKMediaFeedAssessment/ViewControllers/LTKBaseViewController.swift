//
//  LTKBaseViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

class LTKBaseTableViewController: UITableViewController {
    // Had initially marked this as lazy, but that seems kind of pointless considering the initial launch screen is of this class.
    var navSearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * LTKConstants.UI.navSearchBarWidthRatio, height: 0))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.setupNavBar()
    }
    
    private func setupNavBar() {
        self.navSearchBar.placeholder = LTKConstants.Strings.searchPlaceholder
        self.navSearchBar.searchTextField.adjustsFontSizeToFitWidth = true
        self.navSearchBar.searchTextField.font = .LTKFonts.getPrimaryFontOfSize(LTKConstants.UI.navSearchBarTextSize)
        self.navSearchBar.searchTextField.textColor = .label
        self.navSearchBar.backgroundColor = .systemBackground
        self.navSearchBar.layer.borderColor = UIColor.systemGray.cgColor.copy(alpha: LTKConstants.UI.slightTranslucency)
        self.navSearchBar.layer.borderWidth = LTKConstants.UI.thinBorderWidth
        self.navSearchBar.layer.cornerRadius = LTKConstants.UI.navSearchBarCornerRadius
        self.navSearchBar.searchTextField.backgroundColor = .systemBackground
        self.navSearchBar.searchTextField.clipsToBounds = true
        self.navSearchBar.searchTextField.addTarget(self, action: #selector(filterResults), for: .editingChanged)
        self.navigationItem.titleView?.tintColor =  .systemBackground
        
        let image = UIImage(named: LTKConstants.ImageNames.ltkLogo)?.withRenderingMode(.alwaysOriginal)
        let leftNavBarButton = UIBarButtonItem(title: nil, image: image, primaryAction: nil, menu: nil)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        let rightNavBarButton = UIBarButtonItem(customView:navSearchBar)
        self.navigationItem.rightBarButtonItem = rightNavBarButton
    }
    
    @objc
    func filterResults(_ sender: UITextField) {
        print("default editing event action triggered")
    }
}
