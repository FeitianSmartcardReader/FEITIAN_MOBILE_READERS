//
//  ReaderTypeTableViewCell.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "ReaderTypeTableViewCell.h"
#import "ReaderModel.h"

@interface ReaderTypeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *keyTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *keyTypeTitleLabel;

@end

@implementation ReaderTypeTableViewCell

-(void)setReaderModel:(ReaderModel *)readerModel
{
    _readerModel = readerModel;
    
    [self.keyTypeTitleLabel setText:readerModel.title];
    [self.keyTypeImageView setImage:[UIImage imageNamed:readerModel.image]];
}

@end
