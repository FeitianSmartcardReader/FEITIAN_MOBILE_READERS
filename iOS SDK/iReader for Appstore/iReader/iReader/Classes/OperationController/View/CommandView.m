//
//  CommandView.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "CommandView.h"
#import "CollectionViewCell.h"

@interface CommandView()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation CommandView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        self = [[CommandView alloc] initWithEffect:effect];
    }
    return self;
}

-(void)layoutSubviews
{
    [self setupCollection];
}

-(void)setupCollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(145, 145);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    NSInteger viewH = 300;
    NSInteger viewW = self.frame.size.width;
    NSInteger viewX = 0;
    NSInteger viewY = self.frame.size.height - viewH - 50;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH) collectionViewLayout:layout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"commandCell"];

    [self.contentView addSubview:collectionView];
    
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat btnW = 40;
    CGFloat btnH = 40;
    CGFloat btnX = (self.frame.size.width - btnW) * 0.5;
    CGFloat btnY = self.frame.size.height - 45;
    
    closeBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [closeBtn setImage:[UIImage imageNamed:@"close"]
              forState:UIControlStateNormal];
    [closeBtn addTarget:self
                 action:@selector(closeBtnClick)
       forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closeBtn];
}

//关闭按钮点击事件
-(void)closeBtnClick
{
   [self removeFromSuperview];
}

#pragma mark collectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.myDelegate respondsToSelector:@selector(didSelectCellAtIndexPath:)]){
        [self.myDelegate didSelectCellAtIndexPath:indexPath.row];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.commandArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"commandCell" forIndexPath:indexPath];
    
    cell.model = self.commandArray[indexPath.row];
    return cell;
}

@end
