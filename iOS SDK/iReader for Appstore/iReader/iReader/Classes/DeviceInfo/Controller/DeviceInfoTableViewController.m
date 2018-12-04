//
//  DeviceInfoTableViewController.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//
#import "DeviceInfoTableViewController.h"
#import "Tools.h"
#import "DeviceInfoModel.h"
#import "ft301u.h"
#import "hex.h"
#import "ReaderInterface.h"
#import "ScanDeviceController.h"

#define AppVersion @"2.0.0"

extern SCARDCONTEXT gContxtHandle;
extern SCARDHANDLE gCardHandle;
extern NSString *gBluetoothID;

@implementation DeviceInfoTableViewController
{
    NSMutableArray *_readerInfoArray;
    NSMutableArray *_cardInfoArray;
    NSArray *_sectionTitleArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)){
        if ([[Tools shareTools] iPhonexSerial]) {
            self.tableView.contentInset = UIEdgeInsetsMake(64 + 40, 0, 0, 0);
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.tableView.contentInset = UIEdgeInsetsMake(64 + 20, 0, 0, 0);
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    [self.navigationController.navigationBar setBarTintColor:commonColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView.rowHeight = 50;
    
    _readerInfoArray = [NSMutableArray array];
    _cardInfoArray = [NSMutableArray array];
    _sectionTitleArray = @[@"APP INFO", @"READER INFO"];
    
    [self getDeviceInfo];
}

-(void)getDeviceInfo
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[Tools shareTools] showMsg:@"Read Reader Info"];
        
        [self getReaderInfo];
        [self getCardInfo];
        
        [[Tools shareTools] hideMsgView];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

//get reader info
-(void)getReaderInfo
{
    //SDK version
    char libVersion[10] = {0};
    FtGetLibVersion(libVersion);
    NSString *strLibVersion = [NSString stringWithFormat:@"%s", libVersion];
    DeviceInfoModel *lib = [DeviceInfoModel deviceInfoModelWithKey:@"SDK Version" value:strLibVersion];
    [_readerInfoArray addObject:lib];
    
    //Firmware Revision
    char firmwareRevision[32] = {0};
    char hardwareRevision[32] = {0};
    int ret = FtGetDevVer(gContxtHandle, firmwareRevision, hardwareRevision);
    if(ret == SCARD_S_SUCCESS){
        if(strlen(firmwareRevision) > 0) {
            [self addModel:firmwareRevision title:@"Firmware Version"];
        }
        
        if (strlen(hardwareRevision) > 0) {
            [self addModel:hardwareRevision title:@"Hardware Version"];
        }
    }
    
    //Manufacturer
    char cManufacturer[32] = {0};
    unsigned int manufacturerLen = 32;
    ret = FtGetAccessoryManufacturer(gContxtHandle, &manufacturerLen, cManufacturer);
    if(ret == SCARD_S_SUCCESS){
        [self addModel:cManufacturer title:@"Manufacturer"];
    }
    
     //device serial number
    char buffer[16] = {0};
    unsigned int length = 0;
    ret = FtGetSerialNum(gContxtHandle, &length, buffer);
    if(ret == SCARD_S_SUCCESS){
        NSData *data = [NSData dataWithBytes:buffer length:length];
        NSString *str = [NSString stringWithFormat:@"%@", data];
        DeviceInfoModel *manufacturer = [DeviceInfoModel deviceInfoModelWithKey:@"Serial Number" value:str];
        [_readerInfoArray addObject:manufacturer];
    }

    //model
    char cModel[32] = {0};
    unsigned int modelLen = 32;
    ret = FtGetAccessoryModelName(gContxtHandle, &modelLen, cModel);
    if(ret == SCARD_S_SUCCESS){
        [self addModel:cModel title:@"Model Number"];
    }
    
    //reader name
    char cName[32] = {0};
    unsigned int nameLen = 32;
    ret = FtGetReaderName(gContxtHandle, &nameLen, cName);
    if(ret == SCARD_S_SUCCESS){
        [self addModel:cName title:@"Reader Name"];
    }
    
    //Bluetooth ID
    DeviceInfoModel *bluetoothIDModel = [DeviceInfoModel deviceInfoModelWithKey:@"Bluetooth ID" value:gBluetoothID];
    [_readerInfoArray addObject:bluetoothIDModel];
}

- (void)addModel:(char *)name title:(NSString *)title
{
    NSString *nameStr = [NSString stringWithFormat:@"%s", name];
    DeviceInfoModel *deviceModel = [DeviceInfoModel deviceInfoModelWithKey:title value:nameStr];
    [_readerInfoArray addObject:deviceModel];
}

//get card info
-(void)getCardInfo
{
    //name
    
    
    //Interface
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return _readerInfoArray.count;
    }else if (section == 2) {
        return _cardInfoArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = @"deviceInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    DeviceInfoModel *model = [[DeviceInfoModel alloc] init];
    
    if (indexPath.section == 0) {
        model = [DeviceInfoModel deviceInfoModelWithKey:@"App Version" value:AppVersion];
    }else if (indexPath.section == 1) {
        model = _readerInfoArray[indexPath.row];
    }else if (indexPath.section == 2) {
        model = _cardInfoArray[indexPath.row];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = @"Bluetooth Auto Connect";
        cell.detailTextLabel.numberOfLines = 0;
        UISwitch *_switch = [[UISwitch alloc] init];
        NSNumber *number = [[NSUserDefaults standardUserDefaults]valueForKey:autoConnectKey];
        [_switch setOn:number.boolValue];
        [_switch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = _switch;
    }else {
        cell.detailTextLabel.text = model.deviceInfoValue;
        cell.textLabel.text = model.deviceInfoKey;
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)switchValueChanged:(UISwitch *)_switch
{
    BOOL autoConnect = _switch.isOn;
    [[NSUserDefaults standardUserDefaults] setValue:@(autoConnect) forKey:autoConnectKey];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"    %@", _sectionTitleArray[section]];
    label.textColor = [UIColor lightGrayColor];
    return label;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        NSString *str =  @"If enabled,iReader App will connect to the reader which has the strongest Bluetooth signal(normally the nearest)at startup,mostly suilable when you have only one bR301BLE/bR500 around.Disable this if you want to connect a reader manually.";
        
        UIFont *font = [UIFont systemFontOfSize:12];
        CGFloat width = self.tableView.frame.size.width - 20;
        CGFloat height = 90;
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(15, 0, width, height);
        label.text = str;
        label.numberOfLines = 0;
        label.font = font;
        label.textColor = [UIColor lightGrayColor];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, width + 20, height);
        [view addSubview:label];
        return view;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 90;
    }
    
    return 0;
}

@end
