//
//  ViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

final class LTKLaunchViewController: LTKBaseTableViewController {

    private var feed: Feed?
    private var filteredLtks: [Ltk]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.createHeader()
        self.loadFeed()
    }
    
    private func loadFeed() {
        LTKNetworkUtilites.getFeed(completion: { result in
            switch result {
            case .success(let response):
                self.feed = response
                /// MARK: - This conditional would become useful for implementing data refreshing
                if self.filteredLtks == nil || self.filteredLtks?.count == 0 {
                    self.filteredLtks = response.ltks
                    self.filterResults()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.reloadTableView()
        })
    }
    
    private func setupTableView() {
        self.tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        self.tableView.backgroundColor = .LTKTheme.primary
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.register(LTKImageCell.self, forCellReuseIdentifier: LTKConstants.CellIdentifiers.heroImage)
    }
    
    private func createHeader() {
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        headerView.backgroundColor = .clear

        let labelView: UILabel = UILabel.init(frame: CGRect.init(x: LTKConstants.UI.doubleInset, y: LTKConstants.UI.defaultInset, width: UIScreen.main.bounds.width, height: headerView.frame.height))
        labelView.text = LTKConstants.Strings.postsYouLike
        labelView.textColor = .LTKTheme.tertiary
        labelView.font = .LTKFonts.primary.withSize(18)

        headerView.addSubview(labelView)
        self.tableView.tableHeaderView = headerView
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    
    override func filterResults() {
        DispatchQueue.main.async {
            if self.navSearchBar.searchTextField.text?.count == 0 {
                self.filteredLtks = self.feed?.ltks
            } else {
                self.filteredLtks = self.feed?.ltks.filter {
                    if $0.caption.localizedCaseInsensitiveContains(self.navSearchBar.searchTextField.text ?? "") {
                        return true
                    }
                    /// MARK: -
                    /*                I made an assumption that profileUserID was a display string, but after checking those values I realize this
                     //                  is not a good filtering option.
                     //                if $0.profileID.localizedCaseInsensitiveContains(self.navSearchBar.searchTextField.text ?? "") {
                     //                    print("pro id: \($0.profileID)")
                     //                    print("pro user id: \($0.profileUserID)")
                     //                    return true
                     //                }
                     */
                    return false
                }
            }
        }
        self.reloadTableView()
    }
}

extension LTKLaunchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredLtks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LTKConstants.CellIdentifiers.heroImage, for: indexPath) as! LTKImageCell
        if let ltk = self.filteredLtks?[indexPath.row] {
            if let url = URL(string: ltk.heroImage) {
                DispatchQueue.main.async {
                    cell.ltkImageView.loadImage(fromURL: url)
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailScreen = LTKDetailViewController()
        if (self.filteredLtks?.count ?? 0) > indexPath.row , let ltk = self.filteredLtks?[indexPath.row] {
            var matchedProducts: [Product] = []
            if let products = self.feed?.products {
                for product in products {
                    /// MARK: -  The following line taught me that xcode does not like trailing closures as a conditional
                    if ltk.productIDS.contains(where: { $0 == product.id }) {
                        matchedProducts.append(product)
                    }
                }
                detailScreen.products = matchedProducts
            }
            
            if let profiles = self.feed?.profiles {
                for profile in profiles {
                    if profile.id == ltk.profileID {
                        detailScreen.profile = profile
                        detailScreen.title = profile.displayName
                    }
                }
            }
            
            if let url = URL(string: ltk.heroImage) {
                detailScreen.heroImage.loadImage(fromURL: url)
            }
        }
        self.show(detailScreen, sender: self)
    }
}
