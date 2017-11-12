# Taboola JS SDK iOS Reference
# TaboolaJS
### `+ (instancetype) sharedInstance`
#### **Returns:**
* a singleton instance of the SDK
### `- (void)registerWebView:(UIView*) webView`
Registers `webView` within Taboola JS SDK. It is required to reload/load the page after registering the webview.

Note: When `webView` is no longer needed it must be unregistered using `- (void)unregisterWebView:(UIView*) webView`.
#### **Parameters:**
* `webView` — webview with HTML/JS widget.
> **IMPORTANT**: `webView` must be kind of class `WKWebView` or `UIWebView`.### `- (void)unregisterWebView:(UIView*) webView`  
Unregisters an already registered `webView` from Taboola JS SDK. It is required to reload/load the page after unregistering the webview.
#### **Parameters:**
* `webView` — an already registered webView to unregister.
### `- (void)setExtraPropetries:(NSDictionary*) properties`
Use this method to set specific key-value pairs to adjust TaboolaJS behaviour.
#### **Parameters:**
* `properties` — dictionary with custom parameters for TaboolaJS.
### `@propetry LogLevel logLevel`
* Set log level for the SDK. LogLevel enum defines importance levels. You can find LogLevel enum in the `TaboolaLogger.h` file, for example `LogLevelError`.
* Get  current log level used by SDK.
* Default: `LogLevelError`.
### `- (NSSet*)registeredWebViews`
#### **Returns:**
* `NSSet*` — Set of all currently registered webViews.
### `@propetry id<TaboolaJSDelegate> delegate`
TaboolaJSDelegate is used to intercept recommendation clicks, block default click handling for organic items and get notifications about render success or failure.
# TaboolaJSDelegate
> **NOTE**: All delegate methods are optional.### `- (BOOL)onItemClick:(NSString *)placementName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic`  
Delegate method is called on every touch on the Placement.
#### **Parameters:**
* `placementName` — placement name
* `itemId` —  item identifier
* `clickUrl` — item URL
* `organic` — indicates whether the item clicked was an organic content recommendation or not. Best practice would be to suppress the default behavior for organic items, and instead open the relevant screen in your app which shows that piece of content.
#### **Returns:**
* `BOOL` — Return `false` to abort the default behaviour, the app should display the recommendation content on its own (for example, using an in-app browser).
> **IMPORTANT**: Aborts only for organic items!  
>   
> Return `true` - this will allow the app to implement a click-through and continue to the default behaviour.### `- (void)webView:(UIView*) webView didLoadPlacementNamed:(NSString *) placementName withHeight:(CGFloat)height`  
Delegate method is called on every successful load of Placement.
#### **Parameters:**
* `webView` —  webView which loaded the placement
* `placementName` — placement name
* `withHeight` — widget height
### `- (void)webView:(UIView*) webView didFailToLoadPlacementNamed:(NSString *) placementName withErrorMessage:(NSString *) error`
Delegate method is called on every successful load of Placement.
#### **Parameters:**
* `webView` —  webView which failed to load the placement
* `placementName` — placement name
* `error` — placement name

# WebView Delegates – Default Return values
Since TaboolaJS intervenes into webview’s delegate logic, TaboolaJS implements default implementations for some of methods.
> **NOTE**: All delegate methods are optional. You may implement your own implementation in your class:  
1. Set webView delegate **before** registering the webView in TaboolaJS:
UIWebView:  `webView.delegate = self` 
WKWebView: `webview.navigationDelegate = self`
2. Implement delegate methods according to your needs:
```
// UIWebView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES; // your choice
}

// WKWebView
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow); // your choice
}
```
 
## UIWebViewDelegate
### `- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType`
**Default return value**: `TRUE`
## WKNavigationDelegate
### `- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler`
**Default return value**: `decisionHandler(WKNavigationActionPolicyAllow);`

### `- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler`
**Default return value**: `decisionHandler(WKNavigationResponsePolicyAllow);`

### `- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler`
**Default return value**: `completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);`
