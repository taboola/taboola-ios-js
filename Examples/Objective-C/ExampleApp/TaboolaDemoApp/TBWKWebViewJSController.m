//
//  TBWKWebViewJSController.m
//  TaboolaDemoApp
//
//  Copyright © 2017 Taboola. All rights reserved.
//

#import "TBWKWebViewJSController.h"
#import <WebKit/WebKit.h>
#import <TaboolaSDK/TaboolaJS.h>

@interface TBWKWebViewJSController () <TaboolaJSDelegate, WKNavigationDelegate>

@end

@implementation TBWKWebViewJSController {
    WKWebView* webview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    webview = [[WKWebView alloc] init];
    [self.view addSubview:webview];
    
    webview.navigationDelegate = self;
    
    webview.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray* horizConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webview]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"webview": webview}];
    NSArray* vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[webview]-0-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:@{@"webview": webview}] ;
    [self.view addConstraints:horizConstraints];
    [self.view addConstraints:vertConstraints];
    
    [TaboolaJS sharedInstance].delegate = self;
    [[TaboolaJS sharedInstance] setLogLevel:LogLevelWarning];
    [[TaboolaJS sharedInstance] registerWebView:webview];
    [self loadExamplePage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadExamplePage {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"sampleContentPage" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [webview loadHTMLString:appHtml baseURL:[NSURL URLWithString:@"https:"]];
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

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webView didFinishNavigation");
}

@end
