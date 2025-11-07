//
//  ScanDeviceController.m
//  iReader
//
//  Copyright © 1998-2019, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "ScanDeviceController.h"
#import "winscard.h"
#import "Tools.h"
#import "ReaderInterface.h"
#import "HelpVisualEffectView.h"
#import "OperationViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceCollectionViewCell.h"
#import "readerModel.h"
#import "HJProxy.h"

static id myobject;
SCARDCONTEXT gContxtHandle;
SCARDHANDLE gCardHandle;
NSString *gBluetoothID = @"";

@interface ScanDeviceController () <ReaderInterfaceDelegate, UINavigationControllerDelegate, CBCentralManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *readerNameLabel;
@property (nonatomic, weak) UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIView *scanDeviceListView;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UICollectionView *deviceListCollectionView;
@property (nonatomic, strong) CBCentralManager *central;
@property (nonatomic, strong) NSArray *slotarray;
@property (nonatomic, strong) IBOutlet UILabel *sdkVerLabel;
@end

@implementation ScanDeviceController
{
    NSMutableArray *_deviceList;
    NSString *_selectedDeviceName;
    ReaderInterface *interface;
    HelpVisualEffectView *_helpView;
    BOOL _autoConnect;
    NSInteger _itemHW;
    CGFloat _itemMargin;
    NSInteger _itemCountPerRow;
    NSMutableArray *_displayedItem;
    CGFloat _itemStartX;
    NSMutableArray *_discoverdList;
    NSArray *_tempList;
}

-(void)viewWillAppear:(BOOL)animated
{
    myobject = self;
//    self.navigationController.delegate = self;
    // 禁用返回手势
//        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//        }
    [self initReaderInterface];

    if (gContxtHandle == 0) {
        ULONG ret = SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
        if(ret != 0){
            [[Tools shareTools] showError:[[Tools shareTools] mapErrorCode:ret]];
            return;
        }else
        {
            FtSetTimeout(gContxtHandle, 50000);
        }
    } else {
        SCardReleaseContext(gContxtHandle);
        gContxtHandle = 0;
        
        ULONG ret = SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
        if(ret != 0){
            [[Tools shareTools] showError:[[Tools shareTools] mapErrorCode:ret]];
            return;
        } else {
            FtSetTimeout(gContxtHandle, 50000);
        }
    }
    
    [self beginScanBLEDevice];
}

-(void)beginScanBLEDevice
{
    dispatch_queue_t centralQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    self.central = [[CBCentralManager alloc]initWithDelegate:self queue:centralQueue];
}

-(void)stopScanBLEDevice
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.central stopScan];
         self.central = nil;
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_discoverdList removeAllObjects];
        _tempList = [NSArray array];
        [self.deviceListCollectionView reloadData];
    });
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBPeripheralManagerStatePoweredOn:
            //蓝牙开启后扫描设备
            [self scanDevice];
            break;
        case CBPeripheralManagerStatePoweredOff:
            break;
            
        case CBPeripheralManagerStateUnsupported:
            break;
            
        default:
            break;
    }
}

-(void)scanDevice
{
    NSDictionary *dic = @{CBCentralManagerScanOptionAllowDuplicatesKey : @1};
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.central scanForPeripheralsWithServices:nil options:dic];
    });
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *device = peripheral.name;
    if (![self CheckFTBLEDeviceByAdv:advertisementData]) {
        return;
    }
    
    if (device == nil || device.length == 0) {
        return;
    }
    
    for(int i = 0; i < _discoverdList.count; i++) {
        readerModel *model = _discoverdList[i];
        if ([model.name isEqualToString:device]) {
            model.date = [NSDate date];
            return;
        }
    }
    
    readerModel *model = [readerModel modelWithName:device scanDate:[NSDate date]];
    [_discoverdList addObject:model];
}

-(BOOL) CheckFTBLEDeviceByAdv : (NSDictionary*)adv
{
    BOOL ret = NO;
    if([adv objectForKey:CBAdvertisementDataServiceUUIDsKey])
    {
        NSArray * array0 =[adv objectForKey:CBAdvertisementDataServiceUUIDsKey];
        if(array0.count >0)
        {
        
        CBUUID  *serviceUUID = [[adv objectForKey:CBAdvertisementDataServiceUUIDsKey] objectAtIndex:0];
        NSInteger type = 0;
        ret = [self CheckFTBLEDeviceByUUID:serviceUUID.data UUIDType:&type];
        if(ret == YES)
        {
            if (type != 1) {
                ret = NO;
            }
        }
       }
    }
    return ret;
}

-(BOOL) CheckFTBLEDeviceByUUID : (NSData*)uuidData  UUIDType:(NSInteger*)type
{
    BOOL ret = NO;
    Byte bServiceUUID[100] = {0};
    [uuidData getBytes:bServiceUUID];
    
    if(uuidData.length != 16)
    {
        return NO;
    }
    if((memcmp(bServiceUUID, "FT", 2) == 0)
       && (bServiceUUID[5] == 0x02)
     )
    {
        ret = YES;
        *type = bServiceUUID[3];
    }
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _deviceList = [NSMutableArray array];
    _discoverdList = [NSMutableArray array];
    _tempList = [NSArray array];
    
    _autoConnect = YES;
    _itemHW = 60;
    _itemCountPerRow = 3;
    _itemMargin = (_scanDeviceListView.frame.size.width - _itemHW * _itemCountPerRow) / (_itemCountPerRow + 2);
    _itemStartX = (screenW - _itemHW) * 0.5;

    _displayedItem = [NSMutableArray array];

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _helpView = [[HelpVisualEffectView alloc] initWithEffect:effect];
    _helpView.frame = CGRectMake(0, screenH, screenW, screenH);
    [self.view addSubview:_helpView];
    
    [_deviceListCollectionView registerNib:[UINib nibWithNibName:@"DeviceCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"deviceCell"];
    
    //SDK version
    char libVersion[10] = {0};
    FtGetLibVersion(libVersion);
    NSString *sdkver = [NSString stringWithFormat:@"%s", libVersion];
    
    // get sdk ver
    [self.sdkVerLabel setText:[NSString stringWithFormat:@"sdk version: %s", libVersion]];
    [self.sdkVerLabel setHidden:sdkver.length <= 0];
}

//init readerInterface and card context
- (void)initReaderInterface
{
    interface = [[ReaderInterface alloc] init];
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:autoConnectKey];
    if (value == nil) {
        _autoConnect = NO;
    }
    
    _autoConnect = value.boolValue;
    
    //set auto connect or not, "setAutoPair" must be invoked before "SCardEstablishContext"
    [interface setAutoPair:_autoConnect];
    [interface setDelegate:self];
    //set support device type, default support all readers;
//    [FTDeviceType setDeviceType:(FTDEVICETYPE)(IR301_AND_BR301 | BR301BLE_AND_BR500)];
    
    [FTDeviceType setDeviceType:(FTDEVICETYPE)(IR301_AND_BR301 | BR301BLE_AND_BR500 | LINE_TYPEC)];
    
//    [FTDeviceType setDeviceType:(FTDEVICETYPE)(IR301_AND_BR301)];
}

#pragma mark ReaderInterfaceDelegate
- (void)readerInterfaceDidChange:(BOOL)attached bluetoothID:(NSString *)bluetoothID andslotnameArray:(NSArray *)slotArray
{
    NSLog(@"S--Delegate------------->Reader Interface Did Change");
    if (attached) {
        
        [self stopScanBLEDevice];
        [self stopRefresh];
        
        gBluetoothID = bluetoothID;
        if(slotArray.count>0)
        {
            self.slotarray = slotArray;
        }else
        {
            self.slotarray = nil;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"S--------------->PUSH Operation");
            OperationViewController *operationVC = [[OperationViewController alloc] init];
            operationVC.readerName = [_selectedDeviceName copy];
            
            operationVC.gslotArray = self.slotarray;
            
//            operationVC.rootVC = self;
            [self.navigationController pushViewController:operationVC animated:YES];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _readerNameLabel.text = @"No reader detected";
        });
    }
}

- (void)cardInterfaceDidDetach:(BOOL)attached slotname:(NSString *)slotname
{
    if (attached) {
        NSLog(@"S---------=======》card present");
//        [self connectCard];
        
    }else {
        NSLog(@"S------------------>card not present");
    }
}



- (void) findPeripheralReader:(NSString *)readerName
{
    if (readerName == nil) {
        return;
    }
    
    if ([_deviceList containsObject:readerName]) {
        return;
    }
    
    [_deviceList addObject:readerName];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self displayReader:readerName];
//    });
}

//connect reader
- (void)connectReader:(NSString *)readerName
{
    [[Tools shareTools] showMsg:@"Connect reader"];
    BOOL rev = [interface connectPeripheralReader:readerName timeout:15];
    [[Tools shareTools] hideMsgView];
    if (!rev) {
        [[Tools shareTools] showError:@"connect reader fail"];
    }
}

//connect card
- (void)connectCard {
    NSLog(@"currentThread -- %@", [NSThread currentThread]);

    [[Tools shareTools] showMsg:@"Connect card"];
    
    DWORD dwActiveProtocol = -1;
    NSString *reader = [self getReaderList];
    
    LONG ret = SCardConnect(gContxtHandle, [reader UTF8String], SCARD_SHARE_SHARED,SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1, &gCardHandle, &dwActiveProtocol);
    [[Tools shareTools] hideMsgView];
    
    if(ret != 0){
        NSString *errorMsg = [[Tools shareTools] mapErrorCode:ret];
        [[Tools shareTools] showError:errorMsg];
        return;
    }
    
    unsigned char patr[33] = {0};
    DWORD len = sizeof(patr);
    ret = SCardGetAttrib(gCardHandle,NULL, patr, &len);
    if(ret != SCARD_S_SUCCESS)
    {
        NSLog(@"SCardGetAttrib error %08x",ret);
    }
}

- (NSString *)getReaderList
{
    DWORD readerLength = 0;
    LONG ret = SCardListReaders(gContxtHandle, nil, nil, &readerLength);
    if(ret != 0){
        [[Tools shareTools] showError:[[Tools shareTools] mapErrorCode:ret]];
        return nil;
    }
    
    LPSTR readers = (LPSTR)malloc(readerLength * sizeof(LPSTR));
    ret = SCardListReaders(gContxtHandle, nil, readers, &readerLength);
    if(ret != 0){
        [[Tools shareTools] showError:[[Tools shareTools] mapErrorCode:ret]];
        free(readers);
        return nil;
    }
    
     NSString * strreaders = [NSString stringWithUTF8String:readers];
    free(readers);
    return strreaders;
}


#pragma mark show help info
- (IBAction)helpButtonClick:(id)sender {
    
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self performSegueWithIdentifier:@"operation" sender:nil];
//        });
//
//        return;
    
    [UIView animateWithDuration:0.5 animations:^{
        _helpView.frame = CGRectMake(0, 0, screenW, screenH);
    } completion:^(BOOL finished) {

    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self startRefresh];
    [self setupCollectionView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    myobject = nil;
    [_deviceList removeAllObjects];
    
    for (UIView *view in _scanDeviceListView.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark UINavigationControllerDelegate
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    BOOL isSelf = [viewController isKindOfClass:[self class]];
//    [self.navigationController setNavigationBarHidden:isSelf animated:YES];
//}

- (void)startRefresh
{
    HJProxy *proxy = [HJProxy proxyWithTarget:self];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:proxy selector:@selector(refresh) userInfo:nil repeats:YES];
}

-(void)stopRefresh
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

//restart bluetooth scan
- (void)refresh
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _tempList = [_discoverdList copy];
        for (NSInteger i = 0; i < _tempList.count; i++) {
            readerModel *model = _tempList[i];
            NSDate *_date = model.date;
            if ([[NSDate date] timeIntervalSinceDate:_date] < 1) {
                continue;
            }
            
            [_deviceList removeObject:model.name];
            [_discoverdList removeObject:model];
        }
        _tempList = [_discoverdList copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_deviceListCollectionView reloadData];
        });
    });
}

- (void)setupCollectionView
{
    CGFloat width = _deviceListCollectionView.frame.size.width;
    CGFloat margin = 10;
    CGFloat itemCount = 3;
    CGFloat itemW = (width - (itemCount - 1) * margin) / (itemCount + 1);
    CGFloat itemH = itemW;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);
    
    _deviceListCollectionView.collectionViewLayout = layout;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_autoConnect) {
        return;
    }

    readerModel *model = _tempList[indexPath.row];
    _selectedDeviceName = model.name;
    [self connectReader:_selectedDeviceName];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tempList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"deviceCell" forIndexPath:indexPath];
    
    readerModel *model = _tempList[indexPath.row];
    cell.deviceName = model.name;
    cell.deviceImage = @"readerItem";
    return cell;
}
@end
