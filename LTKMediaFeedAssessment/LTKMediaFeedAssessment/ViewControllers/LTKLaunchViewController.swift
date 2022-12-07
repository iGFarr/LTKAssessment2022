//
//  ViewController.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/7/22.
//

import UIKit

class LTKLaunchViewController: LTKBaseTableViewController {

    private var feed: Feed?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeed()
    }
    
    private func loadFeed(){
        LTKUtilites.getFeed(completion: { result in
            switch result {
            case .success(let response):
                self.feed = response
            case .failure(let error):
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "For You: Posts we think you'll like"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return feed?.ltks.count ?? 1 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let ltk = feed?.ltks[indexPath.row] {
            cell.textLabel?.text = "\(ltk.heroImage)"
        }
        return cell
    }
}

