//  : https://github.com/CoderMJLee/MJRefresh
//  : http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshComponent.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015. All rights reserved.


#import <UIKit/UIKit.h>
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"
#import "UIScrollView+MJRefresh.h"
#import "NSBundle+MJRefresh.h"


typedef NS_ENUM(NSInteger, MJRefreshState) {
    
    MJRefreshStateIdle = 1,
    
    MJRefreshStatePulling,
    
    MJRefreshStateRefreshing,
    
    MJRefreshStateWillRefresh,

    MJRefreshStateNoMoreData
};


typedef void (^MJRefreshComponentRefreshingBlock)();

typedef void (^MJRefreshComponentbeginRefreshingCompletionBlock)();

typedef void (^MJRefreshComponentEndRefreshingCompletionBlock)();


@interface MJRefreshComponent : UIView
{
    
    UIEdgeInsets _scrollViewOriginalInset;
    
    __weak UIScrollView *_scrollView;
}
#pragma mark -

@property (copy, nonatomic) MJRefreshComponentRefreshingBlock refreshingBlock;

- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action;


@property (weak, nonatomic) id refreshingTarget;

@property (assign, nonatomic) SEL refreshingAction;

- (void)executeRefreshingCallback;

#pragma mark -

- (void)beginRefreshing;
- (void)beginRefreshingWithCompletionBlock:(void (^)())completionBlock;

@property (copy, nonatomic) MJRefreshComponentbeginRefreshingCompletionBlock beginRefreshingCompletionBlock;

@property (copy, nonatomic) MJRefreshComponentEndRefreshingCompletionBlock endRefreshingCompletionBlock;

- (void)endRefreshing;
- (void)endRefreshingWithCompletionBlock:(void (^)())completionBlock;

- (BOOL)isRefreshing;

@property (assign, nonatomic) MJRefreshState state;

#pragma mark -

@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;

@property (weak, nonatomic, readonly) UIScrollView *scrollView;

#pragma mark -

- (void)prepare NS_REQUIRES_SUPER;

- (void)placeSubviews NS_REQUIRES_SUPER;

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;

- (void)scrollViewPanStateDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;


#pragma mark -

@property (assign, nonatomic) CGFloat pullingPercent;

@property (assign, nonatomic, getter=isAutoChangeAlpha) BOOL autoChangeAlpha MJRefreshDeprecated("please use automaticallyChangeAlpha");

@property (assign, nonatomic, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
@end

@interface UILabel(MJRefresh)
+ (instancetype)mj_label;
- (CGFloat)mj_textWith;
@end
