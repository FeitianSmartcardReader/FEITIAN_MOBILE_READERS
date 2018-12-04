//
//  ReaderItemView.m
//  iReader
//
//  Created by Jermy on 2018/8/17.
//  Copyright © 2018年 ft. All rights reserved.
//

#import "ReaderItemView.h"

@implementation ReaderItemView
{
    UIImageView *_imageView;
    UILabel *_label;
}

- (instancetype)initReaderItemWithName:(NSString *)name type:(NSInteger)type frame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _name = name;
        _type = type;
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"readerItem"];
    _imageView = imageView;
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = _name;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    _label = label;
    [self addSubview:label];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat imageW = width * 0.8;
    CGFloat imageH = imageW;
    CGFloat imageX = (width - imageW) * 0.5;
    CGFloat imageY = 0;
    
    _imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat labelX = 0;
    CGFloat labelY = CGRectGetMaxY(_imageView.frame);
    CGFloat labelW = width;
    CGFloat labelH = height = imageH;
    
    _label.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(didSelecteItem:)]) {
        [self.delegate didSelecteItem:_name];
    }
}

@end
