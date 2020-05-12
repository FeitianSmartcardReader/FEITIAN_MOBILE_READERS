//  : https://github.com/CoderMJLee/MJRefresh
//  : http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) . All rights reserved.
//

#import "MJRefreshComponent.h"

@interface MJRefreshHeader : MJRefreshComponent
/**  */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/**  */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** */
@property (copy, nonatomic) NSString *lastUpdatedTimeKey;
/** */
@property (strong, nonatomic, readonly) NSDate *lastUpdatedTime;

/**  */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;
@end
