//
//  TBWKWebViewController.swift
//  TaboolaDemoSwiftApp
//
//  Copyright © 2017 Taboola. All rights reserved.
//

import UIKit
import WebKit
import TaboolaSDK

class TBWKFeedWebViewController: UIViewController {
    var webView:WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        
        view.addSubview(webView)
        webView.navigationDelegate = self // if needed, set delegate before registering the webview
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[webview]-0-|", metrics: nil, views: ["webview":webView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[webview]-0-|", metrics: nil, views: ["webview":webView]))
        self.loadExamplePage()
        
        TaboolaJS.sharedInstance().registerWebView(webView)
        
        /*
         unregister the webview when it's not needed any more
         TaboolaJS.sharedInstance().unregisterWebView(webView)
         */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadExamplePage() {
        let htmlPath = Bundle.main.path(forResource: "sampleFeedContentPage", ofType: "html")
        let appHtml = try! String.init(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8)
        webView.loadHTMLString(appHtml, baseURL: URL(string: "https:"))
    }
}

// MARK: - TaboolaJSDelegate
extension TBWKFeedWebViewController: TaboolaJSDelegate {
    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
    
    func webView(_ webView: UIView!, didLoadPlacementNamed placementName: String!, withHeight height: Float!) {
        print("Placement \(placementName) loaded successfully")
    }
    
    func webView(_ webView: UIView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        print("Placement \(placementName) failed to load because: \(error)")
    }
}

// MARK: - UIWebViewDelegate
extension TBWKFeedWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView did finish navigation")
    }
    
}

