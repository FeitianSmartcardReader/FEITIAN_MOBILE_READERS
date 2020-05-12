//  : https://github.com/CoderMJLee/MJRefresh
//  : http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshComponent.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015. All rights reserved.
//

#import "MJRefreshComponent.h"
#import "MJRefreshConst.h"

@interface MJRefreshComponent()
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@end

@implementation MJRefreshComponent
#pragma mark -
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        [self prepare];
        
        //
        self.state = MJRefreshStateIdle;
    }
    return self;
}

- (void)prepare
{
    //
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [self placeSubviews];
    
    [super layoutSubviews];
}

- (void)placeSubviews{}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    //
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    //
    [self removeObservers];
    
    if (newSuperview) { //
        //
        self.mj_w = newSuperview.mj_w;
        //
        self.mj_x = 0;
        
        //
        _scrollView = (UIScrollView *)newSuperview;
        //
        _scrollView.alwaysBounceVertical = YES;
        //
        _scrollViewOriginalInset = _scrollView.contentInset;
        
        //
        [self addObservers];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.state == MJRefreshStateWillRefresh) {
        //
        self.state = MJRefreshStateRefreshing;
    }
}

#pragma mark -
- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentSize options:options context:nil];
    self.pan = self.scrollView.panGestureRecognizer;
    [self.pan addObserver:self forKeyPath:MJRefreshKeyPathPanState options:options context:nil];
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:MJRefreshKeyPathContentSize];;
    [self.pan removeObserver:self forKeyPath:MJRefreshKeyPathPanState];
    self.pan = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //
    if (!self.userInteractionEnabled) return;
    
    //
    if ([keyPath isEqualToString:MJRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    //
    if (self.hidden) return;
    if ([keyPath isEqualToString:MJRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:MJRefreshKeyPathPanState]) {
        [self scrollViewPanStateDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{}
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{}
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{}

#pragma mark -
#pragma mark
- (void)setRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    self.refreshingTarget = target;
    self.refreshingAction = action;
}

- (void)setState:(MJRefreshState)state
{
    _state = state;
    
    //
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsLayout];
    });
}

#pragma mark
- (void)beginRefreshing
{
    [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    self.pullingPercent = 1.0;
    //
    if (self.window) {
        self.state = MJRefreshStateRefreshing;
    } else {
        //
        if (self.state != MJRefreshStateRefreshing) {
            self.state = MJRefreshStateWillRefresh;
            //
            [self setNeedsDisplay];
        }
    }
}

- (void)beginRefreshingWithCompletionBlock:(void (^)())completionBlock
{
    self.beginRefreshingCompletionBlock = completionBlock;
    
    [self beginRefreshing];
}

#pragma mark
- (void)endRefreshing
{
    self.state = MJRefreshStateIdle;
}

- (void)endRefreshingWithCompletionBlock:(void (^)())completionBlock
{
    self.endRefreshingCompletionBlock = completionBlock;
    
    [self endRefreshing];
}

#pragma mark
- (BOOL)isRefreshing
{
    return self.state == MJRefreshStateRefreshing || self.state == MJRefreshStateWillRefresh;
}

#pragma mark
- (void)setAutoChangeAlpha:(BOOL)autoChangeAlpha
{
    self.automaticallyChangeAlpha = autoChangeAlpha;
}

- (BOOL)isAutoChangeAlpha
{
    return self.isAutomaticallyChangeAlpha;
}

- (void)setAutomaticallyChangeAlpha:(BOOL)automaticallyChangeAlpha
{
    _automaticallyChangeAlpha = automaticallyChangeAlpha;
    
    if (self.isRefreshing) return;
    
    if (automaticallyChangeAlpha) {
        self.alpha = self.pullingPercent;
    } else {
        self.alpha = 1.0;
    }
}

#pragma mark
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    _pullingPercent = pullingPercent;
    
    if (self.isRefreshing) return;
    
    if (self.isAutomaticallyChangeAlpha) {
        self.alpha = pullingPercent;
    }
}

#pragma mark - 
- (void)executeRefreshingCallback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        if ([self.refreshingTarget respondsToSelector:self.refreshingAction]) {
            MJRefreshMsgSend(MJRefreshMsgTarget(self.refreshingTarget), self.refreshingAction, self);
        }
        if (self.beginRefreshingCompletionBlock) {
            self.beginRefreshingCompletionBlock();
        }
    });
}
@end

@implementation UILabel(MJRefresh)
+ (instancetype)mj_label
{
    UILabel *label = [[self alloc] init];
    label.font = MJRefreshLabelFont;
    label.textColor = MJRefreshLabelTextColor;
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (CGFloat)mj_textWith {
    CGFloat stringWidth = 0;
    CGSize size = CGSizeMake(MAXFLOAT, MAXFLOAT);
    if (self.text.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringWidth =[self.text
                      boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:self.font}
                      context:nil].size.width;
#else
        
        stringWidth = [self.text sizeWithFont:self.font
                             constrainedToSize:size
                                 lineBreakMode:NSLineBreakByCharWrapping].width;
#endif
    }
    return stringWidth;
}
@end
