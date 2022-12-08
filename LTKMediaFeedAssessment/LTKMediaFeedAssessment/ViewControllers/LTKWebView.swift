//
//  LTKWebView.swift
//  LTKMediaFeedAssessment
//
//  Created by Isaac Farr on 12/8/22.
//

import UIKit
import WebKit

class LTKWebViewController: UIViewController {
    private let webView = WKWebView()
    
    var url: URL?
    var name: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        self.title = self.name != nil ? self.name : "No Name"
        view.backgroundColor = .systemBackground
        if let url = self.url {
            let request = URLRequest(url: url)
            DispatchQueue.main.async {
                self.webView.load(request)
                self.constrainWebView()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let url = self.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath! == "URL" {
            url = URL(string: (webView.url?.absoluteString)!)
        }
    }
    
    private func constrainWebView(){
        guard let navBarHeight = self.navigationController?.navigationBar.frame.size.height else { return }
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            webView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
