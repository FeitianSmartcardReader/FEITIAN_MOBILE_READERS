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
//extern CK_AUX_COMM_HANDLE deviceHandle;
extern SCARDCONTEXT gContxtHandle;


@interface DeviceInfoTableViewController ()

@end

@implementation DeviceInfoTableViewController
{
    NSMutableArray *_deviceInfoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)){
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    
    _deviceInfoArray = [NSMutableArray array];
    
    [self getDeviceInfo];
}

-(void)getDeviceInfo
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[Tools shareTools] showMsg:@"get device info..."];

        NSInteger ret = 0;
        
        /**
         *  firmwareRevision/hardwareRevision
         */
        char firmwareRevision[32] = {0};
        char hardwareRevision[32] = {0};
        ret = FtGetDevVer(gContxtHandle, firmwareRevision, hardwareRevision);
        if(ret != SCARD_S_SUCCESS){
            [[Tools shareTools] showError: ret];
            return;
        }
        NSString *strFirmware = [NSString stringWithFormat:@"%s", firmwareRevision];
        DeviceInfoModel *firmware = [DeviceInfoModel deviceInfoModelWithKey:@"Firmware Version" value:strFirmware];
        
        /**
         *  device serial number
         */
        char buffer[16] = {0};
        unsigned int length = 0;
        ret = FtGetSerialNum(gContxtHandle, &length, buffer);
        if(ret != SCARD_S_SUCCESS){
            [[Tools shareTools] showError: ret];
            return;
        }
        unsigned char *pbDest;
        NSString *strDeviceSN = [NSString stringWithFormat:@"%s", pbDest];
        DeviceInfoModel *SN = [DeviceInfoModel deviceInfoModelWithKey:@"Serial No." value:strDeviceSN];
        
        /**
         *  lib version
         */
        char libVersion[10] = {0};
        FtGetLibVersion(libVersion);
        NSString *strLibVersion = [NSString stringWithFormat:@"%s", libVersion];
        DeviceInfoModel *lib = [DeviceInfoModel deviceInfoModelWithKey:@"SDK Version" value:strLibVersion];
        
//        [_deviceInfoArray addObject:manufacturer];
//        [_deviceInfoArray addObject:modeName];
        [_deviceInfoArray addObject:firmware];
        [_deviceInfoArray addObject:SN];
        [_deviceInfoArray addObject:lib];
        
        [[Tools shareTools] hideMsgView];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _deviceInfoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = @"deviceInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    DeviceInfoModel *model = _deviceInfoArray[indexPath.section];
    cell.textLabel.text = model.deviceInfoValue;
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    DeviceInfoModel *model = _deviceInfoArray[section];
    return model.deviceInfoKey;
}

@end
