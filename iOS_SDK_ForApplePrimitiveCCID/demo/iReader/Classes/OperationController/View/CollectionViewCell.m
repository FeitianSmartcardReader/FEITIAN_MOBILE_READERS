//
//  CollectionViewCell.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "CollectionViewCell.h"
#import "commandModel.h"

@interface CollectionViewCell()

@end

@implementation CollectionViewCell

-(void)setModel:(commandModel *)model
{
    _model = model;

    [self.commandTitle setText:model.commandName];

    UIImage *image = [UIImage imageNamed:model.commandImage];

    [self.commandImage setImage:image];
}

@end
