//
//  MJRefreshBackStateFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © . All rights reserved.
//

#import "MJRefreshBackFooter.h"

@interface MJRefreshBackStateFooter : MJRefreshBackFooter
/** */
@property (assign, nonatomic) CGFloat labelLeftInset;
/**  */
@property (weak, nonatomic, readonly) UILabel *stateLabel;
/**  */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;

/**  */
- (NSString *)titleForState:(MJRefreshState)state;
@end
