//
//  HelpVisualEffectView.m
//  iReader
//
//  Copyright © 1998-2019, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "HelpVisualEffectView.h"
#import "Tools.h"

@implementation HelpVisualEffectView
{
    UILabel *_titleLabel;
    UIImageView *_separateLine;
    
    UIImageView *_iR301ImageView;
    UILabel *_iR301TitleLabel;
    UILabel *_iR301DetailLabel;
    
    UIImageView *_bR301ImageView;
    UILabel *_bR301TitleLabel;
    UILabel *_bR301DetailLabel;
    
    UIImageView *_bR500ImageView;
    UIImageView *_bR301BLEImageView;
    UILabel *_bR500TitleLabel;
    UILabel *_bR500DetailLabel;
    
    UILabel *_infoLabel;
    
    UIButton *_okButton;
}


- (instancetype)initWithEffect:(UIVisualEffect *)effect
{
    self = [super initWithEffect:effect];
    [self display];
    return self;
}

//iR301:Please plug in your iR301 Smart Card Reader to this device

//bR301:Please pair with your iOS before using iReader APP

//bR301BLE/bR500:Please turn on bluetooth on this device, then power up your bR301BLE/bR500 Smart Card Reader,iReader APP will connect to thes nearest reader automatically.

//The iReader App only support one reader at same time.

- (void)display
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"Get Connected";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont boldSystemFontOfSize:30];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLabel];
    
    _separateLine = [[UIImageView alloc] init];
    _separateLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_separateLine];
    
    //iR301 info
    _iR301ImageView = [[UIImageView alloc] init];
    _iR301ImageView.image = [UIImage imageNamed:@"iR301-CardDefault"];
    _iR301ImageView.layer.cornerRadius = 20;
    [self.contentView addSubview:_iR301ImageView];
    
    _iR301TitleLabel = [[UILabel alloc] init];
    _iR301TitleLabel.text = @"iR301";
    _iR301TitleLabel.font = [UIFont boldSystemFontOfSize:15];
    _iR301TitleLabel.textColor = [UIColor whiteColor];
    _iR301TitleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_iR301TitleLabel];
    
    _iR301DetailLabel = [[UILabel alloc] init];
    _iR301DetailLabel.text = @"Please plug in your iR301 Smart Card Reader to this device.";
    _iR301DetailLabel.numberOfLines = 0;
    _iR301DetailLabel.font = [UIFont systemFontOfSize:12];
    _iR301DetailLabel.textColor = [UIColor whiteColor];
    _iR301DetailLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_iR301DetailLabel];
    
    //bR301 info
    _bR301ImageView = [[UIImageView alloc] init];
    _bR301ImageView.image = [UIImage imageNamed:@"bR301-CardDefault"];
    [self.contentView addSubview:_bR301ImageView];
    
    _bR301TitleLabel = [[UILabel alloc] init];
    _bR301TitleLabel.text = @"bR301";
    _bR301TitleLabel.font = [UIFont boldSystemFontOfSize:15];
    _bR301TitleLabel.textColor = [UIColor whiteColor];
    _bR301TitleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bR301TitleLabel];
    
    _bR301DetailLabel = [[UILabel alloc] init];
    _bR301DetailLabel.text = @"Please pair with your iOS before using iReader APP.";
    _bR301DetailLabel.numberOfLines = 0;
    _bR301DetailLabel.font = [UIFont systemFontOfSize:12];
    _bR301DetailLabel.textColor = [UIColor whiteColor];
    _bR301DetailLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bR301DetailLabel];
    
    
    //bR30lBLE bR500 info
    _bR500ImageView = [[UIImageView alloc] init];
    _bR500ImageView.image = [UIImage imageNamed:@"bR500-CardDefault"];
    [self.contentView addSubview:_bR500ImageView];
    
    _bR301BLEImageView = [[UIImageView alloc] init];
    _bR301BLEImageView.image = [UIImage imageNamed:@"bR301BLE-CardDefault"];
    [self.contentView addSubview:_bR301BLEImageView];
    
    _bR500TitleLabel = [[UILabel alloc] init];
    _bR500TitleLabel.text = @"bR301BLE/bR500";
    _bR500TitleLabel.font = [UIFont boldSystemFontOfSize:15];
    _bR500TitleLabel.textColor = [UIColor whiteColor];
    _bR500TitleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bR500TitleLabel];
    
    _bR500DetailLabel = [[UILabel alloc] init];
    _bR500DetailLabel.text = @"Please turn on bluetooth on this device, then power up your bR301BLE/bR500 Smart Card Reader,iReader APP will connect to thes nearest reader automatically.";
    _bR500DetailLabel.numberOfLines = 0;
    _bR500DetailLabel.font = [UIFont systemFontOfSize:12];
    _bR500DetailLabel.textColor = [UIColor whiteColor];
    _bR500DetailLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_bR500DetailLabel];
    
    
    //info label
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.text = @"The iReader App only support one reader using simultaneously.";
    _infoLabel.numberOfLines = 0;
    _infoLabel.font = [UIFont systemFontOfSize:12];
    _infoLabel.textColor = [UIColor whiteColor];
    _infoLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_infoLabel];
    
    //ok button
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.backgroundColor = [UIColor whiteColor];
    _okButton.layer.cornerRadius = 5;
    [_okButton setTitle:@"OK" forState:UIControlStateNormal];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_okButton setBackgroundColor:[UIColor clearColor]];
   _okButton.titleLabel.font = [UIFont boldSystemFontOfSize:25];
    [_okButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_okButton];
}

-(void)layoutSubviews
{
    NSInteger titleLabelX = 0;
    NSInteger titleLabelY = 60;
    NSInteger titleLabelW = screenW;
    NSInteger titleLabelH = 40;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    
    NSInteger separateLineW = 200;
    NSInteger separateLineH = 1;
    NSInteger separateLineX = (screenW - separateLineW) * 0.5;
    NSInteger separateLineY = titleLabelY + titleLabelH + 10;
    _separateLine.frame = CGRectMake(separateLineX, separateLineY, separateLineW, separateLineH);
    
    NSInteger imageViewW = 40;
    NSInteger margin = 20;
    
    //iR301 info
    
    NSInteger iR301ImageViewW = imageViewW;
    NSInteger iR301ImageViewH = imageViewW;
    NSInteger iR301ImageViewX = margin;
    NSInteger iR301ImageViewY = separateLineY + 50;
    _iR301ImageView.frame = CGRectMake(iR301ImageViewX, iR301ImageViewY, iR301ImageViewW, iR301ImageViewH);
    
    NSInteger iR301TitleLabelX = CGRectGetMaxX(_iR301ImageView.frame) + margin;
    NSInteger iR301TitleLabelY = iR301ImageViewY;
    NSInteger iR301TitleLabelW = screenW - iR301TitleLabelX - margin;
    NSInteger iR301TitleLabelH = 20;
    _iR301TitleLabel.frame = CGRectMake(iR301TitleLabelX, iR301TitleLabelY, iR301TitleLabelW, iR301TitleLabelH);
    
    NSInteger iR301DtailLabelX = iR301TitleLabelX;
    NSInteger iR301DtailLabelY = iR301TitleLabelY + iR301TitleLabelH;
    NSInteger iR301DtailLabelW = iR301TitleLabelW;
    NSInteger iR301DtailLabelH = 40;
    _iR301DetailLabel.frame = CGRectMake(iR301DtailLabelX, iR301DtailLabelY, iR301DtailLabelW, iR301DtailLabelH);
    
    
    //bR301info

    NSInteger bR301ImageViewW = imageViewW;
    NSInteger bR301ImageViewH = imageViewW;
    NSInteger bR301ImageViewX = margin;
    NSInteger bR301ImageViewY = iR301DtailLabelY + 60;
    _bR301ImageView.frame = CGRectMake(bR301ImageViewX, bR301ImageViewY, bR301ImageViewW, bR301ImageViewH);
    
    NSInteger bR301TitleLabelX = CGRectGetMaxX(_bR301ImageView.frame) + margin;
    NSInteger bR301TitleLabelY = bR301ImageViewY;
    NSInteger bR301TitleLabelW = screenW - bR301TitleLabelX - margin;
    NSInteger bR301TitleLabelH = 20;
    _bR301TitleLabel.frame = CGRectMake(bR301TitleLabelX, bR301TitleLabelY, bR301TitleLabelW, bR301TitleLabelH);
    
    NSInteger bR301DtailLabelX = bR301TitleLabelX;
    NSInteger bR301DtailLabelY = bR301TitleLabelY + bR301TitleLabelH;
    NSInteger bR301DtailLabelW = bR301TitleLabelW;
    NSInteger bR301DtailLabelH = 40;
    _bR301DetailLabel.frame = CGRectMake(bR301DtailLabelX, bR301DtailLabelY, bR301DtailLabelW, bR301DtailLabelH);
    
    
    //bR301BLE bR500 info
    
    NSInteger bR301BLEImageViewW = imageViewW;
    NSInteger bR301BLEImageViewH = imageViewW;
    NSInteger bR301BLEImageViewX = margin;
    NSInteger bR301BLEImageViewY = bR301DtailLabelY + 60;
    _bR301BLEImageView.frame = CGRectMake(bR301BLEImageViewX, bR301BLEImageViewY, bR301BLEImageViewW, bR301BLEImageViewH);
    
    NSInteger bR500ImageViewW = imageViewW;
    NSInteger bR500ImageViewH = imageViewW;
    NSInteger bR500ImageViewX = margin;
    NSInteger bR500ImageViewY = bR301BLEImageViewY + bR500ImageViewH + 10;
    _bR500ImageView.frame = CGRectMake(bR500ImageViewX, bR500ImageViewY, bR500ImageViewW, bR500ImageViewH);
    
    NSInteger bR500TitleLabelX = CGRectGetMaxX(_bR301ImageView.frame) + margin;
    NSInteger bR500TitleLabelY = bR301BLEImageViewY;
    NSInteger bR500TitleLabelW = screenW - bR500TitleLabelX - margin;
    NSInteger bR500TitleLabelH = 20;
    _bR500TitleLabel.frame = CGRectMake(bR500TitleLabelX, bR500TitleLabelY, bR500TitleLabelW, bR500TitleLabelH);
    
    NSInteger bR500DtailLabelX = bR500TitleLabelX;
    NSInteger bR500DtailLabelY = bR500TitleLabelY + bR500TitleLabelH;
    NSInteger bR500DtailLabelW = bR500TitleLabelW;
    NSInteger bR500DtailLabelH = 80;
    _bR500DetailLabel.frame = CGRectMake(bR500DtailLabelX, bR500DtailLabelY, bR500DtailLabelW, bR500DtailLabelH);
    
    
    //info label
    NSInteger infoLabelX = bR301BLEImageViewX;
    NSInteger infoLabelY = CGRectGetMaxY(_bR500DetailLabel.frame) + 20;
    NSInteger infoLabelW = screenW  - margin;
    NSInteger infoLabelH = 40;
    _infoLabel.frame = CGRectMake(infoLabelX, infoLabelY, infoLabelW, infoLabelH);
    

    //ok button
    NSInteger buttonW = 100;
    NSInteger buttonH = 40;
    NSInteger buttonX = (screenW - buttonW) * 0.5;
    NSInteger buttonY = screenH - 20 - buttonH;
    _okButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
}

-(void) back
{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, screenH, screenW, screenH);
    } completion:^(BOOL finished) {

    }];
}
@end
