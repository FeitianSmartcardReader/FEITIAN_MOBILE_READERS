//
//  Button.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "Button.h"

@implementation Button

-(void)layoutSubviews
{
    [super layoutSubviews];
  
    CGFloat imageW = self.imageView.frame.size.width;
    CGFloat imageH = self.imageView.frame.size.height;
    CGFloat imageX = (self.frame.size.width - imageW) * 0.5;
    CGFloat imageY = -6;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);

    CGFloat labelW = self.frame.size.width;
    CGFloat labelH = 10;
    CGFloat labelX = 0;
    CGFloat labelY = imageH - 10;
    self.titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
}
@end
