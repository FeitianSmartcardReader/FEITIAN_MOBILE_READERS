//
//  MJRefreshNormalHeader.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) . All rights reserved.
//

#import "MJRefreshStateHeader.h"

@interface MJRefreshNormalHeader : MJRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
