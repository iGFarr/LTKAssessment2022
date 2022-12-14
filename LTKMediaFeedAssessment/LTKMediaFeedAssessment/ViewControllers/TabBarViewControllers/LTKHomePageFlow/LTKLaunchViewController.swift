//
//  ViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

final class LTKLaunchViewController: LTKBaseTableViewController {

    private var filteredLtks: [Ltk]? = []
    private var filteredLtkIds = [String: String]()
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
                        if let _ = self.filteredLtkIds[ltk.id] {
                            continue
                        }
                        self.loadedResultsForPage += 1
                        self.filteredLtkIds[ltk.id] = ltk.profileID
                        ltksToAdd.append(ltk)
                    }
                    self.filteredLtks?.append(contentsOf: ltksToAdd)
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
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.register(LTKHomeFeedCell.self, forCellReuseIdentifier: LTKConstants.CellIdentifiers.heroImage)
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    private func createHeader() {
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: LTKConstants.UI.homePageHeaderHeight))
        headerView.backgroundColor = .clear
        
        let labelView: UILabel = UILabel.init(frame: CGRect.init(x: LTKConstants.UI.doubleInset, y: LTKConstants.UI.defaultInset, width: UIScreen.main.bounds.width, height: headerView.frame.height))
        labelView.text = "Home-Page-Header".localized()
        labelView.textColor = .LTKTheme.tertiary
        labelView.font = .LTKFonts.primary.withSize(LTKConstants.UI.homePageHeaderTextSize)
        
        headerView.addSubview(labelView)
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
        self.filteredLtks?.removeAll()
        self.profileSet.removeAll()
        self.productSet.removeAll()
        self.filteredLtkIds.removeAll()
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
        
        cell.followButton.addTapGestureRecognizer {
            var followedUsers = UserDefaultsHelper().followedCreators
            var followedUserSet = Set(followedUsers)
            var buttonTitle = "Follow".localized()
            if followedUserSet.contains(ltk.profileID) {
                followedUserSet.remove(ltk.profileID)
            } else {
                buttonTitle = "Unfollow".localized()
                followedUserSet.insert(ltk.profileID)
            }
            let followAttributedTitle = NSAttributedString(string: buttonTitle, attributes: LTKUIUtilities.getDefaultTitleAttributes(font: .LTKFonts.primary.withSize(CGFloat(16).scaled)))
            DispatchQueue.main.async {
                cell.followButton.setAttributedTitle(followAttributedTitle, for: .normal)
            }
            print("followed users: \(followedUserSet)")
            followedUsers = Array(followedUserSet)
            UserDefaultsHelper().followedCreators = followedUsers
        }
        
        let favoritedLtks = UserDefaultsHelper().favoritedLtks
        let favoritedLtkSet = Set(favoritedLtks)
        if favoritedLtkSet.contains(ltk.id) {
            DispatchQueue.main.async {
                cell.favoriteButton.configuration = .filled()
                cell.favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.LTKTheme.primary), for: .normal)
            }
        } else {
            DispatchQueue.main.async {
                cell.favoriteButton.configuration = .bordered()
                cell.favoriteButton.tintColor = .LTKTheme.tertiary.withAlphaComponent(LTKConstants.UI.slightTranslucency)
                cell.favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.LTKTheme.tertiary), for: .normal)
            }
        }

        cell.favoriteButton.addTapGestureRecognizer {
            var favoritedLtks = UserDefaultsHelper().favoritedLtks
            var favoritedLtkSet = Set(favoritedLtks)
            if favoritedLtkSet.contains(ltk.id) {
                cell.favoriteButton.configuration = .bordered()
                cell.favoriteButton.tintColor = .LTKTheme.tertiary.withAlphaComponent(LTKConstants.UI.slightTranslucency)
                DispatchQueue.main.async {
                    cell.favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.LTKTheme.tertiary), for: .normal)
                }
                favoritedLtkSet.remove(ltk.id)
            } else {
                cell.favoriteButton.configuration = .filled()
                DispatchQueue.main.async {
                    cell.favoriteButton.setImage(UIImage(systemName: "heart")?.withTintColor(.LTKTheme.primary), for: .normal)
                }
                favoritedLtkSet.insert(ltk.id)
            }
            print("Tapped Favorite Button")
            print("favorited Ltks: \(favoritedLtkSet)")
            favoritedLtks = Array(favoritedLtkSet)
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
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
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
        if let ltk = self.filteredLtks?[indexPath.row] {
            cell.ltkId = ltk.id
            cell.shareButton.addTapGestureRecognizer {
                self.share(urlString: ltk.shareURL)
            }
            self.setButtonAppearancesAndGestures(for: ltk, cell: cell)
            var profileURL: URL?
            for profile in self.profileSet {
                if ltk.profileID == profile.id {
                    profileURL = URL(string: profile.avatarURL)
                    cell.profileNameLabel.attributedText = NSAttributedString(string: profile.displayName, attributes: LTKUIUtilities.getDefaultTitleAttributes(font: .LTKFonts.primary.withSize(18)))
                    cell.accessibilityLabel = "\(profile.displayName)\n  Go to product list"
                    cell.creatorId = profile.id
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
