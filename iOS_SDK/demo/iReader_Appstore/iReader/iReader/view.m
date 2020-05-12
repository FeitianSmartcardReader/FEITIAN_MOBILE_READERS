//
//  view.m
//  iReader
//
//  Copyright © 1998-2019, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "view.h"

@implementation view
{
    NSDictionary *dic;
    NSString *str;
    NSInteger index;
    CADisplayLink *link;
}

- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
    
//    UIGraphicsGetCurrentContext();
    
    link = [CADisplayLink displayLinkWithTarget:self selector:@selector(show)];
    link.frameInterval = 5;
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
//    [@"ffffff" drawInRect:CGRectMake(0, 0, 100, 100) withAttributes:dic];
    dic = @{
                          NSForegroundColorAttributeName : [UIColor redColor],
                          NSFontAttributeName : [UIFont systemFontOfSize:15]
                          };
    str = @"pelase power on your reader to connect...";
    index = 0;
    
}

-(void)show
{
    index ++;
    
    if (index >= str.length) {
        [link invalidate];
    }
    
    NSString *subStr = [str substringWithRange:NSMakeRange(0, index)];
    [subStr drawAtPoint:CGPointMake(0, 0) withAttributes:dic];
    
}

@end
