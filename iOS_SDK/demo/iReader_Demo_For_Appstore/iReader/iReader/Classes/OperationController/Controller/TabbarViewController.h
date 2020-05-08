//
//  TabbarViewController.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarControllerDelegate <NSObject>

-(void)tabbarButtonClick;

@end

@interface TabbarViewController : UITabBarController
@property (nonatomic, copy)NSString *deviceName;
@property (nonatomic, assign)id<TabBarControllerDelegate> myDelegate;
@end
