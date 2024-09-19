//
//  CollectionViewCell.m
//  iReader
//
//  Copyright © 1998-2019, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CollectionViewCell

-(void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

-(void)setImageName:(NSString *)imageName
{
    _imageView.image = [UIImage imageNamed:imageName];
}

@end
