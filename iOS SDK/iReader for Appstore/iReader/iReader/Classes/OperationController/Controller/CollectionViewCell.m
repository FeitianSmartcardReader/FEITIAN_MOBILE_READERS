//
//  CollectionViewCell.m
//  iReader
//
//  Created by Jermy on 2018/6/27.
//  Copyright © 2018年 ft. All rights reserved.
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
