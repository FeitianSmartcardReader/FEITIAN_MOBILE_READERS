//
//  DeviceCollectionViewCell.m
//  iReader
//
//  Copyright © 1998-2019, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "DeviceCollectionViewCell.h"
@interface DeviceCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *DeviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;

@end
@implementation DeviceCollectionViewCell

-(void)setDeviceName:(NSString *)deviceName
{
    self.deviceLabel.text = deviceName;
    
}

-(void)setDeviceImage:(NSString *)deviceImage
{
    self.DeviceImageView.image = [UIImage imageNamed:deviceImage];
}

@end
