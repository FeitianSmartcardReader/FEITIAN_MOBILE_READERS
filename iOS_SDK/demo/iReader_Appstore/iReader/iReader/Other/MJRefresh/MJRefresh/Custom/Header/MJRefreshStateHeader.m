//
//  MJRefreshStateHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) . All rights reserved.
//

#import "MJRefreshStateHeader.h"

@interface MJRefreshStateHeader()
{
    /** */
    __unsafe_unretained UILabel *_lastUpdatedTimeLabel;
    /** */
    __unsafe_unretained UILabel *_stateLabel;
}
/**  */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end

@implementation MJRefreshStateHeader
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

- (UILabel *)lastUpdatedTimeLabel
{
    if (!_lastUpdatedTimeLabel) {
        [self addSubview:_lastUpdatedTimeLabel = [UILabel mj_label]];
    }
    return _lastUpdatedTimeLabel;
}

#pragma mark -
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 。
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

#pragma mark key
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey
{
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    
    //
    if (self.lastUpdatedTimeLabel.hidden) return;
    
    NSDate *lastUpdatedTime = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdatedTimeKey];
    
    // block
    if (self.lastUpdatedTimeText) {
        self.lastUpdatedTimeLabel.text = self.lastUpdatedTimeText(lastUpdatedTime);
        return;
    }
    
    if (lastUpdatedTime) {
        // 1.
        NSCalendar *calendar = [self currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
        NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdatedTime];
        NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
        
        // 2.
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        BOOL isToday = NO;
        if ([cmp1 day] == [cmp2 day]) { //
            formatter.dateFormat = @" HH:mm";
            isToday = YES;
        } else if ([cmp1 year] == [cmp2 year]) { //
            formatter.dateFormat = @"MM-dd HH:mm";
        } else {
            formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        }
        NSString *time = [formatter stringFromDate:lastUpdatedTime];
        
        // 3.
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@%@",
                                          [NSBundle mj_localizedStringForKey:MJRefreshHeaderLastTimeText],
                                          isToday ? [NSBundle mj_localizedStringForKey:MJRefreshHeaderDateTodayText] : @"",
                                          time];
    } else {
        self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@",
                                          [NSBundle mj_localizedStringForKey:MJRefreshHeaderLastTimeText],
                                          [NSBundle mj_localizedStringForKey:MJRefreshHeaderNoneLastDateText]];
    }
}

#pragma mark -
- (void)prepare
{
    [super prepare];
    
    //
    self.labelLeftInset = MJRefreshLabelLeftInset;
    
    //
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHeaderIdleText] forState:MJRefreshStateIdle];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHeaderPullingText] forState:MJRefreshStatePulling];
    [self setTitle:[NSBundle mj_localizedStringForKey:MJRefreshHeaderRefreshingText] forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.hidden) return;
    
    BOOL noConstrainsOnStatusLabel = self.stateLabel.constraints.count == 0;
    
    if (self.lastUpdatedTimeLabel.hidden) {
        //
        if (noConstrainsOnStatusLabel) self.stateLabel.frame = self.bounds;
    } else {
        CGFloat stateLabelH = self.mj_h * 0.5;
        //
        if (noConstrainsOnStatusLabel) {
            self.stateLabel.mj_x = 0;
            self.stateLabel.mj_y = 0;
            self.stateLabel.mj_w = self.mj_w;
            self.stateLabel.mj_h = stateLabelH;
        }
        
        //
        if (self.lastUpdatedTimeLabel.constraints.count == 0) {
            self.lastUpdatedTimeLabel.mj_x = 0;
            self.lastUpdatedTimeLabel.mj_y = stateLabelH;
            self.lastUpdatedTimeLabel.mj_w = self.mj_w;
            self.lastUpdatedTimeLabel.mj_h = self.mj_h - self.lastUpdatedTimeLabel.mj_y;
        }
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    //
    self.stateLabel.text = self.stateTitles[@(state)];
    
    // 
    self.lastUpdatedTimeKey = self.lastUpdatedTimeKey;
}
@end
