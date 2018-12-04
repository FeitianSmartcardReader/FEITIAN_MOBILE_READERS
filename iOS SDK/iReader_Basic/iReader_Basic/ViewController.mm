//
//  ViewController.m
//  iReader_Basic
//
//  Created by Jermy on 2018/10/16.
//  Copyright © 2018年 Jermy. All rights reserved.
//

#import "ViewController.h"
#import "ReaderInterface.h"
#import "winscard.h"
#import "Tools.h"
#import "hex.h"

@interface ViewController () <ReaderInterfaceDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *readerNameTF;

@property (weak, nonatomic) IBOutlet UITextField *apduTF;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextView *logView;
@end

@implementation ViewController
{
    BOOL _isAutoConnect;
    SCARDCONTEXT _gContxtHandle;
    SCARDHANDLE _gCardHandle;
    ReaderInterface *_interface;
    NSMutableArray *_readers;
    NSString *_selectedReader;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _readers = [NSMutableArray array];
    _isAutoConnect = NO;
    
    _interface = [[ReaderInterface alloc] init];
    [_interface setDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self _SCardReleaseContext];
}

- (IBAction)autoConnect:(id)sender {
    UISwitch *_switch = (UISwitch *)sender;
    _isAutoConnect = _switch.isOn;
}

- (IBAction)establishContext:(id)sender {
    
    [_interface setAutoPair:_isAutoConnect];
    
    if (_gContxtHandle == 0) {
        [self _SCardEstablishContext];
        return;
    }
    
    [self _SCardReleaseContext];
    [self _SCardEstablishContext];
}

- (IBAction)connectReader:(id)sender {
    
    if (_selectedReader == nil || _selectedReader.length == 0) {
        [self showMsg:@"please selecte a reader"];
        return;
    }
    
    BOOL rev = [_interface connectPeripheralReader:_selectedReader timeout:15];
    if (!rev) {
        [self showMsg:@"connect reader fail"];
        return;
    }
    
    [self showMsg:[NSString stringWithFormat:@"coonnect reader %@ success", _selectedReader]];
}

- (IBAction)connectCard:(id)sender {
    
    if (_selectedReader == nil || _selectedReader.length == 0) {
        [self showMsg:@"please selecte a reader"];
        return;
    }
    
    DWORD dwActiveProtocol = -1;
    LONG ret = SCardConnect(_gContxtHandle, [_selectedReader UTF8String], SCARD_SHARE_SHARED,SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1, &_gCardHandle, &dwActiveProtocol);
    
    if(ret != 0){
        [self showMsg:[[Tools shareTools] mapErrorCode:ret]];
        return;
    }
    
    unsigned char patr[33] = {0};
    DWORD len = sizeof(patr);
    ret = SCardGetAttrib(_gCardHandle,NULL, patr, &len);
    if(ret != SCARD_S_SUCCESS) {
        [self showMsg:[[Tools shareTools] mapErrorCode:ret]];
        return;
    }
    
    NSData *data = [NSData dataWithBytes:patr length:len];
    [self showMsg:[NSString stringWithFormat:@"Attr: %@", data]];
}

- (IBAction)getSN:(id)sender {
    char buffer[16] = {0};
    unsigned int length = 0;
    DWORD ret = FtGetSerialNum(_gContxtHandle, &length, buffer);
    if(ret == SCARD_S_SUCCESS){
        NSData *data = [NSData dataWithBytes:buffer length:length];
        NSString *str = [NSString stringWithFormat:@"Serial Number: %@", data];
        [self showMsg:str];
        return;
    }
    
    [self showMsg:[[Tools shareTools] mapErrorCode:ret]];
}

- (IBAction)getSlotStatus:(id)sender {
}

- (IBAction)disconnectCard:(id)sender {
    SCardDisconnect(_gCardHandle, SCARD_UNPOWER_CARD);
    [self showMsg:[NSString stringWithFormat:@"Card disconnect"]];
}

- (IBAction)sendData:(id)sender {
    [self sendCommand:_apduTF.text];
}

#pragma mark readerinterface delegate
- (void) findPeripheralReader:(NSString *)readerName
{
    if (readerName == nil || readerName.length == 0) {
        return;
    }
    
    if ([_readers containsObject:readerName]) {
        return;
    }
    
    [_readers addObject:readerName];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
}

- (void) readerInterfaceDidChange:(BOOL)attached bluetoothID:(NSString *)bluetoothID
{
    if(attached) {
        [self showMsg:[NSString stringWithFormat:@"%@ connected", bluetoothID]];
    }else {
        [self showMsg:[NSString stringWithFormat:@"%@ disconnected", bluetoothID]];
    }
}

- (void) cardInterfaceDidDetach:(BOOL)attached
{
    if (attached) {
        [self showMsg:@"card present"];
    }else {
        [self showMsg:@"card not present"];
    }
}

- (void) didGetBattery:(NSInteger)battery
{
    [self showMsg:[NSString stringWithFormat:@"battery - %zd%%", battery]];
}

#pragma mark winscard

-(void) _SCardEstablishContext{
    ULONG ret = SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&_gContxtHandle);
    if(ret != 0){
        [self showMsg:[[Tools shareTools] mapErrorCode:ret]];
    }
}

-(void) _SCardReleaseContext{
    ULONG ret = SCardReleaseContext(_gContxtHandle);
    if(ret != 0){
        [self showMsg:[[Tools shareTools] mapErrorCode:ret]];
    }
}

-(void) _SCardListReaders{
    DWORD readerLength = 0;
    LONG ret = SCardListReaders(_gContxtHandle, nil, nil, &readerLength);
    if(ret != 0){
        [[Tools shareTools] showError:[[Tools shareTools] mapErrorCode:ret]];
        return;
    }
    
    LPSTR readers = (LPSTR)malloc(readerLength * sizeof(LPSTR));
    ret = SCardListReaders(_gContxtHandle, nil, readers, &readerLength);
    if(ret != 0){
        [[Tools shareTools] showError:[[Tools shareTools] mapErrorCode:ret]];
        return;
    }
}

-(void)sendCommand:(NSString *)apdu
{
    unsigned  int capdulen;
    unsigned char capdu[2048 + 128];
    memset(capdu, 0, 2048 + 128);
    unsigned char resp[2048 + 128];
    memset(resp, 0, 2048 + 128);
    unsigned int resplen = sizeof(resp) ;
    
    //1.judge apdu length
    if(apdu.length < 5  )
    {
        [self showMsg:@"Invalid APDU"];
        return;
    }
    
    [self showMsg:[NSString stringWithFormat:@"Send: %@", apdu]];
    
    //2.change the format of data
    NSData *apduData =[hex hexFromString:apdu];
    [apduData getBytes:capdu length:apduData.length];
    capdulen = (unsigned int)[apduData length];
    
    //3.send data
    SCARD_IO_REQUEST pioSendPci;
    DWORD iRet = SCardTransmit(_gContxtHandle, &pioSendPci, (unsigned char*)capdu, capdulen, NULL, resp, &resplen);
    if (iRet != 0) {
        [self showMsg:[[Tools shareTools] mapErrorCode:iRet]];
    }else {
        NSMutableData *RevData = [NSMutableData data];
        [RevData appendBytes:resp length:resplen];
        NSString *str = [NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"Rev:", nil),[RevData description]];
        [self showMsg:str];
    }
}

#pragma mark private function

-(void)showMsg:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *log = self.logView.text;
        if (log.length > 1000) {
            log = @"";
        }
        NSString *tempMsg = [msg stringByAppendingString:@"\n"];
        [self.logView setText:[log stringByAppendingString:tempMsg]];
        NSInteger count = self.logView.text.length;
        [self.logView scrollRangeToVisible:NSMakeRange(0, count)];
    });
}

#pragma mark tableview delegate and datasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = _readers[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _readers.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedReader = _readers[indexPath.row];
    _readerNameTF.text = _selectedReader;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
