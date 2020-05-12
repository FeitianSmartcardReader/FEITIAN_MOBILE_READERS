//
//  ReaderItemView.h
//  iReader
//
//  Created by Jermy on 2018/8/17.
//  Copyright © 2018年 ft. All rights reserved.
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
