//
//  MJRefreshAutoFooter.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) . All rights reserved.
//

#import "MJRefreshFooter.h"

@interface MJRefreshAutoFooter : MJRefreshFooter

@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;


@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh MJRefreshDeprecated("please use triggerAutomaticallyRefreshPercent");


@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;
@end
