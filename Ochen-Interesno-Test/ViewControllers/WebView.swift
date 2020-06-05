//
//  WebView.swift
//  Ochen-Interesno-Test
//
//  Created by art-off on 03.06.2020.
//  Copyright © 2020 art-off. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: - Properties
    var link: String!
    
    private let webView = WKWebView()
    private var worningView: WrapperViewWithLabel?
    
    
    // MARK: - Ovverides
    override func loadView() {
        view = webView
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            showWorning()
        }
        
        addToolbar()
    }
    
    // MARK: - Toolbar
    private func addToolbar() {
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let openInBrouserButton = UIBarButtonItem(title: "В браузере", style: .done, target: self, action: #selector(openInBrouser))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [reloadButton, flexibleSpace, openInBrouserButton]
        navigationController?.isToolbarHidden = false
    }
    
    @objc private func openInBrouser() {
        if let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Show Worning
    private func showWorning() {
        print("sdfsdf")
        worningView = WrapperViewWithLabel(text: "Не удалось открыть '\(link!)'")
        view.addSubview(worningView!)
        worningView!.frame = view.bounds
    }
}

// MARK: - WK Navigation Delegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        worningView?.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showWorning()
    }
    
}
