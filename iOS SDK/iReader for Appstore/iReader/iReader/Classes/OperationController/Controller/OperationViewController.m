//
//  OperationViewController.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "OperationViewController.h"
#import "Tools.h"
#import "hex.h"
#import "winscard.h"
#import "ft301u.h"
#import "ReaderInterface.h"
#import "ListView.h"
#import "DeviceInfoModel.h"
#import "CollectionViewCell.h"
#import "ScanDeviceController.h"
#import "DeviceInfoTableViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "WifiTransferViewController.h"

#define KeyboardBottomOriginalConstraint 10
#define TabbarHeight 49
#define PickerViewHeight 200

typedef NS_ENUM(NSInteger, FTReaderType) {
    FTReaderiR301 = 0,
    FTReaderbR301 = 1,
    FTReaderbR301BLE = 2,
    FTReaderbR500 = 3,
    FTReaderBLE = 4
};

typedef NS_ENUM(NSInteger, FTCardStatus) {
    FTCardStatusDefault = 0,
    FTCardStatusPresent,
    FTCardStatusExcute,
    FTCardStatusReady,
    FTCardStatusError
};

@interface OperationViewController ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ReaderInterfaceDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MFMailComposeViewControllerDelegate, ListViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITextView *logView;
@property (weak, nonatomic) IBOutlet UITextField *apduTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *deviceStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *readerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *batteryImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottonConstraint;

@end

static id myobject;
extern SCARDCONTEXT gContxtHandle;
extern SCARDHANDLE gCardHandle;
extern NSString *gBluetoothID;

@implementation OperationViewController
{
    NSArray *_array;
    BOOL _isPickerViewShow;
    BOOL _isKeyboardShow;
    LONG iRet;
    ReaderInterface *interface;
    
    NSArray *_readerCMDArray;
    NSArray *_readerOperationArray;
    
    NSMutableArray *_deviceInfoArray;
    NSMutableArray *_readerList;
    BOOL m_bIsGetksn;
    
    FTReaderType _readerType;
    
    NSString *_path;
    NSFileHandle *_handle;
    
    BOOL _isOpen;
    ListView *_listView;
}

#pragma mark - button click action

- (IBAction)displayCommandBtnClick:(id)sender {
    
    if(_isPickerViewShow){
        _isPickerViewShow = NO;
        self.pickerViewTopConstraint.constant = 0;
        self.keyboardBottomConstraint.constant = KeyboardBottomOriginalConstraint;
    }else{
        _isPickerViewShow = YES;
        
        if(_isKeyboardShow){
            [_apduTextField resignFirstResponder];
        }
        
        if (_apduTextField.text.length == 0 || _apduTextField.text == nil) {
            _apduTextField.text = _array[0];
        }
        
//        self.pickerViewTopConstraint.constant = -PickerViewHeight;
        self.keyboardBottomConstraint.constant = PickerViewHeight + KeyboardBottomOriginalConstraint;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)sendApduBtnClick:(id)sender {
    NSString *command = _apduTextField.text;
    
    if ([command hasPrefix:@"test_"]) {
        [self privateTest:command];
        return;
    }
    
    [self showMsg:[@"Send:" stringByAppendingString:command]];
    
    if(_isPickerViewShow){
        _isPickerViewShow = NO;
        self.pickerViewTopConstraint.constant = 0;
        self.keyboardBottomConstraint.constant = KeyboardBottomOriginalConstraint;
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self updateDeviceStatusImage:FTCardStatusExcute];
        
        if ([self sendCommand:command] == 0) {
            [self updateDeviceStatusImage:FTCardStatusReady];
        }else {
            [self updateDeviceStatusImage:FTCardStatusError];
        }
    });
}

//exchange reader cmd and card cmd
- (IBAction)exchangeCMD:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if(_isKeyboardShow){
        [_apduTextField resignFirstResponder];
    }
    
    if(_isPickerViewShow){
        _isPickerViewShow = NO;
        self.pickerViewTopConstraint.constant = 0;
        self.keyboardBottomConstraint.constant = KeyboardBottomOriginalConstraint;
    }
    
    //display card cmd
    if (control.selectedSegmentIndex == 0) {
        _inputViewLeadingConstraint.constant = 0;
    }else {
        _inputViewLeadingConstraint.constant = -screenW;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

//get reader info
- (IBAction)deviceInfoButtonClick:(id)sender {

    NSArray *data = @[@"device info", @"wifi"];
    UIButton *button = (UIButton *)sender;
    NSInteger listViewW = 110;
    NSInteger listViewH = data.count * 44;
    NSInteger listViewY = button.frame.origin.y + 40;
    NSInteger listViewX = [UIScreen mainScreen].bounds.size.width - listViewW - 10;
    
    _listView = [[ListView alloc] init];
    _listView.frame = CGRectMake(listViewX, listViewY, listViewW, listViewH);
    _listView.delegate = self;
    _listView.dataSource = data;
    [self.view.window addSubview:_listView];
}

//power on card
- (IBAction)connectCard:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[Tools shareTools] showMsg:@"Connect Card"];
    
        DWORD dwActiveProtocol = -1;
        LONG ret = SCardConnect(gContxtHandle, [self.readerName UTF8String], SCARD_SHARE_SHARED,SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1, &gCardHandle, &dwActiveProtocol);

        if(ret != 0){
            [[Tools shareTools] hideMsgView];
            NSString *errorMsg = [[Tools shareTools] mapErrorCode:ret];
            [self showMsg:errorMsg];
            [self updateDeviceStatusImage:FTCardStatusError];
            return;
        }

        [self showMsg:[NSString stringWithFormat:@"Card connected"]];

        //get card ATR
        unsigned char patr[33];
        DWORD len = sizeof(patr);
        ret = SCardGetAttrib(gCardHandle,0, patr, &len);
        [[Tools shareTools] hideMsgView];
        
        if(ret != 0){
            NSString *errorMsg = [[Tools shareTools] mapErrorCode:ret];
            [self showMsg:errorMsg];
            [self updateDeviceStatusImage:FTCardStatusError];
            return;
        }
        
        [self updateDeviceStatusImage:FTCardStatusReady];
        
        NSMutableData *tmpData = [NSMutableData data];
        [tmpData appendBytes:patr length:len];
        NSString* dataString= [NSString stringWithFormat:@"%@",tmpData];
        NSRange begin = [dataString rangeOfString:@"<"];
        NSRange end = [dataString rangeOfString:@">"];
        NSRange range = NSMakeRange(begin.location + begin.length, end.location- begin.location - 1);
        dataString = [dataString substringWithRange:range];
        [self showMsg:[NSString stringWithFormat:@"ATR:%@",dataString]];
    });
}

//power off card
- (IBAction)disconnectCard:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[Tools shareTools] showMsg:@"Disconnect card"];
        SCardDisconnect(gCardHandle, SCARD_UNPOWER_CARD);
        [[Tools shareTools] hideMsgView];
        [self showMsg:[NSString stringWithFormat:@"Card disconnect"]];
        [self updateDeviceStatusImage:FTCardStatusDefault];
    });
}

- (IBAction)releaseContext:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[Tools shareTools] showMsg:@"Release context"];
        SCardReleaseContext(gContxtHandle);
        gContxtHandle = 0;
        [[Tools shareTools] hideMsgView];
        [self showMsg:[NSString stringWithFormat:@"Release context"]];
        [self updateDeviceStatusImage:FTCardStatusDefault];
    });
}

#pragma mark - PCSC function invoke
-(void)getReaderName
{
    unsigned int length = 0;
    char buffer[20] = {0};
    LONG ret = FtGetReaderName(gContxtHandle, &length, buffer);
    if (ret != SCARD_S_SUCCESS || length == 0) {
        NSString *errorMsg = [[Tools shareTools] mapErrorCode:ret];
        [self showMsg:errorMsg];
        return;
    }
    
    NSString *readerName = [NSString stringWithUTF8String:buffer];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.readerNameLabel.text = readerName;
    });
    
    if ([readerName isEqualToString:@"bR301"]) {
        _readerType = FTReaderbR301;
        
    }else if ([readerName isEqualToString:@"iR301"]) {
        _readerType = FTReaderiR301;
        
    }else if ([readerName isEqualToString:@"bR301BLE"]) {
        _readerType = FTReaderbR301BLE;
        
    }else if ([readerName isEqualToString:@"bR500"]) {
        _readerType = FTReaderbR500;
    }
    
    [self updateDeviceStatusImage:FTCardStatusDefault];
}

//get connected reader list
- (NSArray *)listReader
{
    char mszReaders[128] = "";
    DWORD pcchReaders = -1;
    
    ULONG iRet = SCardListReaders(gContxtHandle, NULL, mszReaders, &pcchReaders);
    if(iRet != SCARD_S_SUCCESS)
    {
        return nil;
    }
    
    char tempReaderName[32] = {0};
    int tempIndex = 0;
    NSMutableArray *readerList = [NSMutableArray array];
    for (int index = 0; index < pcchReaders; index++) {
        if(mszReaders[index] != '\0'){
            tempReaderName[tempIndex] = mszReaders[index];
            tempIndex++;
            continue;
        }
        tempIndex = 0;
        NSString *device = [[NSString alloc] initWithCString:tempReaderName encoding:NSASCIIStringEncoding];
        if (device != nil) {
            if(![readerList containsObject:device]){
                [readerList addObject:device];
            }
            memset(tempReaderName, 0, sizeof(tempReaderName));
        }
    }
    
    return readerList;
}

//send command to card
- (long)sendCommand:(NSString *)apdu
{
    unsigned  int capdulen;
    unsigned char capdu[2048 + 128];
    memset(capdu, 0, 2048 + 128);
    unsigned char resp[2048 + 128];
    memset(resp, 0, 2048 + 128);
    unsigned int resplen = sizeof(resp) ;
    
    //1.judge apdu length
    if((apdu.length < 5)  || (apdu.length % 2 != 0))
    {
        [self showMsg:@"Invalid APDU"];
        return SCARD_E_INVALID_PARAMETER;
    }
    
    //2.change the format of data
    NSData *apduData =[hex hexFromString:apdu];
    [apduData getBytes:capdu length:apduData.length];
    capdulen = (unsigned int)[apduData length];
    
    if (![[Tools shareTools] isApduValid:capdu apduLen:capdulen]){
        [self showMsg:@"Invalid APDU"];
        return SCARD_E_INVALID_PARAMETER;
    }
    
    [self updateDeviceStatusImage:FTCardStatusExcute];
    
    //3.send data
    SCARD_IO_REQUEST pioSendPci;
    iRet = SCardTransmit(gContxtHandle, &pioSendPci, (unsigned char*)capdu, capdulen, NULL, resp, &resplen);
    if (iRet != 0) {
        [self showMsg:[[Tools shareTools] mapErrorCode:iRet]];
        [self updateDeviceStatusImage:FTCardStatusError];
    }else {
        NSMutableData *RevData = [NSMutableData data];
        [RevData appendBytes:resp length:resplen];
        NSString *str = [NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"Rev:", nil),[RevData description]];
        [self showMsg:str];
    }
    
    [self updateDeviceStatusImage:FTCardStatusReady];
    return iRet;
}

//read uid
- (void)readUID
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[Tools shareTools] showMsg:@"read UID"];
        char buffer[20] = {0};
        unsigned int length = sizeof(buffer);
        iRet = FtGetDeviceUID(gContxtHandle, &length, buffer);
        if(iRet != 0 ){
            NSString *errorMsg = [[[Tools shareTools] mapErrorCode:iRet] stringByAppendingString:@"\nThe bR301 and iR301 doesn't support UID function, to have support, please contact us directly."];
            [self showMsg:errorMsg];
        }else {
            NSData *temp = [NSData dataWithBytes:buffer length:length];
            [self showMsg:[NSString stringWithFormat:@"UID:%@\n", temp]];
        }
        [[Tools shareTools] hideMsgView];
    });
}

//write flash
- (void)writeFlash
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[Tools shareTools] showMsg:@"write flash"];
        
        NSData *fileData = [[Tools shareTools] readFileContent:@"flash.txt"];
        if ([fileData length] == 0) {
            [self showMsg:@"No data in flash.txt"];
            [[Tools shareTools] hideMsgView];
            return;
        }
        
        if ([fileData length] == 0) {
            [self showMsg:@"No data in flash.txt"];
            [[Tools shareTools] hideMsgView];
            return;
        }
        
        unsigned char buffer[1024] = {0};
        unsigned int length = 0;
        
        length = (unsigned int)fileData.length - 1;
        
        iRet = filterStr((char *)[fileData bytes], length);
        if (iRet != 0) {
            [self showMsg: @"Data format error in flash.txt"];
            [[Tools shareTools] hideMsgView];
            return;
        }
        
        length = length/2;
        StrToHex(buffer, (char *)[fileData bytes], length);
        
        iRet = FtWriteFlash(gContxtHandle, 0, length, buffer);
        if(iRet != 0 ){
            [self showMsg:[[Tools shareTools] mapErrorCode:iRet]];
        }else {
            [self showMsg:@"Write Flash Success"];
        }
        [[Tools shareTools] hideMsgView];
    });
}

//read flash
- (void)readFlash
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[Tools shareTools] showMsg:@"read flash"];
        unsigned char buffer[256] = {0};
        unsigned int length = 255;
        iRet = FtReadFlash(gContxtHandle, 0, &length, buffer);
        if(iRet != 0 ){
            [self showMsg:[[Tools shareTools] mapErrorCode:iRet]];
        }else {
            NSData *temp = [NSData dataWithBytes:buffer length:length];
            [self showMsg:[NSString stringWithFormat:@"Flash: %@\n", temp]];
        }
        [[Tools shareTools] hideMsgView];
    });
}

//read flash
- (void)autoOff
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        [[Tools shareTools] showMsg:@"reader auto off"];
        
        iRet = FT_AutoTurnOffReader(_isOpen);
        if(iRet != 0 ){
            [self showMsg:[[Tools shareTools] mapErrorCode:iRet]];
        }else {
            NSString *isopen = @"open";
            if (!_isOpen) {
                isopen = @"close";
            }
            [self showMsg:[NSString stringWithFormat:@"AutoTurnOffReader: %@", isopen]];
            
            _isOpen = !_isOpen;
        }
        
        [[Tools shareTools] hideMsgView];
    });
}

#pragma mark - ReaderInterfaceDelegate

- (void)findPeripheralReader:(NSString *)readerName
{
    [self showMsg:[NSString stringWithFormat:@"Find Reader: %@", readerName]];
}

- (void)readerInterfaceDidChange:(BOOL)attached bluetoothID:(NSString *)bluetoothID
{
    if (attached) {
        [self showMsg:@"Reader Connected"];
        gBluetoothID = bluetoothID;
    }else{
        [self showMsg:@"Reader Disconnected"];
        
        [self disconnectCard:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.batteryLabel.hidden = NO;
            self.batteryImage.hidden = NO;
            [self.navigationController popToViewController:self.rootVC animated:YES];
        });
    }
}

- (void)cardInterfaceDidDetach:(BOOL)attached
{
    if (attached) {
        
        [self updateDeviceStatusImage:FTCardStatusPresent];
        
        [self showMsg:@"Card present"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self connectCard:nil];
        });
        
    }else{
        [self updateDeviceStatusImage:FTCardStatusDefault];
        [self showMsg:@"Card absent"];
    }
}

-(void)didGetBattery:(NSInteger)battery
{
    NSLog(@"%@", [NSString stringWithFormat:@"battery - %zd%%", battery]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.batteryLabel.hidden = NO;
        self.batteryImage.hidden = NO;
        self.batteryLabel.text = [NSString stringWithFormat:@"%zd%%", battery];
    });
}

#pragma mark - private test

- (void)privateTest:(NSString *)command
{
    if ([command isEqualToString:@"test_battery"]) {
        [self batteryTest];
    }
}

-(void)batteryTest {
    while (1) {
        [self sendCommand:@"0084000008"];
    };
}

#pragma mark -
#pragma mark - below functions is all about user interface
#pragma mark - user interface
- (void)viewDidLoad {
    [super viewDidLoad];
    
    myobject = self;
    _isKeyboardShow = NO;
    _isPickerViewShow = NO;
    _isOpen = YES;
    
    NSArray *apdu1 = [[Tools shareTools] apduArray];
    NSArray *apdu2 = [[Tools shareTools] getAPDU];
    NSMutableArray *_arr = [NSMutableArray array];
    [_arr addObjectsFromArray:apdu1];
    [_arr addObjectsFromArray:apdu2];
    _array = [_arr copy];
    
    _readerCMDArray = @[@"Read Flash", @"Write Flash", @"Get UID", @"Auto Off"];
    _readerOperationArray = @[@"readFlash", @"writeFlash", @"readUID", @"autoOff"];
    
    _deviceInfoArray = [NSMutableArray array];
    _readerList = [NSMutableArray array];
    
    [self setupNavigationBar];
    
    _apduTextField.text = [_array firstObject];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    interface = [[ReaderInterface alloc] init];
    [interface setDelegate:self];
    
    //get reader name
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getReaderName];
    });
    
    if ([[Tools shareTools] iPhonexSerial]) {
        _inputViewBottonConstraint.constant = 20;
    }else {
        _inputViewBottonConstraint.constant = 0;
    }
    
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self setupCollectionView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _logView.layoutManager.allowsNonContiguousLayout = NO;
    _logView.delegate = self;
    
    [self registerKeyboardNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) setupNavigationBar{
    
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)setupCollectionView
{
    //set up collectionview
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 20;
    layout.itemSize = CGSizeMake(55, 55);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView.collectionViewLayout = layout;
}

- (void)updateDeviceStatusImage:(FTCardStatus)status
{
    NSString *readerType = @"";
    
    switch (_readerType) {
        case FTReaderbR301BLE:
            readerType = @"bR301BLE";
            break;
        case FTReaderbR500:
            readerType = @"bR500";
            break;
            
        case FTReaderbR301:
            readerType = @"bR301";
            break;
            
        case FTReaderiR301:
            readerType = @"iR301";
            break;
            
        default:
            break;
    }
    
    if (readerType.length == 0) {
        return;
    }
    
    NSString *cardStatus = @"";
    
    switch (status) {
        case FTCardStatusDefault:
            cardStatus = @"CardDefault";
            break;
            
        case FTCardStatusReady:
            cardStatus = @"CardReady";
            break;
            
        case FTCardStatusError:
            cardStatus = @"CardError";
            break;
            
        case FTCardStatusExcute:
            cardStatus = @"CardExcute";
            break;
            
        case FTCardStatusPresent:
            cardStatus = @"CardPresent";
            break;
            
        default:
            break;
    }
    
    if (cardStatus.length == 0) {
        return;
    }
    
    NSString *name = [NSString stringWithFormat:@"%@-%@", readerType, cardStatus];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.deviceStatusImageView.image = [UIImage imageNamed:name];
    });
}

- (void)showMsg:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *log = _logView.text;
        if (log.length > 1000) {
            log = @"";
        }
        NSString *tempMsg = [msg stringByAppendingString:@"\n"];
        [_logView setText:[log stringByAppendingString:tempMsg]];
        NSInteger count = _logView.text.length;
        [_logView scrollRangeToVisible:NSMakeRange(0, count)];
    });
}

- (void)clearLog
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_logView setText:@""];
    });
}

#pragma mark - listview delegate
-(void)didSelectedRow:(NSInteger) row
{
    [_listView hideListView];
    
    if(row == 0) {
        DeviceInfoTableViewController *infoVC = [[DeviceInfoTableViewController alloc] init];
        infoVC.readerName = self.readerName;
        [self.navigationController pushViewController:infoVC animated:YES];
        return;
    }
    
    if (row == 1) {
        WifiTransferViewController *wifiVC = [[WifiTransferViewController alloc] init];
        [self.navigationController pushViewController:wifiVC animated:YES];
        return;
    }
}

#pragma mark - collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _readerCMDArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.title = _readerCMDArray[indexPath.row];
    cell.imageName = _readerOperationArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ope = _readerOperationArray[indexPath.row];
    
    [self performSelector:NSSelectorFromString(ope)];
}

#pragma mark - pickerView delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _array.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED
{
    return _array[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.apduTextField.text = _array[row];
    });
}

#pragma mark - keyboard notification
- (void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if(_isKeyboardShow){
        return;
    }
    
    _isKeyboardShow = YES;
    
    NSDictionary *userInfo = notification.userInfo;
    
    //keyboard show animation
    NSString *strAnimationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDuration = strAnimationDuration.doubleValue;
    
    //keyboard frame
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect rect = value.CGRectValue;
    NSInteger keyboard = rect.size.height;
    
    self.keyboardBottomConstraint.constant = keyboard + KeyboardBottomOriginalConstraint;
    
    if(_isPickerViewShow){
        self.pickerViewTopConstraint.constant = 0;
        _isPickerViewShow = NO;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _isKeyboardShow = NO;
    
    NSDictionary *userInfo = notification.userInfo;
    
    //keyboard show animation
    NSString *strAnimationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    CGFloat animationDuration = strAnimationDuration.doubleValue;
    
    if(_isPickerViewShow){
        return;
    }
    
    self.keyboardBottomConstraint.constant = KeyboardBottomOriginalConstraint;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isSelf = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isSelf animated:YES];
}

#pragma mark - send log email
//email log to feitian
- (IBAction)emailLog:(id)sender {
    [self sendMailInApp];
}

//get reader info
- (NSString *)getReaderInfo {
    //SDK version
    char libVersion[10] = {0};
    FtGetLibVersion(libVersion);
    NSString *strLibVersion = [NSString stringWithFormat:@"SDK Version: %s", libVersion];
    //Firmware Revision
    char firmwareRevision[32] = {0};
    char hardwareRevision[32] = {0};
    if (FtGetDevVer(gContxtHandle, firmwareRevision, hardwareRevision) != 0) {
        return strLibVersion;
    }
    
    NSMutableString *str = [NSMutableString stringWithString:strLibVersion];
    if(strlen(firmwareRevision) > 0) {
        [str appendString:@"\n"];
        [str appendString:[NSString stringWithFormat:@"Firmware Version: %s", firmwareRevision]];
    }
    
    if (strlen(hardwareRevision) > 0) {
        [str appendString:@"\n"];
        [str appendString:[NSString stringWithFormat:@"Hardware Version: %s", hardwareRevision]];
    }
    
    return str;
}

//激活邮件功能
- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self showMsg:@"Current system version does not support send mail within applications,you can instead with mainlto."];
        return;
    }
    if (![mailClass canSendMail]) {
        [self showMsg:@"pelase set mail account."];
        return;
    }
    [self displayMailPicker];
}

//take screen shot
- (UIImage *)takeScreenShot {
    UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    [mailPicker setSubject: @"feedback"];
    NSArray *toRecipients = [NSArray arrayWithObject: @"ben@ftsafe.com"];
    [mailPicker setToRecipients: toRecipients];
    
    UIImage *addPic = [self takeScreenShot];
    NSData *imageData = UIImagePNGRepresentation(addPic);
    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"screenShot.png"];
    
    NSString *file = [Tools shareTools].logFilePath;
    NSData *data = [NSData dataWithContentsOfFile:file];
    [mailPicker addAttachmentData: data mimeType: @"" fileName: @"log.txt"];
    
    [mailPicker setMessageBody:[self getReaderInfo] isHTML:NO];
    
    [self presentViewController:mailPicker animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultSent:
            msg = @"send log mail success";
            break;
        case MFMailComposeResultFailed:
            msg = @"send log mail failed";
            break;
        default:
            msg = @"";
            break;
    }
    [self showMsg:msg];
}

@end
