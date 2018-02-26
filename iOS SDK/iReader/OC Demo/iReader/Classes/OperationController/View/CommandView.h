//
//  CommandView.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommandCellClickDelegate<NSObject>

-(void)didSelectCellAtIndexPath:(NSInteger)row;

@end

@interface CommandView : UIVisualEffectView
@property (nonatomic, strong)NSArray *commandArray;
@property (nonatomic, assign)id<CommandCellClickDelegate> myDelegate;
@end
