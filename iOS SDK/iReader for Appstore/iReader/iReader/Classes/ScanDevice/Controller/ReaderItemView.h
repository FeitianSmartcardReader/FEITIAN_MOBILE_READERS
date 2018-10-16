//
//  ReaderItemView.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReaderItemViewDelegate<NSObject>

-(void)didSelecteItem:(NSString *)name;

@end

@interface ReaderItemView : UIView

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, weak) id<ReaderItemViewDelegate> delegate;

- (instancetype)initReaderItemWithName:(NSString *)name type:(NSInteger)type frame:(CGRect)frame;

@end
