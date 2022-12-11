//
//  ViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

final class LTKLaunchViewController: LTKBaseTableViewController {

    private var feed: Feed?
    private var filteredLtks: [Ltk]? = []
    private var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.createHeader()
        self.loadFeed()
        self.title = "Home-Tab".localized()
    }
    
    private func loadFeed() {
        LTKNetworkUtilites.getFeed(fromURLString: "\(LTKConstants.URLS.rewardStyleLTKS)\(self.page)", completion: { result in
            switch result {
            case .success(let response):
                self.feed = LTKNetworkUtilites.decodeData(data: response, type: Feed.self)
                
                if let ltks = self.feed?.ltks {
                    self.page += 1
                    self.filteredLtks?.append(contentsOf: ltks)
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
        self.tableView.register(LTKHomeFeedCell.self, forCellReuseIdentifier: LTKConstants.CellIdentifiers.heroImage)
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    private func createHeader() {
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        headerView.backgroundColor = .clear
        
        let labelView: UILabel = UILabel.init(frame: CGRect.init(x: LTKConstants.UI.doubleInset, y: LTKConstants.UI.defaultInset, width: UIScreen.main.bounds.width, height: headerView.frame.height))
        labelView.text = "Home-Page-Header".localized()
        labelView.textColor = .LTKTheme.tertiary
        labelView.font = .LTKFonts.primary.withSize(18)
        
        headerView.addSubview(labelView)
        self.tableView.tableHeaderView = headerView
    }
    
    
    override func filterResults() {
        self.filteredLtks?.removeAll()
            let ltks = self.feed?.ltks.filter {
                if $0.caption.localizedCaseInsensitiveContains(self.navSearchBar.searchTextField.text ?? "") || self.navSearchBar.searchTextField.text?.count == 0 {
                    return true
                }
                return false
            }
            if let ltks = self.feed?.ltks, ltks.count >= LTKConstants.pageSize {
                if let count = self.filteredLtks?.count {
                    self.filteredLtks?.append(contentsOf: ltks[count..<(count + LTKConstants.pageSize)])
                }
            } else if ltks?.count ?? 0 < LTKConstants.pageSize {
                self.filteredLtks = ltks
            }
        print("Filtered: \(ltks?.count ?? 0)")
        print("Showing: \(self.filteredLtks?.count ?? 0)")
        self.reloadTableView()
    }
}


extension LTKLaunchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredLtks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LTKConstants.CellIdentifiers.heroImage, for: indexPath) as! LTKHomeFeedCell
        if let ltk = self.filteredLtks?[indexPath.row], let profiles = self.feed?.profiles {
            var profileURL: URL?
            for profile in profiles {
                if ltk.profileID == profile.id {
                    profileURL = URL(string: profile.avatarURL)
                    cell.profileNameLabel.text = profile.displayName
                    cell.accessibilityLabel = "\(profile.displayName)\n  Go to product list"
                }
            }
            
            if let url = URL(string: ltk.heroImage) {
                DispatchQueue.main.async {
                    cell.ltkImageView.loadImage(fromURL: url)
                    if let profileURL = profileURL {
                        cell.profileImage.loadImage(fromURL: profileURL)
                    }
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

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let ltks = self.feed?.ltks.filter {
//            if $0.caption.localizedCaseInsensitiveContains(self.navSearchBar.searchTextField.text ?? "") || self.navSearchBar.searchTextField.text?.count == 0 {
//                return true
//            }
//            return false
//        }
        guard ((self.filteredLtks?.count ?? 0) - 1) <= indexPath.row else { return }
//        if ltks.count > indexPath.row + LTKConstants.pageSize {
//            if let count = self.filteredLtks?.count {
//                self.filteredLtks?.append(contentsOf: ltks[count..<(count + LTKConstants.pageSize)])
//            }
//        } else {
//            self.filteredLtks = ltks
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            print("loaded data from page \(self.page)")
            self.loadFeed()
//            print("\n**ADDING ROWS**\n")
//            self.reloadTableView()
        }
    }
}
