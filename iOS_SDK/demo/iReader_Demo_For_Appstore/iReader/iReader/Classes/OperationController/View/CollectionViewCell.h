//
//  CollectionViewCell.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class commandModel;

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *commandImage;
@property (weak, nonatomic) IBOutlet UILabel *commandTitle;
@property (nonatomic, strong)commandModel *model;

@end
