//
//  ScanDeviceController.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "ScanDeviceController.h"
#import "winscard.h"
#import "Tools.h"
#import "ReaderInterface.h"
#import "HelpVisualEffectView.h"
#import "ReaderItemView.h"
#import "OperationViewController.h"

static id myobject;
SCARDCONTEXT gContxtHandle;
SCARDHANDLE gCardHandle;
NSString *gBluetoothID = @"";

@interface ScanDeviceController () <ReaderInterfaceDelegate, UINavigationControllerDelegate, ReaderItemViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *readerNameLabel;
@property (nonatomic, weak) UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIView *scanDeviceListView;
@property (nonatomic, strong) NSTimer *timer;
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
}

-(void)viewWillAppear:(BOOL)animated
{
    myobject = self;
    self.navigationController.delegate = self;
    
    NSNumber *value = [[NSUserDefaults standardUserDefaults] valueForKey:autoConnectKey];
    if (value == nil) {
        _autoConnect = NO;
    }
    _autoConnect = value.boolValue;
    [interface setAutoPair:_autoConnect];
    
    [interface setDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    interface = [[ReaderInterface alloc] init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initReaderInterface];
    });
    
    _deviceList = [NSMutableArray array];
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
    
    [self startRefreshThread];
}

//init readerInterface and card context
- (void)initReaderInterface
{
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
    
    ULONG ret = SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
    if(ret != 0){
        [[Tools shareTools] showError:[[Tools shareTools] mapErrorCode:ret]];
    }
}

#pragma mark ReaderInterfaceDelegate
- (void)readerInterfaceDidChange:(BOOL)attached bluetoothID:(NSString *)bluetoothID
{
    if (attached) {
        gBluetoothID = bluetoothID;
    
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *reader = [self getReaderList];
            if (reader.length == 0 || reader == nil) {
                return ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _readerNameLabel.text = reader;
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_autoConnect) {
                    _selectedDeviceName = [self getReaderList];
                }
                
                OperationViewController *operationVC = [[OperationViewController alloc] init];
                operationVC.readerName = _selectedDeviceName;
                operationVC.rootVC = self;
                [self.navigationController pushViewController:operationVC animated:YES];
            });
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _readerNameLabel.text = @"No reader detected";
        });
    }
}

- (void)cardInterfaceDidDetach:(BOOL)attached
{
    if (attached) {
        NSLog(@"card present");
        
    }else {
        NSLog(@"card not present");
    }
}

- (void) findPeripheralReader:(NSString *)readerName
{
    if ([_deviceList containsObject:readerName]) {
        return;
    }
    
    [_deviceList addObject:readerName];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayReader:readerName];
    });
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
        return nil;
    }
    
    return [NSString stringWithUTF8String:readers];
}

- (void)displayReader:(NSString *)readerName
{
    NSInteger currentItemCount = _scanDeviceListView.subviews.count;
    if (currentItemCount >= 6) {
        return;
    }
    
    CGFloat distence = (_itemHW + _itemMargin) * 0.5;
    NSInteger row = currentItemCount / 3;   //行
    NSInteger col = currentItemCount % 3;   //列
    
    //add new item
    CGFloat itemX = _itemStartX + col * distence;
    CGFloat itemY = row * (_itemHW + 50);
    
    CGRect frame = CGRectMake(itemX, itemY, _itemHW, _itemHW);
    
    ReaderItemView *item = [[ReaderItemView alloc] initReaderItemWithName:readerName type:0 frame:frame];
    item.delegate = self;
    item.alpha = 0;
    [_scanDeviceListView addSubview:item];
    
    [UIView animateWithDuration:0.5 animations:^{

        NSInteger count = _scanDeviceListView.subviews.count;
        NSInteger row = currentItemCount / 3;
        
        for (NSInteger i = row * 3; i < count - 1; i++) {
            ReaderItemView *tempItem = _scanDeviceListView.subviews[i];
            CGFloat x = tempItem.frame.origin.x - distence;
            CGFloat y = tempItem.frame.origin.y;
            CGFloat w = tempItem.frame.size.width;
            CGFloat h = tempItem.frame.size.height;
            tempItem.frame = CGRectMake(x, y, w, h);
        }
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            item.alpha = 1;
        }];
    }];
}

//清除所有设备
- (void)clearAllReader
{
    [_deviceList removeAllObjects];
    for (UIView *view in _scanDeviceListView.subviews) {
        [view removeFromSuperview];
    }
}

#pragma item view delegate
-(void)didSelecteItem:(NSString *)name
{
    if (_autoConnect) {
        return;
    }
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _selectedDeviceName = name;
    [self connectReader:name];
}

#pragma mark show help info
- (IBAction)helpButtonClick:(id)sender {
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self performSegueWithIdentifier:@"operation" sender:nil];
    //    });
    //
    //    return;
    
    [UIView animateWithDuration:0.5 animations:^{
        _helpView.frame = CGRectMake(0, 0, screenW, screenH);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
//    [self startRefreshThread];
}

-(void)viewWillDisappear:(BOOL)animated
{
    myobject = nil;
    [_deviceList removeAllObjects];
    
    for (UIView *view in _scanDeviceListView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isSelf = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isSelf animated:YES];
}

//start a thread,every 10 second to refresh bluetooth device list
- (void)startRefreshThread
{
    [NSThread detachNewThreadSelector:@selector(autoRefresh) toTarget:self withObject:nil];
}

- (void)autoRefresh
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
}

//restart bluetooth scan
- (void)refresh
{
    NSLog(@"refresh");

    dispatch_async(dispatch_get_main_queue(), ^{
        [self clearAllReader];
    });
    
    SCardReleaseContext(gContxtHandle);
    sleep(1);
    gContxtHandle = 0;
    SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
    
    interface = [[ReaderInterface alloc] init];
    [interface setAutoPair:_autoConnect];
    [interface setDelegate:self];
}
@end
