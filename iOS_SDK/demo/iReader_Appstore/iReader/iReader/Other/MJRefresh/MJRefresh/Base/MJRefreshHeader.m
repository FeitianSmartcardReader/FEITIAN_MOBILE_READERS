//  : https://github.com/CoderMJLee/MJRefresh
//  : http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) . All rights reserved.
//

#import "MJRefreshHeader.h"

@interface MJRefreshHeader()
@property (assign, nonatomic) CGFloat insetTDelta;
@end

@implementation MJRefreshHeader
#pragma mark -
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    MJRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshHeader *cmp = [[self alloc] init];
    [cmp setRefreshingTarget:target refreshingAction:action];
    return cmp;
}

#pragma mark -
- (void)prepare
{
    [super prepare];
    
    //
    self.lastUpdatedTimeKey = MJRefreshHeaderLastUpdatedTimeKey;
    
    //
    self.mj_h = MJRefreshHeaderHeight;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    //
    self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    //
    if (self.state == MJRefreshStateRefreshing) {
        if (self.window == nil) return;
        
        //
        CGFloat insetT = - self.scrollView.mj_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.mj_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.mj_h + _scrollViewOriginalInset.top ? self.mj_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.mj_insetT = insetT;
        
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    //
     _scrollViewOriginalInset = self.scrollView.contentInset;
    
    //
    CGFloat offsetY = self.scrollView.mj_offsetY;
    //
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    //
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    //
    CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.mj_h;
    
    if (self.scrollView.isDragging) { //
        self.pullingPercent = pullingPercent;
        if (self.state == MJRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            //
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            //
            self.state = MJRefreshStateIdle;
        }
    } else if (self.state == MJRefreshStatePulling) {//
        //
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    //
    if (state == MJRefreshStateIdle) {
        if (oldState != MJRefreshStateRefreshing) return;
        
        //
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:self.lastUpdatedTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //
        [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
            self.scrollView.mj_insetT += self.insetTDelta;
            
            //
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
            
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }];
    } else if (state == MJRefreshStateRefreshing) {
         dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + self.mj_h;
                //
                self.scrollView.mj_insetT = top;
                //
                [self.scrollView setContentOffset:CGPointMake(0, -top) animated:NO];
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
         });
    }
}

#pragma mark - 
- (void)endRefreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = MJRefreshStateIdle;
    });
}

- (NSDate *)lastUpdatedTime
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:self.lastUpdatedTimeKey];
}
@end
