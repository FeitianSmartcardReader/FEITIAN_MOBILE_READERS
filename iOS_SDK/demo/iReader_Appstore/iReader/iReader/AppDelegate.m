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
    
#ifndef DEBUG
    [[Tools shareTools] logToFile];
#endif
    
    return YES;
}

-(void)switchRootViewController
{
    
    self.window.rootViewController = nil;
    self.window.rootViewController = [[FTNavigationController alloc] initWithRootViewController:[[ScanDeviceController alloc] init]];
}
@end
