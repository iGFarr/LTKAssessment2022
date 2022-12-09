//
//  LTKWebView.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/8/22.
//

import UIKit
import WebKit

class LTKWebViewController: UIViewController, WKNavigationDelegate {
    private let webView = WKWebView()
    var url: URL?
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        self.webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        self.title = self.name != nil ? self.name : "No Name"
        self.view.backgroundColor = .systemBackground
        if let url = self.url {
            let request = URLRequest(url: url)
            DispatchQueue.main.async {
                self.webView.load(request)
                self.constrainWebView()
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath! == "URL" {
            self.url = URL(string: (self.webView.url?.absoluteString)!)
        }
    }
    
    private func constrainWebView(){
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        LTKConstraintHelper.constrain(self.webView, toSafeAreaOf: self.view)
    }
}
