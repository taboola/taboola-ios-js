//
//  TBAppDelegate.m
//  TaboolaDemoApp


#import "TBAppDelegate.h"
#import "TBWebViewJSViewController.h"
#import "TBWKWebViewJSController.h"
#import "TBWKFeedViewJSController.h"

@implementation TBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //load viewcontrollers and tabbar
    TBWebViewJSViewController *lUIWebViewController = [[TBWebViewJSViewController alloc] initWithNibName:@"TBWebViewJSViewController" bundle:nil];
    UITabBarItem *lUITabBarItem = [[UITabBarItem alloc] initWithTitle:@"UIWebView" image:nil tag:0];
    UINavigationController *lUINavController = [[UINavigationController alloc] initWithRootViewController:lUIWebViewController];
    lUINavController.navigationBarHidden = YES;
    lUINavController.tabBarItem = lUITabBarItem;
    
    TBWKWebViewJSController *lWKWebViewController = [[TBWKWebViewJSController alloc]initWithNibName:@"TBWKWebViewJSController" bundle:nil];
    UITabBarItem *lWKTabBarItem = [[UITabBarItem alloc] initWithTitle:@"WKWebView" image:nil tag:1];
    UINavigationController *lWKNavController = [[UINavigationController alloc] initWithRootViewController:lWKWebViewController];
    lWKNavController.navigationBarHidden = YES;
    lWKNavController.tabBarItem = lWKTabBarItem;
    
    TBWKFeedViewJSController *lWKFeedWebViewController = [[TBWKFeedViewJSController alloc]initWithNibName:@"TBWKFeedViewJSController" bundle:nil];
    UITabBarItem *lWKFeedTabBarItem = [[UITabBarItem alloc] initWithTitle:@"WKFeedWebView" image:nil tag:1];
    UINavigationController *lWFeedKNavController = [[UINavigationController alloc] initWithRootViewController:lWKFeedWebViewController];
    lWFeedKNavController.navigationBarHidden = YES;
    lWFeedKNavController.tabBarItem = lWKFeedTabBarItem;
    
    
    
    // Setting Tab bar font, color and v-alignnment
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -5.0)];
  
    UITabBarController *lTabBarController = [[UITabBarController alloc] init];
    lTabBarController.viewControllers = [NSArray arrayWithObjects:lUINavController, lWKNavController, lWFeedKNavController, nil];
    lTabBarController.selectedIndex = 0;
    self.window.rootViewController = lTabBarController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
