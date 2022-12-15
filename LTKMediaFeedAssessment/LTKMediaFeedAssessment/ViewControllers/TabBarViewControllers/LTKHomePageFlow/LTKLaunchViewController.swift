//
//  ViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

final class LTKLaunchViewController: LTKBaseTableViewController {
    
    private var filteredLtks: NSMutableOrderedSet? = NSMutableOrderedSet()
    private var profileSet: Set<Profile> = Set()
    private var productSet: Set<Product> = Set()
    private let request = LTKFeedRequest()
    private var loadedResultsForPage = 0
    private var attemptsToLoadPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.createHeader()
        self.loadFeed()
    }
    
    private func loadFeed() {
        self.request.makeRequest { result in
            switch result {
            case .success(let response):
                if let response = response {
                    print("\n -- loaded data from page \(self.request.page)-- \n")
                    for profile in response.profiles {
                        self.profileSet.insert(profile)
                    }
                    
                    for product in response.products {
                        self.productSet.insert(product)
                    }
                    
                    var ltksToAdd = [Ltk]()
                    for ltk in response.ltks {
                        if self.loadedResultsForPage >= LTKConstants.URLS.pageSize {
                            break
                        }
                        //                        if let _ = self.filteredLtkIds[ltk.id] {
                        //                            continue
                        //                        }
                        if (self.filteredLtks?.contains { (responseLtk) in
                            if let responseLtk = responseLtk as? Ltk {
                                let hasDuplicate = responseLtk.id == ltk.id
                                return hasDuplicate
                            }
                            return false
                        } ?? true) {
                            continue
                        }
                        self.loadedResultsForPage += 1
                        ltksToAdd.append(ltk)
                    }
                    self.filteredLtks?.addObjects(from: ltksToAdd)
                    if self.attemptsToLoadPage >= 5 {
                        self.loadedResultsForPage = 0
                        self.reloadTableView()
                        return
                    }
                    if self.loadedResultsForPage < LTKConstants.URLS.pageSize {
                        self.attemptsToLoadPage += 1
                        self.loadFeed()
                    } else {
                        self.attemptsToLoadPage = 0
                        self.loadedResultsForPage = 0
                        self.request.page += 1
                        self.reloadTableView()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navSearchBar.searchTextField.text = "NO RESULTS FOUND"
                    }
                    self.reloadTableView()
                }
            default:
                break
            }
        }
    }
    
    private func setupTableView() {
        self.tableView.backgroundColor = .LTKTheme.primary
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.register(LTKHomeFeedCell.self, forCellReuseIdentifier: LTKConstants.CellIdentifiers.heroImage)
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    private func createHeader() {
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width - LTKConstants.UI.doubleInset, height: LTKConstants.UI.homePageHeaderHeight))
        headerView.backgroundColor = .clear
        
        let labelView: LTKLabel = LTKLabel()
        labelView.numberOfLines = 0
        labelView.attributedText = NSAttributedString(string: "Home-Page-Header".localized(), attributes: LTKUIUtilities.getDefaultTitleAttributes(font: .LTKFonts.primary.withSize(LTKConstants.UI.homePageHeaderTextSize), italicized: 0.05, kern: 0.5))
        headerView.addSubview(labelView)
        labelView.leading(headerView.leadingAnchor, constant: LTKConstants.UI.doubleInset)
        labelView.trailing(headerView.trailingAnchor,constant: -LTKConstants.UI.doubleInset)
        self.tableView.tableHeaderView = headerView
    }
    
    
    override func filterResults() {
        self.dumpLoadedDataAndResetRequest()
        if let text = self.navSearchBar.searchTextField.text {
            self.request.displayName = text.lowercased()
            if text == "" {
                self.request.displayName = nil
            }
        } else {
            self.request.displayName = nil
        }
        self.loadFeed()
    }
    
    private func dumpLoadedDataAndResetRequest() {
        self.filteredLtks?.removeAllObjects()
        self.profileSet.removeAll()
        self.productSet.removeAll()
        self.attemptsToLoadPage = 0
        self.request.page = 0
        self.loadedResultsForPage = 0
    }
    
    private func setButtonAppearancesAndGestures(for ltk: Ltk, cell: LTKHomeFeedCell) {
        let followedUsers = UserDefaultsHelper().followedCreators
        var followButtonString = "Follow".localized()
        if followedUsers.contains(ltk.profileID) {
            followButtonString = "Unfollow".localized()
        }
        let followAttributedTitle = NSAttributedString(string: followButtonString, attributes: LTKUIUtilities.getDefaultTitleAttributes(font: .LTKFonts.primary.withSize(CGFloat(16).scaled)))
        cell.followButton.setAttributedTitle(followAttributedTitle, for: .normal)
        
        cell.followButton.addTapGestureRecognizer { [weak cell] in
            var followedUsers = UserDefaultsHelper().followedCreators
            var buttonTitle = "Follow".localized()
            if followedUsers.contains(ltk.profileID) {
                followedUsers.remove([ltk.profileID])
            } else {
                buttonTitle = "Unfollow".localized()
                followedUsers.append(ltk.profileID)
            }
            let followAttributedTitle = NSAttributedString(string: buttonTitle, attributes: LTKUIUtilities.getDefaultTitleAttributes(font: .LTKFonts.primary.withSize(CGFloat(16).scaled)))
            DispatchQueue.main.async { [weak cell] in
                cell?.followButton.setAttributedTitle(followAttributedTitle, for: .normal)
            }
            print("followed users: \(followedUsers)")
            UserDefaultsHelper().followedCreators = followedUsers
        }
        
        let favoritedLtks = UserDefaultsHelper().favoritedLtks
        if favoritedLtks.contains(ltk.id) {
            cell.favoriteButton.configuration = .filled()
            cell.favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.LTKTheme.primary), for: .normal)
        } else {
            cell.favoriteButton.configuration = .bordered()
            cell.favoriteButton.tintColor = .LTKTheme.tertiary.withAlphaComponent(LTKConstants.UI.slightTranslucency)
            cell.favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.LTKTheme.tertiary), for: .normal)
        }
        
        cell.favoriteButton.addTapGestureRecognizer { [weak cell] in
            var favoritedLtks = UserDefaultsHelper().favoritedLtks
            if favoritedLtks.contains(ltk.id) {
                cell?.favoriteButton.configuration = .bordered()
                cell?.favoriteButton.tintColor = .LTKTheme.tertiary.withAlphaComponent(LTKConstants.UI.slightTranslucency)
                DispatchQueue.main.async { [weak cell] in
                    cell?.favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.LTKTheme.tertiary), for: .normal)
                }
                favoritedLtks.remove([ltk.id])
            } else {
                cell?.favoriteButton.configuration = .filled()
                DispatchQueue.main.async { [weak cell] in
                    cell?.favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.LTKTheme.primary), for: .normal)
                }
                favoritedLtks.append(ltk.id)
            }
            print("Tapped Favorite Button")
            print("favorited Ltks: \(favoritedLtks)")
            UserDefaultsHelper().favoritedLtks = favoritedLtks
            
        }
    }
    
    private func share(urlString: String = "google.com"){
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = "Check out this cool LTK!"
        
        if let myWebsite = URL(string: urlString) {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            //Excluded Activities
            activityVC.excludedActivityTypes = []
            //
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}


extension LTKLaunchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredLtks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LTKConstants.CellIdentifiers.heroImage, for: indexPath) as? LTKHomeFeedCell else { return UITableViewCell() }
        if let ltk = self.filteredLtks?[indexPath.row] as? Ltk {
            cell.ltkId = ltk.id
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.setLocalizedDateFormatFromTemplate("MM-dd-YYYY HH:mm")
            let isoformatter = ISO8601DateFormatter()
            let date = isoformatter.date(from: ltk.publishDate)
            let formattedDate = formatter.string(from: date ?? Date())
            let publishDateString = String(format: "Posted-Date".localized(), "\(formattedDate)")
            cell.publishedLabel.attributedText = NSAttributedString(string: publishDateString, attributes: LTKUIUtilities.getDefaultTitleAttributes(font: .LTKFonts.primary.withSize(14), color: .LTKTheme.tertiary.withAlphaComponent(0.7)))
            cell.shareButton.addTapGestureRecognizer { [weak self] in
                self?.share(urlString: ltk.shareURL)
            }
            self.setButtonAppearancesAndGestures(for: ltk, cell: cell)
            var profileURL: URL?
            for profile in self.profileSet {
                if ltk.profileID == profile.id {
                    profileURL = URL(string: profile.avatarURL.appending("?w=\(LTKConstants.UI.imageWidthQueryParamValue)"))
                    cell.profileNameLabel.attributedText = NSAttributedString(string: profile.displayName, attributes: LTKUIUtilities.getDefaultTitleAttributes(font: .LTKFonts.primary.withSize(18)))
                    cell.accessibilityLabel = "\(profile.displayName)\n  Go to product list"
                    cell.creatorId = profile.id
                }
            }
            
            if let url = URL(string: ltk.heroImage.appending("?w=\(LTKConstants.UI.imageWidthQueryParamValue)")) {
                DispatchQueue.main.async { [weak cell] in
                    cell?.ltkImageView.loadImage(fromURL: url)
                    if let profileURL = profileURL {
                        cell?.profileImage.loadImage(fromURL: profileURL)
                    }
                }
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailScreen = LTKDetailViewController()
        if (self.filteredLtks?.count ?? 0) > indexPath.row , let ltk = self.filteredLtks?[indexPath.row] as? Ltk {
            var matchedProducts: [Product] = []
            for product in productSet {
                /// MARK: -  The following line taught me that xcode does not like trailing closures as a conditional
                if ltk.productIDS.contains(where: { $0 == product.id }) {
                    matchedProducts.append(product)
                }
            }
            detailScreen.products = matchedProducts
            for profile in profileSet {
                if profile.id == ltk.profileID {
                    detailScreen.profile = profile
                    detailScreen.title = profile.displayName
                }
            }
            
            
            if let url = URL(string: ltk.heroImage) {
                detailScreen.heroImage.loadImage(fromURL: url)
            }
        }
        self.show(detailScreen, sender: self)
    }
    
    // scrollViewDidEndDragging seems cleaner and easier
    //    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        guard ((self.filteredLtks?.count ?? 0) - 1) <= indexPath.row else { return }
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
    //            print("\n -- loaded data from page \(self.page)-- \n")
    //            self.loadFeed()
    //        }
    //    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if ((self.tableView.contentOffset.y + self.tableView.frame.size.height) >= self.tableView.contentSize.height)
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.loadFeed()
            }
        }
    }
}
