//
//  OperationViewController.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperationViewController : UIViewController
@property (nonatomic, copy)NSString *readerName;
@property (weak, nonatomic) IBOutlet UIButton *powerOnBtn;

@property (weak, nonatomic) IBOutlet UIButton *powerOffBtn;

@property (nonatomic, strong) NSArray *gslotArray;
//@property (nonatomic, strong) UIViewController *rootVC;
@end
