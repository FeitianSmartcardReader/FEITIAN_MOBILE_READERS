//
//  QCPopView.m
//  test
//
//  Created by 乔超 on 2017/8/8.
//  Copyright © 2017年 BoYaXun. All rights reserved.
//

#import "QCPopView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define LineColor [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]
@interface ButtonTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *label;
@property(nonatomic,readwrite) UIImageView *imageView1;

@end

@implementation ButtonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT * (40.0/736.0))];

        self.label.font = [UIFont systemFontOfSize:13];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
//        self.label.backgroundColor = [UIColor clearColor];
        

        
        UIView *view = [UIView new];
        [self addSubview:view];
        view.backgroundColor = LineColor;
        view.frame = CGRectMake(0, SCREEN_HEIGHT * (40.0/736.0), SCREEN_WIDTH-40, 1);
        

        
    }
    return self;
}


@end


@interface QCPopView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *imageSource;
@property (nonatomic, strong) UIView *bgView;
@end
@implementation QCPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        //初始化各种起始属性
        [self initAttribute];
        
        [self initTabelView];
    }
    return self;
}

- (void)initTabelView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, self.contentShift) style:UITableViewStylePlain];
    self.tableView.layer.cornerRadius = 10;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ButtonTableViewCell class] forCellReuseIdentifier:@"cell1"];

    [self.contentView addSubview:self.tableView];
    
}



/**
 *  初始化起始属性
 */

- (void)initAttribute{
    
    self.buttonH = SCREEN_HEIGHT * (40.0/736.0)+1;
    self.buttonMargin = 10;
    self.contentShift = SCREEN_HEIGHT * (250.0/736.0);
    self.animationTime = 0.8;
    self.backgroundColor = [UIColor colorWithWhite:0.614 alpha:0.700];
    
    [self initSubViews];
}


/**
 *  初始化子控件
 */
- (void)initSubViews{
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.frame = CGRectMake(20, 150, SCREEN_WIDTH-40, self.contentShift);
    [self addSubview:self.contentView];
    
}
/**
 *  展示pop视图
 *
 *  @param array 需要显示button的title数组
 */
- (void)showThePopViewWithArray:(NSMutableArray *)array{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    
    [window addSubview:self];
    self.dataSource = array;
    
    
}
-(void)showTheCheckViewWithArray:(NSMutableArray *)array{

    self.imageSource = array;
    
    NSLog(@"%@",self.imageSource);

}

- (void)dismissThePopView{
    
    
    [self removeFromSuperview];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self dismissThePopView];
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    NSString * buttonStr = self.dataSource[indexPath.row];
    cell.label.text = buttonStr;

    return cell;
    
    
    
}
#pragma mark - UITableViewDelagate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.buttonH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.QCPopViewDelegate respondsToSelector:@selector(getTheButtonTitleWithIndexPath:)]) {
        [self.QCPopViewDelegate getTheButtonTitleWithIndexPath:indexPath];
    }
}









@end
