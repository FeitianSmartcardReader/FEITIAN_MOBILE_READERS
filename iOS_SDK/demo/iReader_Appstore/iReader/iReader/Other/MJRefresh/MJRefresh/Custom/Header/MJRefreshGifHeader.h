//
//  MJRefreshGifHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) . All rights reserved.
//

#import "MJRefreshStateHeader.h"

@interface MJRefreshGifHeader : MJRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *gifView;

/** */
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;
@end
