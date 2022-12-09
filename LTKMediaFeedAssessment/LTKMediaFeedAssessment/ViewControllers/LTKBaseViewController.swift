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

class LTKBaseTableViewController: UITableViewController, SearchFilterController, UITextFieldDelegate, UISearchBarDelegate {
    /// MARK: - Had initially marked this as lazy, but that seems kind of pointless considering the initial launch screen is of this class.
    var navSearchBar: UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * LTKConstants.UI.navSearchBarWidthRatio, height: 0))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .LTKTheme.primary
        self.navSearchBar.searchTextField.delegate = self
        self.navSearchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
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
        self.filterResults()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count == 0 {
            self.filterResults()
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)

        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
 }
