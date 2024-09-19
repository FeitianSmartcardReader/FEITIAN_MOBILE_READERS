//
//  WelcomeController.m
//  iReader
//
//  Copyright © 1998-2019, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "WelcomeController.h"
#import "Tools.h"
#import "ScanDeviceController.h"
#import "AppDelegate.h"
@interface WelcomeController ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (weak, nonatomic) IBOutlet UISwitch *autoConnectSwitch;
@end

@implementation WelcomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _okButton.layer.cornerRadius = _okButton.frame.size.height * 0.5;
    self.navigationController.delegate = self;
}

- (IBAction)switchValueChange:(id)sender {
    
}

- (IBAction)okButtonClick:(id)sender {
    BOOL autoConnect = _autoConnectSwitch.isOn;
    [[NSUserDefaults standardUserDefaults] setValue:@(autoConnect) forKey:autoConnectKey];
    
//    [self.navigationController pushViewController:[[ScanDeviceController alloc] init] animated:YES];
    
     [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL isSelf = [viewController isKindOfClass:[self class]];
    [navigationController setNavigationBarHidden:isSelf animated:YES];
}

@end
