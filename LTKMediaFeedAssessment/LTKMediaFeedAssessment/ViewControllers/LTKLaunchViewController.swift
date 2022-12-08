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
        self.tableView.register(LTKImageCell.self, forCellReuseIdentifier: LTKConstants.cellIdentifiers.heroImage)
        self.loadFeed()
    }
    
    private func loadFeed(){
        LTKNetworkUtilites.getFeed(completion: { result in
            switch result {
            case .success(let response):
                self.feed = response
                self.filteredLtks = response.ltks
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.reloadTableView()
        })
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return LTKConstants.Strings.postsYouLike
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredLtks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LTKConstants.cellIdentifiers.heroImage, for: indexPath) as! LTKImageCell
        if let ltk = self.filteredLtks?[indexPath.row] {
            if let url = URL(string: ltk.heroImage) {
                DispatchQueue.main.async {
                    cell.ltkImageView.loadImage(fromURL: url, placeHolderImage: "wrench")
                }
            }
        }
        return cell
    }
    
    override func filterResults(_ sender: UITextField) {
        if self.navSearchBar.searchTextField.text?.count == 0 {
            self.filteredLtks = self.feed?.ltks
        } else {
            self.filteredLtks = self.feed?.ltks.filter {
//                $0.caption.localizedCaseInsensitiveContains(navSearchBar.searchTextField.text ?? "")
                if $0.caption.localizedCaseInsensitiveContains(self.navSearchBar.searchTextField.text ?? "") {
                    return true
                }
                if $0.profileUserID.localizedCaseInsensitiveContains(self.navSearchBar.searchTextField.text ?? "") {
                    return true
                }
                return false
            }
        }
        self.reloadTableView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailScreen = LTKDetailViewController()
        if (self.filteredLtks?.count ?? 0) > indexPath.row , let ltk = self.filteredLtks?[indexPath.row] {
            var matchedProducts: [Product] = []
            if let products = self.feed?.products {
                for product in products {
                    if ltk.productIDS.contains(where: { string in
                        string == product.id
                    }) {
                        matchedProducts.append(product)
                    }
                }
                detailScreen.products = matchedProducts
            }
            
            if let profiles = feed?.profiles {
                for profile in profiles {
                    if profile.id == ltk.profileID {
                        detailScreen.profile = profile
                        detailScreen.title = profile.displayName
                    }
                }
            }
            
            if let url = URL(string: ltk.heroImage) {
                detailScreen.heroImage.loadImage(fromURL: url, placeHolderImage: "Wrench")
            }
        }
        show(detailScreen, sender: self)
    }
    
}
