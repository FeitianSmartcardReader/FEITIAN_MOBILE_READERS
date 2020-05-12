//
//  MJRefreshAutoStateFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © . All rights reserved.
//

#import "MJRefreshAutoStateFooter.h"

@interface MJRefreshAutoStateFooter()
{
    /** */
    __unsafe_unretained UILabel *_stateLabel;
}
/** */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation MJRefreshAutoStateFooter
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

#pragma mark -
- (void)stateLabelClick
{
    if (self.state == MJRefreshStateIdle) {
        [self beginRefreshing];
    }
}

#pragma mark -
- (void)prepare
{
    [super prepare];
    
    //
    self.labelLeftInset = MJRefreshLabelLeftInset;
    
    //
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshAutoFooterIdleText] forState:MJRefreshStateIdle];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshAutoFooterRefreshingText] forState:MJRefreshStateRefreshing];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshAutoFooterNoMoreDataText] forState:MJRefreshStateNoMoreData];
    
    //
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
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
    
    if (self.isRefreshingTitleHidden && state == MJRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}
@end
