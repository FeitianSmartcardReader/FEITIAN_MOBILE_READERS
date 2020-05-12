//
//  MJRefreshAutoNormalFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) . All rights reserved.
//

#import "MJRefreshAutoNormalFooter.h"

@interface MJRefreshAutoNormalFooter()
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@end

@implementation MJRefreshAutoNormalFooter
#pragma mark -
- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    self.loadingView = nil;
    [self setNeedsLayout];
}
#pragma mark -
- (void)prepare
{
    [super prepare];
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count) return;
    
    //
    CGFloat loadingCenterX = self.mj_w * 0.5;
    if (!self.isRefreshingTitleHidden) {
        loadingCenterX -= self.stateLabel.mj_textWith * 0.5 + self.labelLeftInset;
    }
    CGFloat loadingCenterY = self.mj_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.loadingView stopAnimating];
    } else if (state == MJRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
}

@end
