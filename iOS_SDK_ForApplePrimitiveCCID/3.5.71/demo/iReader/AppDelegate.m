//
//  AppDelegate.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeController.h"
#import "ScanDeviceController.h"
#import "Tools.h"
#import "FTNavigationController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //when first boot app, show the welcome view
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:welcomeKey];
    if (value == nil) {
        self.window.rootViewController = [[FTNavigationController alloc] initWithRootViewController:[[WelcomeController alloc] init]];
    }else {
        self.window.rootViewController = [[FTNavigationController alloc] initWithRootViewController:[[ScanDeviceController alloc] init]];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:welcomeKey];
    
    [self.window makeKeyAndVisible];
    
//#ifndef DEBUG
//    [[Tools shareTools] logToFile];
//#endif
    
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application {
   // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   NSLog(@"App will enter background");
   
}

#pragma mark - 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
   // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
   // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"App did enter background");
//    SCardReleaseContext(gContxtHandle);
//    gContxtHandle = 0;
   
}

#pragma mark - 程序将要进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
   // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"App will become active");
   
}

#pragma mark - 程序进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application {
   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"app did become active");
   
}


-(void)switchRootViewController
{
    
    self.window.rootViewController = nil;
    self.window.rootViewController = [[FTNavigationController alloc] initWithRootViewController:[[ScanDeviceController alloc] init]];
}
@end
