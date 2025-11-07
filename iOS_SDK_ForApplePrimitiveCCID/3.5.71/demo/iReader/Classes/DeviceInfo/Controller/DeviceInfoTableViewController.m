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
#import "ReaderInterface.h"
#import "ScanDeviceController.h"

#define AppVersion @"2.1.5"
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
extern SCARDCONTEXT gContxtHandle;
extern SCARDHANDLE gCardHandle;
extern NSString *gBluetoothID;

@implementation DeviceInfoTableViewController
{
    NSMutableArray *_readerInfoArray;
    NSMutableArray *_cardInfoArray;
    NSMutableArray *_sectionTitleArray;
    NSMutableArray *_sectionFooterArray;
    NSMutableArray *_cellText;
    unsigned int _type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)){
        if ([[Tools shareTools] iPhonexSerial]) {
            self.tableView.contentInset = UIEdgeInsetsMake(64 + 24, 0, 15, 0);
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    [self.navigationController.navigationBar setBarTintColor:commonColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tableView.rowHeight = 50;
    
    _readerInfoArray = [NSMutableArray array];
    _cardInfoArray = [NSMutableArray array];
    _sectionTitleArray = [NSMutableArray arrayWithArray:@[@"APP INFO", @"READER INFO", @" ", @" "]];
    _sectionFooterArray = [NSMutableArray arrayWithArray:@[@"", @"",
        @"If enabled,iReader App will connect to the reader which has the strongest Bluetooth signal(normally the nearest)at startup,mostly suilable when you have only one bR301BLE/bR500 around.Disable this if you want to connect a reader manually.",
       @"The power saving mode of Bluetooth reader is enabled by default, in order to extend battery life of a reader. it will automaticlly shut down in 3 minutes if there is no communication between App and reader.\nIf set switch button to ON, the App will turn off power saving mode to keep reader always powered, except pysical shutdown by power button or by turnning off the Bluetooth.\nThis power saving mode is one time setting, after closing App, the reader will go back to default.\n"]];
    
    _cellText = [NSMutableArray arrayWithArray:@[@"", @"", @"Bluetooth Auto Connect", @"Disable power saving mode"]];
    
    _type = 0;
    FtGetCurrentReaderType(&_type);

    [self getDeviceInfo];
}




-(void)getDeviceInfo
{
    [[Tools shareTools] showMsg:@"Read Reader Info"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getReaderInfo];
        [self getCardInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[Tools shareTools] hideMsgView];
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
//            [self addModel:hardwareRevision title:@"Hardware Version"];
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
        

        NSMutableString *deviceTokenString = [NSMutableString string];
        const char *bytes = (const char *)data.bytes;
        NSInteger count = data.length;
        if(count == 16)
        {
            
            NSString * strrr =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                       deviceTokenString = [[NSMutableString alloc]initWithString:strrr];
                       [deviceTokenString insertString:@" " atIndex:8];
            
        }else
        {
        
        for (int i = 0; i < count; i++) {
            if((i+1)%4 == 0)
            {
                if(i+1 == count)
                {
                [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
                }else
                {
                [deviceTokenString appendFormat:@"%02x ", bytes[i]&0x000000FF];
                }
            }else
            {
                  [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
            }
        }
        }
        
         NSString *str = [NSString stringWithFormat:@"<%@>", deviceTokenString];
        
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
    if(     gBluetoothID != nil  && gBluetoothID.length != 1 ){
        DeviceInfoModel *bluetoothIDModel = [DeviceInfoModel deviceInfoModelWithKey:@"Bluetooth ID" value:gBluetoothID];
        [_readerInfoArray addObject:bluetoothIDModel];
    }
    
    char bluetoothVersion[10] = {0};
    ret = FTGetBluetoothFWVer(gContxtHandle, bluetoothVersion);
    if(ret == SCARD_S_SUCCESS){
        [self addModel:bluetoothVersion title:@"bluetooth version"];
    }
}

- (void)addModel:(char *)name title:(NSString *)title
{
    NSString *nameStr = [NSString stringWithFormat:@"%s", name];
//    BOOL a = [nameStr isEqualToString:@""];
    if(nameStr.length != 1)
    {
    DeviceInfoModel *deviceModel = [DeviceInfoModel deviceInfoModelWithKey:title value:nameStr];
    [_readerInfoArray addObject:deviceModel];
    }
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
        return 1;
    }else if (section == 1) {
        return _readerInfoArray.count;
    }else if (section == 2) {
        return 1;
    }else if (section == 3) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = @"deviceInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.accessoryView = nil;
    
    DeviceInfoModel *model = [[DeviceInfoModel alloc] init];
    
    if (indexPath.section == 0) {
        model = [DeviceInfoModel deviceInfoModelWithKey:@"App Version" value:AppVersion];
    }else if (indexPath.section == 1) {
        model = _readerInfoArray[indexPath.row];
    }
    
    if (indexPath.section == 2 || indexPath.section == 3) {
        cell.textLabel.text = _cellText[indexPath.section];
        cell.detailTextLabel.numberOfLines = 0;
        UISwitch *_switch = [[UISwitch alloc] init];
        _switch.tag = indexPath.section;
    
        NSNumber *number = [[NSUserDefaults standardUserDefaults]valueForKey:autoConnectKey];
        if (indexPath.section == 3) {
            number = [[NSUserDefaults standardUserDefaults]valueForKey:autoPowerOffKey];
        }
        
        if (number == nil) {
            [_switch setOn:NO];
        }else {
            [_switch setOn:number.boolValue];
        }
        
        [_switch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = _switch;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_sectionFooterArray[indexPath.section]];
        
//        if ([FTDeviceType getDeviceType] == IR301_AND_BR301) {
        if (_type == READER_iR301U_DOCK || _type == READER_iR301U_LIGHTING) {
            if (indexPath.section == 3) {
                _switch.enabled = false;
                NSAttributedString *_str = [[NSAttributedString alloc] initWithString:@"Disable power saving mode error or not supported by this firmware version.\n" attributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
                 NSLog(@"0--->%lu",_str.length);
                [str insertAttributedString:_str atIndex:0];
            }
        }
        NSLog(@"1--->%lu",str.length);
        if(indexPath.section == 2)
        {
        cell.detailTextLabel.attributedText = str;
        }else
        {
            if(str.length == 554)
            {
                NSLog(@"ff");
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 75)];
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(75,479)];
           
              
            }else
            {
                  [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,str.length-1)];
            }
            cell.detailTextLabel.attributedText = str;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           return cell;
            
        }
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
    BOOL isOn = _switch.isOn;
    if (_switch.tag == 2) {
        [[NSUserDefaults standardUserDefaults] setValue:@(isOn) forKey:autoConnectKey];
    }else if (_switch.tag == 3) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

            [[Tools shareTools] showMsg:@"reader auto off"];
            
            NSInteger iRet = FT_AutoTurnOffReader(!isOn);
            if (iRet != SCARD_S_SUCCESS) {
                NSString *error = [NSString stringWithFormat:@"Disable power saving mode not supported by this firmware version."];
            
                [[Tools shareTools] showError:error];
                 [[Tools shareTools] hideMsgView];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_switch setOn:!isOn];
                });
            }else {
                [[Tools shareTools] hideMsgView];
                [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:isOn] forKey:autoPowerOffKey];
            }
        });
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"    %@", _sectionTitleArray[section]];
    label.textColor = [UIColor lightGrayColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 || indexPath.section == 3) {
        NSString *str = _sectionFooterArray[indexPath.section];
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 150;
        UIFont *font = [UIFont systemFontOfSize:12];
        CGFloat heiht = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
        
        if(indexPath.section == 3)
        {
            if(SCREEN_HEIGHT > 667)
            {
            return heiht+30;
            }else
            {
                return  heiht;
            }
            
        }else
        {
        return heiht;
        }
    }

    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

@end
