//
//  ASAppDelegate.m
//  ASTweet
//
//  Created by Alexander Seville on 3/26/14.
//  Copyright (c) 2014 Alexander Seville. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASMainViewController.h"
#import "ASTimelineViewController.h"
#import "ASTwitterAPI.h"
#import "ASUser.h"

@implementation ASAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    /* uncomment to expire token */
    /*
     NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    */
    /* remove */
    
    
    /* check if we have a current user, if not login */
    if (![ASUser currentUser]){
        
        ASTwitterAPI *apiClient = [ASTwitterAPI instance];
    
        [apiClient login];
    }else{
    
        [self showTimelineTable];
    }
    
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

        /* get user */
        [apiClient getWithEndpointType:ASTwitterAPIEndpointUser success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(showTimelineTable)
                                                         name:UserLoggedInNotification object:nil];
            NSLog(@"Response: %@", responseObject);
            [[[ASUser alloc] initWithDictionary:responseObject] setAsCurrentUser];
                        
            
            
        } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Failure: %@", error);
        }];
        
        
    }];
}

- (void) showTimelineTable {
    ASMainViewController *mainViewController = [[ASMainViewController alloc] init];
    ASTimelineViewController *tvc = [[ASTimelineViewController alloc] init];
    tvc.timelineType = ASTwitterAPIEndpointTimeline;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    
    self.window.backgroundColor = tvc.view.backgroundColor;
    /* add the tweet colors to things */
    [nav.navigationBar setBarTintColor:tvc.view.backgroundColor];
    [nav.navigationBar setTranslucent:NO];
    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    mainViewController.title = @"Tweet!";
    
         
    self.window.rootViewController = nav;
    
    
}



@end
