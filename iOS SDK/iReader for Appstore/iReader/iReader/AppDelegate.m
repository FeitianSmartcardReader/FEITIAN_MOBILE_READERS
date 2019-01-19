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
    [self logToFile];
    return YES;
}

-(void)logToFile
{
    NSString * documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *fileName = [NSString stringWithFormat:@"LOG-%@.txt",[dateformat stringFromDate:[NSDate date]]];
    NSString *path = [documentDirectory stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    
    //Output the error to log file, include error message and operation message.
    //This file will stored locally only
    freopen([path cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([path cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

@end
