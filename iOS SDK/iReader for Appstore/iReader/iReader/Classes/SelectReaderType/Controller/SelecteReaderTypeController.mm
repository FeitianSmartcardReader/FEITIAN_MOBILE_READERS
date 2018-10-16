//
//  SelecteReaderTypeController.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "SelecteReaderTypeController.h"
#import "ReaderTypeTableViewCell.h"
#import "ReaderModel.h"
#import "ScanDeviceController.h"

static NSString *cellID = @"SelectReaderCell";

@interface SelecteReaderTypeController ()
@property (nonatomic, strong) NSMutableArray *readerType;
@end

@implementation SelecteReaderTypeController

-(NSMutableArray *)readerType
{
    if(_readerType == nil){
        _readerType = [NSMutableArray array];
    }
    return _readerType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self formReaderTypeArray];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:124/255.0 blue:247/255.0 alpha:1.0];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReaderTypeTableViewCell class]) bundle:nil] forCellReuseIdentifier:cellID];
}

-(void)formReaderTypeArray
{
    NSArray *titleArr = @[@"iR301 & bR301", @"bR301BLE & bR500"];
    NSArray *imageArr = @[@"iR301bR301", @"bR500"];
    
    for(NSInteger i = 0 ; i < titleArr.count; i++){
        ReaderModel *model = [ReaderModel ReaderModelWithImage:imageArr[i] title:titleArr[i]];
        [self.readerType addObject:model];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _readerType.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReaderTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.readerModel = self.readerType[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row == 0){
//        [DeviceType setDeviceType:IR301_AND_BR301];
//    }else{
//        [DeviceType setDeviceType:BR301BLE_AND_BR500];
//    }
    
    [self performSegueWithIdentifier:@"scanDevice" sender:nil];
}
@end
