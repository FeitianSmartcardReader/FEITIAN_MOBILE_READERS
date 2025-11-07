//
//  OperationViewController.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "OperationViewController.h"
#import "Tools.h"
#import "winscard.h"
#import "ft301u.h"
#import "ReaderInterface.h"
#import "DeviceInfoModel.h"
#import "CollectionViewCell.h"
#import "ScanDeviceController.h"
#import "DeviceInfoTableViewController.h"
#import "WifiTransferViewController.h"
//#import "ParseScript.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "QCPopView.h"

#define KeyboardBottomOriginalConstraint 10
#define TabbarHeight 49
#define PickerViewHeight 200

@interface OperationViewController ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ReaderInterfaceDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MFMailComposeViewControllerDelegate,QCPopViewDelegate>

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
@property (weak, nonatomic) IBOutlet UIPickerView *GPickerView;

@property (weak, nonatomic) IBOutlet UILabel *selectslotname;

@property (nonatomic, strong) QCPopView *QCPopView;

@property (nonatomic, copy) NSString *gsleltslotnamestr;

@property(nonatomic,assign)NSInteger  shownametag;
@property(nonatomic,assign)NSInteger  inputcommandtype;
@end

static id myobject;
extern SCARDCONTEXT gContxtHandle;
extern SCARDHANDLE gCardHandle;
extern NSString *gBluetoothID;

@implementation OperationViewController
{
    NSArray *_array;
    NSArray *_array2;
    
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
    
    BOOL _batteryTestDone;
    
    NSString *_name;
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
            if(self.inputcommandtype == 0)
            {
            _apduTextField.text = _array[0];
            }
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
    
//    if ([command hasPrefix:@"test_"]) {
//        [self privateTest:command];
//        return;
//    }
    
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
        
        self.inputcommandtype = 0;
        _apduTextField.text = [_array firstObject];
        [self.GPickerView reloadAllComponents];
        
        
    }else {
        _inputViewLeadingConstraint.constant = -screenW;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

//get reader info
- (IBAction)deviceInfoButtonClick:(id)sender {
    
    DeviceInfoTableViewController *infoVC = [[DeviceInfoTableViewController alloc] init];
    infoVC.readerName = self.readerName;
    infoVC.readerType = _readerType;
    [self.navigationController pushViewController:infoVC animated:YES];
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
        
//        NSString* dataString= [NSString stringWithFormat:@"%@",tmpData];
//       NSRange begin = [dataString rangeOfString:@"{"];
//                      NSRange end;
//                      if(begin.location == 0)
//                      {
//                          end = [dataString rangeOfString:@"}"];
//                      }else
//                      {
//                        begin =[dataString rangeOfString:@"<"];
//                          end = [dataString rangeOfString:@">"];
//
//                      }
//
//
//        NSRange range = NSMakeRange(begin.location + begin.length, end.location- begin.location - 1);
//        dataString = [dataString substringWithRange:range];
        
        NSMutableString *deviceTokenString = [NSMutableString string];
        const char *bytes = (const char *)tmpData.bytes;
        NSInteger count = tmpData.length;
        for (int i = 0; i < count; i++) {
            if((i+1)%4 == 0)
            {
                [deviceTokenString appendFormat:@"%02x ", bytes[i]&0x000000FF];
            }else
            {
                  [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
            }
        }
        
        [self showMsg:[NSString stringWithFormat:@"ATR:%@",deviceTokenString]];
        
    });
}

//power off card
- (IBAction)disconnectCard:(id)sender {
    [[Tools shareTools] showMsg:@"Disconnect card"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        LONG ret = SCardDisconnect(gCardHandle, SCARD_UNPOWER_CARD);
        NSLog(@"SCardDisconnect-------ret--%d",ret);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[Tools shareTools] hideMsgView];
            [self showMsg:[NSString stringWithFormat:@"Card disconnect"]];
            [self updateDeviceStatusImage:FTCardStatusDefault];
            gCardHandle = 0;
        });
    });
}

- (IBAction)releaseContext:(id)sender {
    [[Tools shareTools] showMsg:@"Release context"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        SCardReleaseContext(gContxtHandle);
        gContxtHandle = 0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[Tools shareTools] hideMsgView];
            [self showMsg:[NSString stringWithFormat:@"Release context"]];
            [self updateDeviceStatusImage:FTCardStatusDefault];
        });
    });
}
- (IBAction)selectslot:(id)sender {
    
    //initialize
    _QCPopView = [[QCPopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
    //delegate
    _QCPopView.QCPopViewDelegate = self;
    //set data
    [_QCPopView showThePopViewWithArray:self.gslotArray];
    
}

-(void)getTheButtonTitleWithIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *buttonStr = self.gslotArray[indexPath.row];
    NSLog(@"OperationViewController::getTheButtonTitleWithIndexPath--------%@",buttonStr);
//    [_testButton setTitle:buttonStr forState:UIControlStateNormal];
    self.gsleltslotnamestr= buttonStr;
    self.selectslotname.text = buttonStr;
    [_QCPopView dismissThePopView];
}


#pragma mark - PCSC function invoke
-(void)getReaderName
{
   
   //zxf
    if(self.shownametag != 1)
    {
        return;
    
    }
    
    
    
    unsigned int length = 0;
    char buffer[100] = {0};
//
    LONG ret = FtGetReaderName(gContxtHandle, &length, buffer);
//
//
//
    if (ret != SCARD_S_SUCCESS || length == 0) {
        NSString *errorMsg = [[Tools shareTools] mapErrorCode:ret];
        [self showMsg:errorMsg];
        return;
    }
    //zxf br301 power on card
    _name = [NSString stringWithUTF8String:buffer];

    NSLog(@"OperationViewController::getReaderName------>%@", _name);
    
    
    if(([FTDeviceType getDeviceType] & LINE_TYPEC) != LINE_TYPEC)
    {
        if(![_name isEqualToString:@"iR301"])
        {
            SCARD_READERSTATE rs[1];

            rs[0].szReader = [_name UTF8String];
            rs[0].dwCurrentState = SCARD_STATE_UNAWARE;
            rs[0].cbAtr = 0;
            rs[0].dwEventState = SCARD_STATE_UNAWARE;
            rs[0].pvUserData = NULL;
            //        DWORD dwActiveProtocol;
            LONG rv;
            rv = SCardGetStatusChange(gContxtHandle, INFINITE, rs, 1);

            if((rv == SCARD_S_SUCCESS) && (rs[0].dwEventState & SCARD_STATE_PRESENT))
            {
                [self showMsg:@"Card present"];
                [self connectCard:nil];
            }else
            {
                [self showMsg:@"Card absent"];
            }
        }
    }
    
//    NSString *namelabelstr = [NSString stringWithFormat:@"%@",_name];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.readerNameLabel.text = _name;
////        self.readerNameLabel.text = @"123";
//    });
    
    self.shownametag = 2;
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

    if(self.inputcommandtype == 0)
    {
    [self showMsg:[@"Send:" stringByAppendingString:apdu]];
    
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
    NSData *apduData = [[Tools shareTools] hexFromString:apdu];
    [apduData getBytes:capdu length:apduData.length];
    capdulen = (unsigned int)[apduData length];
    
    if (![[Tools shareTools] isApduValid:capdu apduLen:capdulen]){
        [self showMsg:@"Invalid APDU"];
        return SCARD_E_INVALID_PARAMETER;
    }
    
    [self updateDeviceStatusImage:FTCardStatusExcute];
        
    if(([FTDeviceType getDeviceType] & LINE_TYPEC) == LINE_TYPEC)
    {
//        NSString * slotname = self.gslotArray[0];
        
        NSString * slotname =  self.gsleltslotnamestr;
        
        [interface selectSlotname:slotname];
        
    }
        
        
    
    //3.send data
    SCARD_IO_REQUEST pioSendPci;
    iRet = SCardTransmit(gCardHandle, &pioSendPci, (unsigned char*)capdu, capdulen, NULL, resp, &resplen);
    if (iRet != 0) {
        
//        NSString * str = [[Tools shareTools] mapErrorCode:iRet];
//        NSLog(@"-------->>>>%@",str);
        [self showMsg:[[Tools shareTools] mapErrorCode:iRet]];
        [self updateDeviceStatusImage:FTCardStatusError];
    }else {
        NSMutableData *RevData = [NSMutableData data];
        [RevData appendBytes:resp length:resplen];
        
        NSMutableString *deviceTokenString = [NSMutableString string];
        const char *bytes = (const char *)RevData.bytes;
        NSInteger count = RevData.length;
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
                          
            NSString *str1 = [NSString stringWithFormat:@"<%@>", deviceTokenString];
        

        NSString *str = [NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"Rev:", nil),str1];
        [self showMsg:str];
    }
    
    [self updateDeviceStatusImage:FTCardStatusReady];
    return iRet;
        
    }else
    {
        NSString * str1=@"";
        unsigned  int capdulen;
        unsigned char capdu[2048 + 128];
        memset(capdu, 0, 2048 + 128);
        unsigned char resp[2048 + 128];
        memset(resp, 0, 2048 + 128);
        unsigned int resplen = sizeof(resp) ;
        DWORD DReturn=0;
        [self showMsg:[@"Send:" stringByAppendingString:apdu]];
        DWORD  dwControlCode = 3549;
        NSData *apduData = [[Tools shareTools] hexFromString:apdu];
        [apduData getBytes:capdu length:apduData.length];
        capdulen = (unsigned int)[apduData length];
        
          iRet = SCardControl(gCardHandle, dwControlCode,
                          capdu, capdulen,
                           resp, resplen, &DReturn);
        
        NSLog(@"iRet---->%d",iRet);
        
        if (iRet != 0) {
            [self showMsg:[[Tools shareTools] mapErrorCode:iRet]];
        }else {
            NSMutableData *RevData = [NSMutableData data];
            [RevData appendBytes:resp length:DReturn];
            
            NSMutableString *deviceTokenString = [NSMutableString string];
            const char *bytes = (const char *)RevData.bytes;
            NSInteger count = RevData.length;
            for (int i = 0; i < count; i++) {
                if((i+1)%4 == 0) {
                    if(i+1 == count) {
                        [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
                    }else {
                        [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
                    }
                }else {
                    [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
                }
            }
            
            str1 = [NSString stringWithFormat:@"%@", deviceTokenString];
            NSString *str = [NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"Rev:", nil),str1];
            [self showMsg:str];
        }
        
        return  iRet;
        
    }
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
            NSMutableString *deviceTokenString = [NSMutableString string];
                   const char *bytes = (const char *)temp.bytes;
                   NSInteger count = temp.length;
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
                   
                    NSString *str = [NSString stringWithFormat:@"<%@>", deviceTokenString];
            
            [self showMsg:[NSString stringWithFormat:@"UID:%@\n", str]];
        }
        [[Tools shareTools] hideMsgView];
    });
}



-(void)Escapecmd
{
    
    self.inputcommandtype = 1;
    _apduTextField.text = [_array2 firstObject];
//    _apduTextField.text = @"";
    _apduTextField.placeholder = @"Please input Escape CMD";
    [self.GPickerView reloadAllComponents];
    
    
    
    NSLog(@"escapecmd");
    
    if(_isKeyboardShow){
        [_apduTextField resignFirstResponder];
    }

    if(_isPickerViewShow){
        _isPickerViewShow = NO;
        self.pickerViewTopConstraint.constant = 0;
        self.keyboardBottomConstraint.constant = KeyboardBottomOriginalConstraint;
    }

    //display card cmd

    _inputViewLeadingConstraint.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];

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
        
        iRet = [[Tools shareTools] filterStr:(char *)[fileData bytes] len:length];
        if (iRet != 0) {
            [self showMsg: @"Data format error in flash.txt"];
            [[Tools shareTools] hideMsgView];
            return;
        }
        
        length = length/2;
//        StrToHex(buffer, (char *)[fileData bytes], length);
        [[Tools shareTools] StrToHex:buffer src:(char *)[fileData bytes] len:length];
        
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
        unsigned char length = 255;
        iRet = FtReadFlash(gContxtHandle, 0, &length, buffer);
        if(iRet != 0 ){
            [self showMsg:[[Tools shareTools] mapErrorCode:iRet]];
        }else {
            NSData *temp = [NSData dataWithBytes:buffer length:length];
            NSMutableString *deviceTokenString = [NSMutableString string];
             const char *bytes = (const char *)temp.bytes;
             NSInteger count = temp.length;
             for (int i = 0; i < count; i++) {
                 if((i+1)%4 == 0)
                 {
                     [deviceTokenString appendFormat:@"%02x ", bytes[i]&0x000000FF];
                 }else
                 {
                       [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
                 }
             }
            [self showMsg:[NSString stringWithFormat:@"Flash: <%@>\n", deviceTokenString]];
            
            
//            [self showMsg:[NSString stringWithFormat:@"Flash: %@\n", temp]];
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

- (void)readerInterfaceDidChange:(BOOL)attached bluetoothID:(NSString *)bluetoothID andslotnameArray:(NSArray *)slotArray
{
    if (attached) {
        [self showMsg:@"Reader Connected"];
        gBluetoothID = bluetoothID;
        self.gslotArray = slotArray;
    } else {
        [self showMsg:@"Reader Disconnected"];
        [self disconnectCard:nil];
        _batteryTestDone = YES;
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:autoPowerOffKey];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.batteryLabel.hidden = NO;
            self.batteryImage.hidden = NO;
            self.batteryLabel.text =@"";
//            [self.navigationController popToViewController:self.rootVC animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }
}

- (void)cardInterfaceDidDetach:(BOOL)attached slotname:(NSString *)slotname
{
    if (attached) {
        
        [self updateDeviceStatusImage:FTCardStatusPresent];
        _batteryTestDone = NO;
        if(slotname.length>0)
        {
            [self showMsg:[NSString stringWithFormat:@"%@ Card present",slotname]];
        } else {
            [self showMsg:@"Card present"];
        }
        
        if(([FTDeviceType getDeviceType] & LINE_TYPEC) != LINE_TYPEC)
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self connectCard:nil];
            });
        }
    }else{
        _batteryTestDone = YES;
        [self updateDeviceStatusImage:FTCardStatusDefault];
        if(slotname.length>0)
        {
            [self showMsg:[NSString stringWithFormat:@"%@ Card absent",slotname]];
        }else
        {
            [self showMsg:@"Card absent"];
        }
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
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self batteryTest];
        });
    }
}

-(void)batteryTest {
    while (1) {
        if (_batteryTestDone) {
            break;
        }
        
        [self sendCommand:@"00400000000400724183DDDD6234D037FDA7E7DC8EBA9C326EB036314AD4E322D45F06A6B89CD2FBD24A187B9E425D65F05A30E0E588BB3D194B977D1A46E5131D2E9AEBF0E71AAA30EA0938BCEA5D7C69B7B866F862F63345A201ECC076ED30210C413458E29208C32B571CA474F802D2872875AF90759B597E1D8725AC240249C1A38BD8D5639CF4D5AA2F3F28558192922716F25961FDBFA793552F30B110FB1469F75807B4EE29AFAC7A734D9D8011A05E50A907E2E1DEE50A5EC749BDE2A0CF3B81C0C1AE87CB820304292DF788B779752BBCE01FD01E002BABD6417001A1B8C02FF84B79EE431657D54A0E8C20ECE413AF132D4152E7BF9D43425EF1F46498A10BE9ED3CABF83351F6BC3984D018ABE0E596356FEDA1EB082FF5E969435336861D79EF204751A1986E69F60620A39486D42E42D22BB44C1675D529FF77D55C156C91984C49B827D545378D3A99F568AA84C19A929389AA6D1FCC68DC1751D0F9001A31E839948FB084104549C276EEF7FE3886D6AD86CDB534C1EC27AB315BD8E1FA021EA04C9FD032DB675B238FF012497C4EC602147D97BD9BFF09BCDCC55B181B5314054A20DE57803B9745A634A66D743A8B199C81BAC144E7AAD1BAD629AB636CF2F0F5D981FCE60926AF2584597307924D7A84A2C848A3EC31723356EBA5BC94E1E9B5946227F71930E972A6D3621F9D33AE35A8665BA058C727AF0C480B0D150979F21729E39AB2DC7CF762BD42A3A4663C185B3E002371937996C1E9E73E359127142B7D35B71E52EF1A82BF1C7AEF0EAC9482F8411481BEEF503D7540363DA17C8398062737A3BBCA45CC80F78EC6518710E73C265BCE6F124548951FDF7563FFA8266DC0008A3F96DF0AA9DBC6715A54F650B0B6E1A1CF68DEAAF18B2024FD38E99D5A08FB1B05DA5002E1D00A374F9BAD86FFF98C41067B812A308CE19397AFAFC47408109D361EFF7DD1DF426259E59D51CFF745F83BD39792FA2A0A0B5AED636464C7285AF9EB5642210F56389FB82E78C9B9F50C96F689A8F96E84D26D796B45D14D299877C7BC1B78692F024A9FC8C5944682C6406EBD35D25F3530F9DB312F64A3FDA0D73D99CE7EF3B307811FD3FED8A6D66E61C39D003006066F269C1BEAC5D08ABA42D25624DCB7CB916DC2B7EC3FE2D74C207B90D3B969DFD61B43933D9BDCBA2DE01059E53ABD60E6350FDC576F016FA7A620FD741592A9AC015800F28FD07343D87E0BD93F0B584F038EAB07100B85C91B394EACED894A3AFF63CACF48B39F4253A4D4C794AB9D14FCC88AC3CB0900F8A64FEA43E954ACC83EED589D6F8D2573780B1D79E1A5157D4A44E2544802CA7D6FE93901B0FDB59DE67D1423AB67ED1E703A4CB5CDFFAAD2158A1C832EFECAA09F8FA3AEEB8C4F031E9C652BA548DF8B62B9CB4400C3435A84239E162505E8A85ECA9011410761400E"];
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
    self.shownametag = 1;
    self.inputcommandtype =0;
    
    NSArray *apdu1 = [[Tools shareTools] apduArray];
    NSArray *apdu2 = [[Tools shareTools] getAPDU];
    NSMutableArray *_arr = [NSMutableArray array];
    [_arr addObjectsFromArray:apdu1];
    [_arr addObjectsFromArray:apdu2];
    _array = [_arr copy];
    
    
    NSArray *apdu31 = [[Tools shareTools] escapeapduArray];
//    NSArray *apdu32 = [[Tools shareTools] getAPDU];
    NSMutableArray *_arr2 = [NSMutableArray array];
    [_arr2 addObjectsFromArray:apdu31];
//    [_arr2 addObjectsFromArray:apdu2];
    _array2 = [_arr2 copy];
    
    
    
    _readerCMDArray = @[@"Read Flash", @"Write Flash", @"Get UID",@"Escape Cmd"];
    _readerOperationArray = @[@"readFlash", @"writeFlash", @"readUID",@"Escapecmd"];
    
    _deviceInfoArray = [NSMutableArray array];
    _readerList = [NSMutableArray array];
    
    [self setupNavigationBar];
    
    _apduTextField.text = [_array firstObject];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    
//    UIWebView *webView = [[UIWebView alloc] init];
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    
    
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"iphone system Version ---%@",systemVersion);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"typec-msg" object:nil];

   
}

-(void)acceptMsg : (NSNotification *)notification{
    
    NSLog(@"%@",notification);
    NSDictionary *userInfo = notification.userInfo;
    
    NSString * msgstr = [userInfo objectForKey:@"msg"];
    
    [self showMsg:msgstr];
    

}







-(void)viewWillAppear:(BOOL)animated
{
    if(self.gslotArray.count > 0)
    {
        self.selectslotname.text = self.gslotArray[0];
        self.gsleltslotnamestr = self.gslotArray[0];
    }
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
    
    
    //   pause back gesture
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
    
    [self setupCollectionView];
}




-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
     _logView.layoutManager.allowsNonContiguousLayout = NO;
    _logView.delegate = self;
    
    [self registerKeyboardNotification];
//
    
    // 并发队列的获取方法
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.CJL.Queue", DISPATCH_QUEUE_CONCURRENT);

//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self getReaderName];
//    });
//    dispatch_async(concurrentQueue, ^{
//        [self getReaderName];
//    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) setupNavigationBar{
    
//    self.navigationController.delegate = self;
//    self.navigationController.interactivePopGestureRecognizer.delegate = self;
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
    
    NSString *name = [NSString stringWithFormat:@"%@-%@", _name, cardStatus];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.readerNameLabel.text = _name;
        UIImage *image = [UIImage imageNamed:name];
        if (image == nil) {
            image = [UIImage imageNamed:@"readerItem"];
        }
        self.deviceStatusImageView.image = image;
    });
}

- (void)showMsg:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *log = _logView.text;
        if (log.length > 1000) {
            log = @"";
        }
        
        if(msg != nil) {
            NSString *tempMsg = [msg stringByAppendingString:@"\n"];
            [_logView setText:[log stringByAppendingString:tempMsg]];
            NSInteger count = _logView.text.length;
            [_logView scrollRangeToVisible:NSMakeRange(0, count)];
        }
    });
}

- (void)clearLog
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_logView setText:@""];
    });
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
    if(self.inputcommandtype == 0)
    {
    return _array.count;
    }else
    {
        return  _array2.count;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED
{
    if(self.inputcommandtype == 0)
    {
        return _array[row];
    }else
    {
        return _array2[row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(self.inputcommandtype == 0)
    {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.apduTextField.text = _array[row];
    });
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.apduTextField.text = _array2[row];
        });
    }
        
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
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    BOOL isSelf = [viewController isKindOfClass:[self class]];
//    [self.navigationController setNavigationBarHidden:isSelf animated:YES];
//}

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

//active mail
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

//mail
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
    if (data != nil) {
        [mailPicker addAttachmentData: data mimeType: @"" fileName: @"log.txt"];
    }
    
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


-(void)dealloc
{
    
//    NSLog(@"Operatoin dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end

