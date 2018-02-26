//
//  Tabbar.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "Tabbar.h"
#import "Button.h"

@interface Tabbar()
@property (weak, nonatomic) Button *addBtn;
@end
@implementation Tabbar

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger index =0;
    CGFloat btnW = self.frame.size.width / 3;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnY = 0;
    
    for(UIView *subView in self.subviews){
        
        if(![subView isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            continue;
        }
        
        CGFloat btnX = btnW * index;
        
        if(index > 0){
            btnX += btnW;
        }
        
        subView.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        index++;
    }
    
    self.addBtn.frame = CGRectMake(btnW, btnY, btnW, btnH);
}


-(Button *)addBtn
{
    if(_addBtn == nil){
        
        Button *btn = [Button buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"readerCommand"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"readerCommandHighlight"] forState:UIControlStateHighlighted];
        [btn setTitle:@"Reader Command" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _addBtn = btn;
        
        [self addSubview:btn];
    }
    
    return _addBtn;
}

-(void)addBtnClick
{
    if([self.myDelegate respondsToSelector:@selector(TabBarAddBtnClick)]){
        [self.myDelegate TabBarAddBtnClick];
    }
}

@end
