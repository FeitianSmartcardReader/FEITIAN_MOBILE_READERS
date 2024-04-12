//
//  ListView.m
//  EdgeProgrammer
//
//  Copyright © 1998-2018, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "ListView.h"

@interface ListView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ListView
{
    UITableView *_tableView;
    UIView *_coverView;
}

-(void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [_tableView reloadData];
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    UIView *view = self.superview;
    if (view == nil) {
        return;
    }
    
    UIView *coverView = [[UIView alloc] init];
    _coverView = coverView;
    coverView.frame = [UIScreen mainScreen].bounds;
    coverView.backgroundColor = [UIColor whiteColor];
    coverView.alpha = 0.02;
    [coverView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideListView)]];
    
    [view addSubview:coverView];
    [view bringSubviewToFront:self];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.layer.shadowOffset = CGSizeMake(-5, 5);
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1].CGColor;
    self.layer.cornerRadius = 3;
    [self.superview.window addSubview:self];
    
    //setup tableview
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 30;
    [self addSubview:tableView];
}

-(void)hideListView
{
    [self removeFromSuperview];
    [_coverView removeFromSuperview];
}

#pragma mark tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"ListViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideListView];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedRow:)]) {
        [self.delegate didSelectedRow:indexPath.row];
    }
}
@end
