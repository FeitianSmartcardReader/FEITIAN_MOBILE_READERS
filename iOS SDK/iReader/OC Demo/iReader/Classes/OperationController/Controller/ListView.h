//
//  ListView.h
//  EdgeProgrammer
//
//  Copyright © 1998-2018, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListViewDelegate <NSObject>
-(void)didSelectedRow:(NSInteger) row;
@end

@interface ListView : UIView

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, weak) id<ListViewDelegate> delegate;

-(void)hideListView;

@end
