//
//  FTNavigationController.m
//  iReader
//
//  Created by 张旭峰 on 2020/3/23.
//  Copyright © 2020 ft. All rights reserved.
//

#import "FTNavigationController.h"
#import "OperationViewController.h"
#import "DeviceInfoTableViewController.h"
#import "ScanDeviceController.h"
@interface FTNavigationController ()
@property(nonatomic,weak) id popDelegate;
@end

@implementation FTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak FTNavigationController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
        self.delegate = weakSelf;
    }
    
    self.popDelegate =self.interactivePopGestureRecognizer.delegate;
    
}


#pragma mark UINavigationControllerDelegate



-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] )
        {
            return NO;
        }
        
        UIViewController *vc = self.viewControllers.lastObject;
                 //  禁用某些不支持侧滑返回的页面
            if ([vc isKindOfClass:[OperationViewController class]] || [vc isKindOfClass:[ScanDeviceController class]]) {
                      return NO;
            }
    }
    
    return YES;
}



- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    
    
    [super pushViewController:viewController animated:animated];
}



- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isSelf = [viewController isKindOfClass:[DeviceInfoTableViewController class]];
    if(isSelf)
    {
        [self setNavigationBarHidden:NO animated:YES];
        
    }else
    {
        [self setNavigationBarHidden:YES animated:YES];
    }
    
    
}



@end
