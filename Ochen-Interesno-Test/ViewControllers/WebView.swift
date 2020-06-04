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
    
    var link: String!
    
    private let webView = WKWebView()
    private var worningView: WrapperViewWithLabel?
    
    
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
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }
    
    private func showWorning() {
        print("sdfsdf")
        worningView = WrapperViewWithLabel(text: "Не удалось открыть '\(link!)'")
        view.addSubview(worningView!)
        worningView!.frame = view.bounds
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
        worningView?.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showWorning()
    }
    
}
