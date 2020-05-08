//
//  Tabbar.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarDelegate <NSObject>

-(void)TabBarAddBtnClick;

@end

@interface Tabbar : UITabBar

@property(nonatomic, assign)id<TabBarDelegate> myDelegate;

@end
