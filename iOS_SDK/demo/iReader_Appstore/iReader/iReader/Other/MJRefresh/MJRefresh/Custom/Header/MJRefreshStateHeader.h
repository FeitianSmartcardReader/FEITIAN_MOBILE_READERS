//
//  MJRefreshStateHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) . All rights reserved.
//

#import "MJRefreshHeader.h"

@interface MJRefreshStateHeader : MJRefreshHeader
#pragma mark -
/**  */
@property (copy, nonatomic) NSString *(^lastUpdatedTimeText)(NSDate *lastUpdatedTime);
/**  */
@property (weak, nonatomic, readonly) UILabel *lastUpdatedTimeLabel;

#pragma mark - 
/** */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/**  */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;
@end
