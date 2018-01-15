//
//  OperationViewController.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "OperationViewController.h"
#import "CollectionViewCell.h"
#import "DeviceInfoTableViewController.h"
#import "TabbarViewController.h"
#import "CommandView.h"
#import "Tools.h"
#import "hex.h"
#import "winscard.h"
#import "ScanDeviceController.h"
#import "ft301u.h"
#import "ReaderInterface.h"

#define KeyboardBottomOriginalConstraint -49
#define TabbarHeight 49
#define PickerViewHeight 200

@interface OperationViewController ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, TabBarControllerDelegate, CommandCellClickDelegate, ReaderInterfaceDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewTopConstraint;

@property (weak, nonatomic) IBOutlet UITextView *logView;
@property (weak, nonatomic) IBOutlet UITextField *apduTextField;

@property (nonatomic, weak) UISwitch *cardState;
@property (nonatomic, weak) CommandView *commandView;
@end

static id myobject;
extern SCARDCONTEXT gContxtHandle;

@implementation OperationViewController
{
    NSArray *_array;
    NSArray *_commandArray;
    BOOL _isPickerViewShow;
    BOOL _isKeyboardShow;
    long iRet;
    NSString *_deviceName;
    SCARDHANDLE  gCardHandle;
    ReaderInterface *interface;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myobject = self;
    _isKeyboardShow = NO;
    _isPickerViewShow = NO;
    _array = [[Tools shareTools] apduArray];
    _commandArray = [[Tools shareTools] commandArray];
    
    TabbarViewController *tabbarVC = (TabbarViewController *)self.tabBarController;
    tabbarVC.myDelegate  = self;
    _deviceName = tabbarVC.deviceName;
    
    interface = [[ReaderInterface alloc] init];
    [interface setDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _logView.layoutManager.allowsNonContiguousLayout = NO;
    _logView.delegate = self;
    
    [self setupNavigation];
    [self registerKeyboardNotification];
    //connect reader
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self connectDeviceWithName:_deviceName];
    });
}

-(void)connectDeviceWithName:(NSString *)deviceName
{
    [[Tools shareTools] showMsg:@"connecting device..."];
    DWORD dwActiveProtocol = -1;
    NSInteger ret = SCardConnect(gContxtHandle, [deviceName UTF8String], SCARD_SHARE_SHARED,SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1, &gCardHandle, &dwActiveProtocol);
    [[Tools shareTools] hideMsgView];
    
    if(ret != 0){
        NSString *errorMsg = [NSString stringWithFormat:@"connect device error: %08x",ret];
        [self showMsg:errorMsg];
        return;
    }
    
    [self showMsg:[NSString stringWithFormat:@"connect %@ success", deviceName]];
}

- (IBAction)segmentedControlClick:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            [self connectDeviceWithName:_deviceName];
            break;
        case 1:
            [self closeTheDevice:_deviceName];
            break;
        default:
            break;
    }
}

-(void)closeTheDevice:(NSString *)deviceName
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[Tools shareTools] showMsg:@"disconnect device..."];
        SCardDisconnect(gCardHandle, SCARD_UNPOWER_CARD);
        [[Tools shareTools] hideMsgView];
    });
}

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
        
        _apduTextField.text = _array[0];
        
        self.pickerViewTopConstraint.constant = -PickerViewHeight - TabbarHeight;
        self.keyboardBottomConstraint.constant = -PickerViewHeight + KeyboardBottomOriginalConstraint;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)sendApduBtnClick:(id)sender {
    
    NSString *command = _apduTextField.text;
    [self showMsg:[@"Send command :" stringByAppendingString:command]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self sendCommand:command];
    });
}

/**
 *  send data
 */
-(long)sendCommand:(NSString *)apdu
{
    unsigned  int capdulen;
    unsigned char capdu[64];
    memset(capdu, 0, 64);
    unsigned char resp[64];
    memset(resp, 0, 64);
    unsigned int resplen = sizeof(resp) ;
    
    //1.judge apdu length
    if(apdu.length < 5  )
    {
        [self showMsg:@"invalid APUD"];
        return SCARD_E_INVALID_PARAMETER;
    }
    
    //2.change the format of data
    NSData *apduData =[hex hexFromString:apdu];
    [apduData getBytes:capdu length:apduData.length];
    capdulen = (unsigned int)[apduData length];
    
    //3.send data
    SCARD_IO_REQUEST pioSendPci;
    iRet = SCardTransmit(gContxtHandle, &pioSendPci, (unsigned char*)capdu, capdulen, NULL, resp, &resplen);
    if (iRet != 0) {
        [self showMsg:[NSString stringWithFormat:@"%@%08lx\n",NSLocalizedString(@"Rec:", nil),iRet]];
    }else {
        NSMutableData *RevData = [NSMutableData data];
        [RevData appendBytes:resp length:resplen];
        [self showMsg:[NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"Rec:", nil),[RevData description]]];
    }
    
    return iRet;
}

#pragma mark TabBarControllerDelegate
-(void)tabbarButtonClick
{
    CommandView *commandView = [[CommandView alloc] init];
    commandView.frame = [UIScreen mainScreen].bounds;
    commandView.myDelegate = self;
    commandView.commandArray = [[Tools shareTools] commandArray];
    _commandView = commandView;
    [self.view.window addSubview:commandView];
}

#pragma mark CommandCellClickDelegate
-(void)didSelectCellAtIndexPath:(NSInteger)row
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            [_commandView removeFromSuperview];
        });

        if (row == 0) {
            [self readUID];
        }else if(row == 1){
            [self writeFlash];
        }else{
            [self readFlash];
        }
    });
}

-(void)readUID
{
    char buffer[20] = {0};
    unsigned int length = sizeof(buffer);
    iRet = FtGetDeviceUID(gContxtHandle, &length, buffer);
    if(iRet != 0 ){
        NSString *errorMsg = [NSString stringWithFormat:@"readUID error: %08x",iRet];
        [self showMsg:errorMsg];
    }else {
        NSData *temp = [NSData dataWithBytes:buffer length:length];
        [self showMsg:[NSString stringWithFormat:@"UID:%@\n", temp]];
    }
}

-(void)writeFlash
{
    NSData *fileData = [[Tools shareTools] readFileContent:@"flash.txt"];
    if ([fileData length] == 0) {
        [self showMsg:@"flash data is nil"];
        return;
    }
    
    if ([fileData length] == 0) {
        [self showMsg:@"flash data is nil"];
        return;
    }
    
    unsigned char buffer[1024] = {0};
    unsigned int length = 0;
    
    length = (unsigned int)fileData.length;
    
    iRet = filterStr((char *)[fileData bytes], length);
    if (iRet != 0) {
        [self showMsg: @"the format of flash data error"];
        return;
    }
    
    length = length/2;
    StrToHex(buffer, (char *)[fileData bytes], length);
    
    iRet = FtWriteFlash(gContxtHandle, 0, length, buffer);
    if(iRet != 0 ){
        [self showMsg:@"writeFlash ERROR"];
    }else {
        [self showMsg:@"writeFlash SUCCESS"];
    }
}

-(void)readFlash
{
    unsigned char buffer[256] = {0};
    unsigned int length = 255;
    iRet = FtReadFlash(gContxtHandle, 0, &length, buffer);
    if(iRet != 0 ){
        [self showMsg:@"readFlash Error"];
    }else {
        NSData *temp = [NSData dataWithBytes:buffer length:length];
        [self showMsg:[NSString stringWithFormat:@"Flash: %@\n", temp]];
    }
}

#pragma pickerView delegate
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.apduTextField.text = _array[row];
    });
}

#pragma mark setupNavigation
-(void)setupNavigation
{    
    UISwitch *cardState = [[UISwitch alloc] init];
    _cardState = cardState;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cardState];
}

#pragma mark keyboard notification

-(void)registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification
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
    
    self.keyboardBottomConstraint.constant = -keyboard;

    if(_isPickerViewShow){
        self.pickerViewTopConstraint.constant = 0;
        _isPickerViewShow = NO;
    }
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITextfieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)showMsg:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *log = _logView.text;
        NSString *tempMsg = [msg stringByAppendingString:@"\n"];
        [_logView setText:[log stringByAppendingString:tempMsg]];
        NSInteger count = _logView.text.length;
        [_logView scrollRangeToVisible:NSMakeRange(0, count)];
    });
}

-(void)clearLog
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_logView setText:@""];
    });
}

#pragma mark ReaderInterfaceDelegate

- (void) findPeripheralReader:(NSString *)readerName
{
    [self showMsg:[NSString stringWithFormat:@"find reader: %@", readerName]];
}

- (void) readerInterfaceDidChange:(BOOL)attached
{
    [self showMsg:[NSString stringWithFormat:@"reader status did change: %zd", attached]];
}

- (void) cardInterfaceDidDetach:(BOOL)attached
{
    [self showMsg:[NSString stringWithFormat:@"card status did change: %zd", attached]];
}

@end
