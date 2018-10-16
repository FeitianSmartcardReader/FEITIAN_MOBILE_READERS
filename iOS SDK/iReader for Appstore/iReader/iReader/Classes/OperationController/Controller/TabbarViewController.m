//
//  TabbarViewController.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "TabbarViewController.h"
#import "Tabbar.h"

//extern CK_AUX_COMM_HANDLE deviceHandle;

@interface TabbarViewController ()<TabBarDelegate>

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Tabbar *tabbar = [[Tabbar alloc] init];
    tabbar.myDelegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
    
    self.title = _deviceName;
}

-(void)TabBarAddBtnClick
{
    if([self.myDelegate respondsToSelector:@selector(tabbarButtonClick)]){
        [self.myDelegate tabbarButtonClick];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    FT_COMM_CloseDevice(&deviceHandle);
//    FT_COMM_Finalize();
}

@end
