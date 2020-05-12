//
//  MJRefreshBackStateFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © . All rights reserved.
//

#import "MJRefreshBackStateFooter.h"

@interface MJRefreshBackStateFooter()
{
    /**  */
    __unsafe_unretained UILabel *_stateLabel;
}
/** */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation MJRefreshBackStateFooter
#pragma mark -
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel mj_label]];
    }
    return _stateLabel;
}

#pragma mark -
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (NSString *)titleForState:(MJRefreshState)state {
  return self.stateTitles[@(state)];
}

#pragma mark -
- (void)prepare
{
    [super prepare];
    
    //
    self.labelLeftInset = MJRefreshLabelLeftInset;
    
    //
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshBackFooterIdleText] forState:MJRefreshStateIdle];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshBackFooterPullingText] forState:MJRefreshStatePulling];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshBackFooterRefreshingText] forState:MJRefreshStateRefreshing];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshBackFooterNoMoreDataText] forState:MJRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    //
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 
    self.stateLabel.text = self.stateTitles[@(state)];
}
@end
