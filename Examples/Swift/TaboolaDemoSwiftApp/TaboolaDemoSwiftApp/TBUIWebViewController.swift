//
//  TBUIWebViewController.swift
//  TaboolaDemoSwiftApp
//
//  Copyright © 2017 Taboola. All rights reserved.
//

import UIKit
import TaboolaSDK

class TBUIWebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self // if needed, set delegate before registering the webview
        TaboolaJS.sharedInstance().registerWebView(webView)
        /*
         unregister the webview when it's not needed any more
         TaboolaJS.sharedInstance().unregisterWebView(webView)
         */
        loadExamplePage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadExamplePage() {
        let htmlPath = Bundle.main.path(forResource: "sampleContentPage", ofType: "html")
        let appHtml = try! String.init(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8)
        webView.loadHTMLString(appHtml, baseURL: URL(string: "https:"))
    }
}

// MARK: - TaboolaJSDelegate
extension TBUIWebViewController: TaboolaJSDelegate {
    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
    
    func webView(_ webView: UIView!, didLoadPlacementNamed placementName: String!) {
        print("Placement \(placementName) loaded successfully")
    }
    
    func webView(_ webView: UIView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        print("Placement \(placementName) failed to load because: \(error)")
    }
}

// MARK: - UIWebViewDelegate
extension TBUIWebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("DidFinishLoad")
    }
}
