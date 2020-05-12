//
//  MJRefreshAutoGifFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) . All rights reserved.
//

#import "MJRefreshAutoStateFooter.h"

@interface MJRefreshAutoGifFooter : MJRefreshAutoStateFooter
@property (weak, nonatomic, readonly) UIImageView *gifView;

/** */
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state;
@end
