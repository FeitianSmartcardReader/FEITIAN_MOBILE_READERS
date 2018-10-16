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
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[WelcomeController alloc] init]];
    }else {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ScanDeviceController alloc] init]];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:welcomeKey];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
