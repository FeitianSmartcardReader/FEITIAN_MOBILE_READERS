//
//  ViewController.m
//  iReader
//
//  Copyright © 1998-2019, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "view.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIView *coverView;
    CGFloat originalX;
    CADisplayLink *link;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 40);
//    label.numberOfLines = 0;
//    label.backgroundColor = [UIColor grayColor];
//    label.text = @"please power on your reader to connect...";
//    label.font = [UIFont systemFontOfSize:13];
//    [self.view addSubview:label];
//
//    coverView = [UIView new];
//    originalX = 20;
//    coverView.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 40);
//    coverView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:coverView];
//
//    link = [CADisplayLink displayLinkWithTarget:self selector:@selector(viewMove)];
//    link.frameInterval = 3;
//    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    view *layer = [[view alloc] init];
    layer.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 40);
    layer.backgroundColor = [UIColor grayColor];
    [self.view addSubview:layer];
}

-(void)viewMove
{
    originalX += 1;
    
    if (originalX > [UIScreen mainScreen].bounds.size.width) {
        [link invalidate];
    }
    coverView.frame = CGRectMake(originalX, 100, [UIScreen mainScreen].bounds.size.width - 40, 40);
    
}
@end
