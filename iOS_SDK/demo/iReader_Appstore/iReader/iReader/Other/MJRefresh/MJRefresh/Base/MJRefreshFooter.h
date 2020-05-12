//  : https://github.com/CoderMJLee/MJRefresh
//  : http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/5.
//  Copyright (c) . All rights reserved.
//

#import "MJRefreshComponent.h"

@interface MJRefreshFooter : MJRefreshComponent
/**  */
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/**  */
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/**  */
- (void)endRefreshingWithNoMoreData;
- (void)noticeNoMoreData MJRefreshDeprecated("please use endRefreshingWithNoMoreData");

/** */
- (void)resetNoMoreData;

/**  */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;

/** */
@property (assign, nonatomic, getter=isAutomaticallyHidden) BOOL automaticallyHidden;
@end
