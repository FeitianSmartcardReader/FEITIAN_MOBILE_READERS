//
//  ScanDeviceController.m
//  eID Viewer
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "ScanDeviceController.h"
#import "TabbarViewController.h"
#import "winscard.h"
#import "Tools.h"
#import "ReaderInterface.h"

static id myobject;
SCARDCONTEXT gContxtHandle;

@interface ScanDeviceController () <ReaderInterfaceDelegate>
@property (nonatomic, weak) UIButton *refreshBtn;
@end

@implementation ScanDeviceController
{
    NSMutableArray *_deviceList;
    NSString *_selectedDeviceName;
    ReaderInterface *interface;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _deviceList = [NSMutableArray array];
    myobject = self;
    
    interface = [[ReaderInterface alloc] init];
    [interface setDelegate:self];
    
    if (@available(iOS 11.0, *)){
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self setupNavigation];
    
    NSInteger ret = SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
    if(ret != 0){
        [[Tools shareTools] showError:ret];
        return;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    myobject = nil;
    [_deviceList removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)scanDevice
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [[Tools shareTools] showMsg:@"scan device..."];
        
        char mszReaders[128] = "";
        DWORD pcchReaders = -1;
        
        NSInteger iRet = SCardListReaders(gContxtHandle, NULL, mszReaders, &pcchReaders);
        if(iRet != SCARD_S_SUCCESS)
        {
            [[Tools shareTools] hideMsgView];
            [[Tools shareTools] showError:iRet];
        }else{
            char tempReaderName[32] = {0};
            NSLog(@"SCardListReader Sucess!");
            int tempIndex = 0;
            for (int index = 0; index < pcchReaders; index++) {
                if(mszReaders[index] != '\0'){
                    tempReaderName[tempIndex] = mszReaders[index];
                    tempIndex++;
                    continue;
                }
                tempIndex = 0;
                NSString *device = [[NSString alloc] initWithCString:tempReaderName encoding:NSUTF8StringEncoding];
                if(![_deviceList containsObject:device]){
                    [_deviceList addObject:device];
                }
                memset(tempReaderName, 0, sizeof(tempReaderName));
            }
        }
        
        [[Tools shareTools] hideMsgView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

-(void)setupNavigation
{
    self.navigationItem.title = @"scan device";
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn = refreshBtn;
    refreshBtn.frame = CGRectMake(0, 0, 80, 44);
    [refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refreshBtn setTitle:@"refresh" forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(scanDevice) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _deviceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"ScanDeviceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = _deviceList[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedDeviceName = _deviceList[indexPath.row];
    [self performSegueWithIdentifier:@"sendAPDU" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TabbarViewController *tabbarVC = segue.destinationViewController;
    tabbarVC.deviceName = _selectedDeviceName;
}

- (void) findPeripheralReader:(NSString *)readerName
{
    NSLog(@"%@", [NSString stringWithFormat:@"find reader: %@", readerName]);
}

- (void) readerInterfaceDidChange:(BOOL)attached
{
    NSLog(@"%@", [NSString stringWithFormat:@"reader status did change: %zd", attached]);
}
@end
