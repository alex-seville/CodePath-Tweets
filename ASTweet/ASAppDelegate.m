//
//  ASAppDelegate.m
//  ASTweet
//
//  Created by Alexander Seville on 3/26/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASTimelineViewController.h"
#import "ASTwitterAPI.h"
#import "ASUser.h"

@implementation ASAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    /* now do the app start up stuff */
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    /* temp */
    /*
     NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
     */
    /* remove */
    
    if (![ASUser currentUser]){
        /* check if we have a current user, if not login */
        ASTwitterAPI *apiClient = [ASTwitterAPI instance];
    
        [apiClient login];
    }else{
    
        [self showTimelineTable];
    }
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor colorWithRed:136 green:211 blue:253 alpha:1.0 ];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[ASTwitterAPI instance] processAuthResponseURL:url onSuccess:^{
        
        ASTwitterAPI *apiClient = [ASTwitterAPI instance];

        
        [apiClient getWithEndpointType:ASTwitterAPIEndpointUser success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(showTimelineTable)
                                                         name:UserLoggedInNotification object:nil];
            
            [[[ASUser alloc] initWithDictionary:responseObject] setAsCurrentUser];
                        
            
            
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure: %@", error);
        }];
        
        
    }];
}

- (void) showTimelineTable {
    ASTimelineViewController *timelineViewController = [[ASTimelineViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:timelineViewController];
    
    
    
    [nav.navigationBar setBarTintColor:timelineViewController.view.backgroundColor];
    [nav.navigationBar setTranslucent:NO];
    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    timelineViewController.title = @"Tweet!";
    
    
    self.window.rootViewController = nav;
    
    
}

@end
