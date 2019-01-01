# Taboola JS widgets in iOS WebViews (TaboolaJS)
![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)
[![Version](https://img.shields.io/cocoapods/v/TaboolaSDK.svg?label=Version)](https://github.com/taboola/taboola-ios-api)
[![License](https://img.shields.io/badge/License%20-Taboola%20SDK%20License-blue.svg)](https://github.com/taboola/taboola-ios/blob/master/LICENSE)

## Table Of Contents
1. [Getting Started](#1-getting-started)
2. [Migrating from Taboola plain JS integration](#2-migrating-from-taboola-plain-js-integration)
3. [Example Apps](#3-example-apps)
4. [SDK Reference](#4-sdk-reference)
5. [GDPR](#5-gdpr)
6. [License](#6-license)

## 1. Getting Started

`TaboolaJS` SDK integration allows app developers to show Taboola widgets within their own webviews side-to-side with other content from the app.

If you already have a Taboola plain JS widget implemented, you can easily migrate the TaboolaJS and gain the full benefits of using the SDK. The changes required are minimal. Please refer to section 2 [Migrating from Taboola plain JS integration](#2-migrating-from-taboola-plain-js-integration) for more details about how to migrate.

If you are implementing a new Taboola integration in your app, `TaboolaJS` should be fast and easy to implement, and will give you the benefits of both HTML/JS and native.

### 1.1. Minimum requirements

* Build against Base SDK `7.0` or later. Deployment target: iOS `7.0` or later.
* Use `Xcode 8` or later.

### 1.2. Incorporating the SDK
#### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like Taboola in your projects.

You can install it with the following command:

```bash
$ gem install cocoapods
```

##### Podfile

To integrate Taboola into your Xcode project using CocoaPods, specify it in your `Podfile`:

* Objective-C

   ```
   pod 'TaboolaSDK'
   ```

* Swift

   ```
   use_frameworks!
   pod 'TaboolaSDK', '2.1.0'
   ```

Then, run the following command:

```bash
$ pod install
```

#### Installation with Carthage
**[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks thus requires deployment target of minimum iOS 8.0**

1. You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

2. To integrate Taboola into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
binary "https://cdn.taboola.com/taboola-mobile-sdk/ios/carthage/Carthage.json" == 2.1.0
```

3. Run `carthage update` to build the framework and drag the built `TaboolaFramework.framework` into your Xcode project.

4. On your application targets’ Build Phases settings tab, click the + icon and choose New Run Script Phase. Create a Run Script in which you specify your shell (ex: /bin/sh), add the following contents to the script area below the shell:

```ogdl
/usr/local/bin/carthage copy-frameworks
```

Add the paths to the frameworks you want to use under “Input Files". For example:

```ogdl
$(SRCROOT)/Carthage/Build/iOS/TaboolaFramework.framework
```
Add the paths to the copied frameworks to the “Output Files”. For example:

```ogdl
$(BUILT_PRODUCTS_DIR)/$(FRAMEWORKS_FOLDER_PATH)/TaboolaFramework.framework
```

### 1.3. Register/Unregister WebViews

Before loading the actual content in your webview, you should register any webview that's intented to show Taboola widgets. `TaboolaJS` supports both `WKWebView` and `UIWebView`.

Webviews should be registered before their content is actually loaded. If you register after loading, a refresh of the webview is required.

Make sure to unregister your webview before it's destroyed.

in your `ViewController` code:

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Optional but important for video!
    // To show video ads please add this code
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config setAllowsInlineMediaPlayback:YES];
    [config.preferences setJavaScriptCanOpenWindowsAutomatically:YES];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];

   // webView must be registered before page is (re)loaded
   // implement and set TaboolaJSDelegate to receive events (optional)
   
   ** From version 2.0.30 use:
   [[TaboolaJS sharedInstance] registerWebView:self.webView withDelegate:self];
   
   ** Before 2.0.30 use:
    [[TaboolaJS sharedInstance] registerWebView:self.webView];
    [TaboolaJS sharedInstance].delegate = self;
}

// unregister the webview when you don't need it anymore
// add this in the appropriate place in your app
// [[TaboolaJS sharedInstance] unregisterWebView:self.webView];

```


### 1.4. Intercepting recommendation clicks

`TaboolaJS`, by default, will try to open clicks in `SFSafariViewController`.
On older iOS versions, where `SFSafariViewController` is not supported, the clicks will be opened in an in-app browser window or in the Safari app.

`TaboolaJS` allows app developers to intercept recommendation clicks in order to create a click-through or to override the default way of opening the recommended article. For example, for opening organic items as a deeplink into the relevant app screen instead of showing it as a web page.

In order to intercept clicks, you should implement the `TaboolaJSDelegate` and set it in the `TaboolaJS` object.

For example, you may choose to implement `TaboolaJSDelegate` in your view controller

```
@interface MyViewController () <TaboolaJSDelegate>
.
.
.
@implementation MyViewController
.
.
.
#pragma mark - TaboolaJSDelegate

- (BOOL)onItemClick:(NSString *)placementName withItemId:(NSString *)itemId withClickUrl:(NSString *)clickUrl isOrganic:(BOOL)organic {

    // implement click handling code here
    return YES;
}

```

Set the delegate correctly on the `TaboolaJS` SharedInstance:

```
[TaboolaJS sharedInstance].delegate = self;
```

The `onItemClick` method will be called every time a user clicks a recommendation, right before triggering the default behavior. You can block default click handling for organic items by returning `NO`.

* Return **`NO`** - abort the default behavior, the app should display the recommendation content on its own (for example, using an in-app browser). **NOTICE: Aborts only for organic items!**
* Return **`YES`** - this will allow the app to implement a click-through and continue to the default behaviour.

`isOrganic` indicates whether the item clicked was an organic content recommendation or not.

**Best practice would be to suppress the default behavior for organic items, and instead open the relevant screen in your app which shows that content.**

### 1.5. Receiving load/failure events for widgets

App developers may choose to implement the `TaboolaJSDelegate` optional methods `didLoadPlacementNamed` and `didFailToLoadPlacementNamed` in order to receieve notification when a widget has loaded or failed to load.

Implement these methods in the same object which handles the clicks and implements  `TaboolaJSDelegate`

```
- (void)webView:(WebView) webView didLoadPlacementNamed:(NSString*) placementName withHeight:(CGFloat)height;
- (void)webView:(WebView) webView didFailToLoadPlacementNamed:(NSString*) placementName withErrorMessage:(NSString*) error;

```


### 1.6. Adding HTML/JS widget within the webview
Your HTML page loaded inside the webview should contain the Taboola mobile JS code in order to bind with the `TaboolaJS` native SDK and actually show the widget.

If you are already familiar with the Taboola web JS code, notice that although the Taboola mobile JS code is mostly identical to the Taboola web JS code, there are a few minor modifications that should be made.

Place this code in the `<head>` tag of any HTML page on which you’d like the Taboola widget to appear (You can place it also in the `<body>`):

```javascript
<script type="text/javascript">
     window._taboola = window._taboola || [];
     _taboola.push({page-type:'auto', url:'pass-url-here'});
     !function (e, f, u, i) {
          if (!document.getElementById(i)){
               e.async = 1;
               e.src = u;
               e.id = i;
               f.parentNode.insertBefore(e, f);
          }
     }(document.createElement('script'),document.getElementsByTagName('script')[0],'//cdn.taboola.com/libtrc/publisher-id/mobile-loader.js','tb_mobile_loader_script');
</script>
```

**'page-type'**: pass the internal app representation of the page as received from Taboola account manager.

**'pass-url-here'**: pass the canonical url (web representation) of the app page - this is needed for us to crawl the page to get contextual and meta data

**'publisher-id'**: replace it with the publisher ID received from your Taboola account manager.

Place this code where you want the widget to appear:

```html
<div id="container-id"></div>
<script type="text/javascript">
     window._taboola = window._taboola || [];
     _taboola.push({mode: 'mode-name',
     	container: 'container-id',
     	placement: 'Placement Name',
     	target_type: 'mix'});

 // Notice - this part is unique to mobile SDK JS integrations!
_taboola["mobile"] = window._taboola["mobile"] || [];
_taboola["mobile"].push({
        taboola_view_id:'view id',
        publisher:'publisher-id-goes-here'
});
</script>
```
**'container-id'**: use any id for the actual widget container element

**'mode-name'**: replace it with the mode parameter received from your Taboola account manager

**'Placement Name'**: use the placement name received from your Taboola account manager

**"view id"**: (optional) set view id in order to prevent duplicated between different placements (can use:'new Date().getTime()' )

**"publisher-id-goes-here"**: replace it with the publisher ID received from your Taboola account manager.

Do not forget to register your webview with the native `TaboolaJS`object!

## 2. Migrating from Taboola plain JS integration
If you are app already has a webview which contains the Taboola web JS code in it, you can easily migrate with `TaboolaJS` with a few simple steps:

### 2.1. Javascript changes
* In your page `<head>` section, change the path of taboola `loader.js` to `mobile-loader.js`
* Add this to your script right before push the configuration to `_taboola` (replace **'publisher-id-goes-here'** with your actual publisher id)

```javascript
_taboola["mobile"] = window._taboola["mobile"] || [];
_taboola["mobile"].push({
   publisher:"publisher-id-goes-here"
});
```

### 2.2. Native code changes
Follow the instructions on steps 1.1 to 1.6 to configure `TaboolaJS` native side within your app.


## 3. Example App
This repository includes an example iOS app which uses the `TaboolaJS`. Review it and see how `TaboolaJS` is integrated in practice.

## 4. SDK Reference
[TaboolaJS Reference](./doc/Taboola%20JS%20SDK%20iOS%20Reference.md)

## 5. GDPR
In order to support the The EU General Data Protection Regulation (GDPR - https://www.eugdpr.org/) in Taboola Mobile SDK, application developer should show a pop up asking the user's permission for storing their personal data in the App. In order to control the user's personal data (to store in the App or not) there exists a flag `User_opt_out`. It's mandatory to set this flag when using the Taboola SDK. The way to set this flag depends on the type of SDK you are using. By default we assume no permission from the user on a pop up, so the personal data will not be saved.

### 5.1. How to set the flag in the SDK integration
Below you can find the way how to set the flag on SDK JS we support. It's recommended to put these lines alongside the other settings, such as publisher name, etc

In the head you will need to add:
```javascript
<script type="text/javascript">
     window._taboola = window._taboola || [];
     _taboola.push({page-type:'auto', url:'pass-url-here',user_opt_out: 'true'});
     !function (e, f, u, i) {
          if (!document.getElementById(i)){
               e.async = 1;
               e.src = u;
               e.id = i;
               f.parentNode.insertBefore(e, f);
          }
     }(document.createElement('script'),document.getElementsByTagName('script')[0],'//cdn.taboola.com/libtrc/publisher-id/mobile-loader.js','tb_mobile_loader_script');
</script>
```
## 6. License
This program is licensed under the Taboola, Inc. SDK License Agreement (the “License Agreement”).  By copying, using or redistributing this program, you agree to the terms of the License Agreement.  The full text of the license agreement can be found at [https://github.com/taboola/taboola-ios/blob/master/LICENSE](https://github.com/taboola/taboola-ios/blob/master/LICENSE).
Copyright 2017 Taboola, Inc.  All rights reserved.
