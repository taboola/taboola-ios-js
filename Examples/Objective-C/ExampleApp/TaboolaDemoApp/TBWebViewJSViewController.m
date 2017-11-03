//
//  TBWebViewJSViewController.m
//  TaboolaDemoApp
//
//  Copyright © 2017 Taboola. All rights reserved.
//

#import "TBWebViewJSViewController.h"
#import <TaboolaSDK/TaboolaJS.h>

@interface TBWebViewJSViewController () <TaboolaJSDelegate, UIWebViewDelegate>
@end

@implementation TBWebViewJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [TaboolaJS sharedInstance].delegate = self;
    [[TaboolaJS sharedInstance] setLogLevel:LogLevelWarning];
    
    [[TaboolaJS sharedInstance] registerWebView:self.webView];
    [self loadExamplePage];
    /*
     use `unregisterWebView:` before releasing the webview
     [[TaboolaJS sharedInstance] unregisterWebView:self.webView];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadExamplePage {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"sampleContentPage" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:appHtml baseURL:[NSURL URLWithString:@"https:"]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"WebView finished loading");
}

#pragma mark - TaboolaJS delegate method

- (BOOL)onItemClick:(NSString *)placementName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {
    return YES;
}

- (void)webView:(UIView *)webView didLoadPlacementNamed:(NSString *)placementName {
    NSLog(@"Placement %@ loaded successfully", placementName);
}

- (void)webView:(UIView *)webView didFailToLoadPlacementNamed:(NSString *)placementName withErrorMessage:(NSString *)error {
    NSLog(@"Placement %@ failed to load because: %@", placementName, error);
}

@end
