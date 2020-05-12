//
//  ViewController.m
//  TestFTReader
//
//  Created by 洪捷 on 2019/11/5.
//  Copyright © 2019 洪捷. All rights reserved.
//

#import "ViewController.h"
//#import <CoreBluetooth/CoreBluetooth.h>
#import "hex.h"

SCARDCONTEXT gContxtHandle;
//SCARDCONTEXT LLgContxtHandle;
SCARDHANDLE gCardHandle;
NSString *gBluetoothID = @"";

@interface ViewController ()


@property(nonatomic,strong)UITextField * commandtext;
@property(nonatomic,strong)UITextView *passportTextView;
@property(nonatomic,strong)UILabel * readerdetailName;
@property(nonatomic,copy)NSString * listreadername;




@end

@implementation ViewController
{
    NSMutableArray *_deviceList;
    NSString *_selectedDeviceName;
    ReaderInterface *interface;
//    HelpVisualEffectView *_helpView;
    BOOL _autoConnect;
    NSInteger _itemHW;
    CGFloat _itemMargin;
    NSInteger _itemCountPerRow;
    NSMutableArray *_displayedItem;
    CGFloat _itemStartX;
    NSMutableArray *_discoverdList;
    NSArray *_tempList;
}

@synthesize label;



-(void)viewWillAppear:(BOOL)animated
{
// NSLog(@"-----1");
    [self initReaderInterface];
    
    if (gContxtHandle == 0) {
        ULONG ret = SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
        if(ret != 0){
//            [[Tools shareTools] showError:[[Tools shareTools] mapErrorCode:ret]];
            return;
        }
    } 
    
//    [self beginScanBLEDevice];
}
/*
 
*/
- (void)initReaderInterface
{

    
}

- (void) viewDidLoad
{
    NSLog(@"-----0");
    [super viewDidLoad];
     [self setupUI];
    
    // Do any additional setup after loading the view.
//    ContxtHandle = 0;
 

    
}
-(void)setupUI
{
   
    

    
    
    UIButton * connectcardBtn = [[UIButton alloc]init];
    [self.view addSubview:connectcardBtn];
    [connectcardBtn setFrame:CGRectMake(20, 140, 100, 30)];
    [connectcardBtn setTitle:@"ConnectCard" forState:UIControlStateNormal];
    [connectcardBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [connectcardBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [connectcardBtn setBackgroundColor:[UIColor lightGrayColor]];
    [connectcardBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [connectcardBtn addTarget:self action:@selector(connectCard) forControlEvents:UIControlEventTouchUpInside];
   
    
    UIButton * disconnectcardBtn = [[UIButton alloc]init];
    [self.view addSubview:disconnectcardBtn];
    [disconnectcardBtn setFrame:CGRectMake(130, 140, 120, 30)];
    [disconnectcardBtn setTitle:@"DisconnectCard" forState:UIControlStateNormal];
    [disconnectcardBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [disconnectcardBtn setBackgroundColor:[UIColor lightGrayColor]];
    [disconnectcardBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [disconnectcardBtn addTarget:self action:@selector(disconnectCard) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton * ReadFlashBtn = [[UIButton alloc]init];
    [self.view addSubview:ReadFlashBtn];
    [ReadFlashBtn setFrame:CGRectMake(260, 140, 100, 30)];
    [ReadFlashBtn setTitle:@"ReadFlash" forState:UIControlStateNormal];
    [ReadFlashBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [ReadFlashBtn setBackgroundColor:[UIColor lightGrayColor]];
    [ReadFlashBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [ReadFlashBtn addTarget:self action:@selector(readFlashClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * SCardListReaderBtn = [[UIButton alloc]init];
    [self.view addSubview:SCardListReaderBtn];
    [SCardListReaderBtn setFrame:CGRectMake(20, 190, 120, 30)];
    [SCardListReaderBtn setTitle:@"SCardListReader" forState:UIControlStateNormal];
    [SCardListReaderBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [SCardListReaderBtn setBackgroundColor:[UIColor lightGrayColor]];
    [SCardListReaderBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [SCardListReaderBtn addTarget:self action:@selector(scardlistreader:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * SCardGetStatusChangeBtn = [[UIButton alloc]init];
    [self.view addSubview:SCardGetStatusChangeBtn];
    [SCardGetStatusChangeBtn setFrame:CGRectMake(180, 190, 180, 30)];
    [SCardGetStatusChangeBtn setTitle:@"SCardGetStatusChange" forState:UIControlStateNormal];
    [SCardGetStatusChangeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [SCardGetStatusChangeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [SCardGetStatusChangeBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [SCardGetStatusChangeBtn addTarget:self action:@selector(scardgetstatuschange:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    UIButton * ScardReleaseContextBtn = [[UIButton alloc]init];
    [self.view addSubview:ScardReleaseContextBtn];
    [ScardReleaseContextBtn setFrame:CGRectMake(20, 230, 180, 30)];
    [ScardReleaseContextBtn setTitle:@"ScardReleaseContextBtn" forState:UIControlStateNormal];
    [ScardReleaseContextBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [ScardReleaseContextBtn setBackgroundColor:[UIColor lightGrayColor]];
    [ScardReleaseContextBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [ScardReleaseContextBtn addTarget:self action:@selector(scardreleasecontext:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton * SCardEstablisthContext = [[UIButton alloc]init];
    [self.view addSubview:SCardEstablisthContext];
    [SCardEstablisthContext setFrame:CGRectMake(205, 230, 180, 30)];
    [SCardEstablisthContext setTitle:@"SCardEstablishContext" forState:UIControlStateNormal];
    [SCardEstablisthContext setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [SCardEstablisthContext setBackgroundColor:[UIColor lightGrayColor]];
    [SCardEstablisthContext.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [SCardEstablisthContext addTarget:self action:@selector(scardestablishcontext:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton * sendcommand = [[UIButton alloc]init];
    [self.view addSubview:sendcommand];
    [sendcommand setFrame:CGRectMake(20, 270, 120, 30)];
    [sendcommand setTitle:@"Send Command" forState:UIControlStateNormal];
    [sendcommand setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendcommand setBackgroundColor:[UIColor lightGrayColor]];
    [sendcommand.titleLabel setFont:[UIFont systemFontOfSize:15]];
   [sendcommand addTarget:self action:@selector(sendCommandClick) forControlEvents:UIControlEventTouchUpInside];
    
    UITextField * commandtext = [[UITextField alloc]init];
    [self.view addSubview:commandtext];
    [commandtext setFrame:CGRectMake(150, 270, 140, 40)];
    commandtext.borderStyle = UITextBorderStyleRoundedRect;
    self.commandtext = commandtext;
    commandtext.text = @"0084000007F";
    
    UILabel * readerName = [[UILabel alloc]init];
    [self.view addSubview:readerName];
    readerName.text = @"readerName:";
    [readerName setFrame:CGRectMake(20, 320, 120, 40)];
    
    UILabel * readerdetailName = [[UILabel alloc]init];
    [self.view addSubview:readerdetailName];
    readerdetailName.text = @"";
    [readerdetailName setFrame:CGRectMake(150, 320, 200, 40)];
    self.readerdetailName = readerdetailName;
    readerdetailName.font = [UIFont systemFontOfSize:12];
    
    
    UITextView * passportTextView = [[UITextView alloc]init];
    [self.view addSubview:passportTextView];
    CGRect rectt = [[UIScreen mainScreen] bounds];
    [passportTextView setFrame:CGRectMake(10, 370, rectt.size.width-20, 300)];
    passportTextView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    passportTextView.layer.borderWidth = 1.0;
    self.passportTextView  = passportTextView;
//    passportTextView.userInteractionEnabled =NO;
    
    
}




-(void)connectCard
{
    [self showLog:@"Connect to card..."];
    gCardHandle = 0;
    LONG iRet = 0;
    DWORD dwActiveProtocol = -1;
    char mszReaders[128] = "";
    
    //delete:only need init once
    //    [self createReaderContext];
    
    if ([_readerdetailName.text length] != 0)
        memcpy(mszReaders, _readerdetailName.text.UTF8String, _readerdetailName.text.length);
    
    //Every First time connection return ERROR
    //Switch off power on reader, and turn on, again connect and we have same ERROR on first connect
    iRet = SCardConnect(gContxtHandle,mszReaders,SCARD_SHARE_SHARED,SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1,&gCardHandle,&dwActiveProtocol);
    
    if (iRet != 0)
    {
        //        _passportTextView.text = [NSString stringWithFormat:@"Connect to card Error:%d\n",iRet];
        [self showLog:[NSString stringWithFormat:@"Connect to card Error:%d\n",iRet]];
        return;
    }
    else
    {
        unsigned char patr[33];
        DWORD len = sizeof(patr);
        iRet = SCardGetAttrib(gCardHandle, 0, patr, &len);
        if(iRet != SCARD_S_SUCCESS)
            NSLog(@"%@%08x",NSLocalizedString(@"cardGetAttribError",nil),iRet);
        
        NSMutableData *tmpData = [NSMutableData data];
        [tmpData appendBytes:patr length:len];
        
        //        _passportTextView.text = @"Connect Card Sucess.\n";
        [self showLog:@"Connect Card Success.\n"];
    }
}

- (void)scardgetstatuschange:(id)sender
{
    SCARD_READERSTATE rs[1];
    
    rs[0].szReader = [_readerdetailName.text UTF8String];
    rs[0].dwCurrentState = SCARD_STATE_UNAWARE;
    rs[0].cbAtr = 0;
    rs[0].dwEventState = SCARD_STATE_UNAWARE;
    rs[0].pvUserData = NULL;
    
    DWORD dwActiveProtocol;
    LONG rv;
    
    rv = SCardGetStatusChange(gContxtHandle, INFINITE, rs, 1);
    
    //    _passportTextView.text = [NSString stringWithFormat:@"dwEventState: %d\n", rs[0].dwEventState];
    [self showLog:[NSString stringWithFormat:@"dwEventState: %d\n", rs[0].dwEventState]];
    //Why rs[0].cbAtr forever be 0?
    //    _passportTextView.text = [_passportTextView.text  stringByAppendingString: [NSString stringWithFormat:@"cbAtr: %d\n", rs[0].cbAtr] ];
    [self showLog:[NSString stringWithFormat:@"cbAtr: %d\n", rs[0].cbAtr]];
    printf("reader state: 0x%04X\n", rs[0].dwEventState);
    if ((rv == SCARD_S_SUCCESS) && (rs[0].dwEventState & SCARD_STATE_PRESENT) && !(rs[0].dwEventState & SCARD_STATE_MUTE))
    {
        //rs[0].cbAtr FOREVER be 0, cant check type of card.
        /*** Contact-only ***/
        if (rs[0].cbAtr > 14)
            printf("Contact card.");
    }
}

-(void)scardlistreader:(id)sender
{
    [self showLog:@"scardlistreader..."];
    LPSTR readers = NULL;
    DWORD readersLen;
    LONG iRet = SCardListReaders(gContxtHandle, NULL, NULL, &readersLen);
    if ((iRet == 0) && (readersLen != 0))
    {
        //readersLen=300; //if uncommend sucess
        //OUT readersLen no guarantee to overwrite (2 Readers power on)
        
        readers = (LPSTR)calloc(readersLen, sizeof(LPSTR));
        if(readers == NULL)
        {
            NSLog(@"calloc memory error");
            return;
        }
        iRet = SCardListReaders(gContxtHandle, NULL, readers, &readersLen);
        
        //if readersLen do not overwrite, we get ERROR -2146435064
        
        //add:display readers` name
        
        char tempReaderName[32] = {0};
        
        if (iRet == SCARD_S_SUCCESS)
        {
            printf("SCardListReader Sucess!");
            int tempIndex = 0;
            for (int index = 0; index < readersLen; index++)
            {
                if(readers[index] != '\0')
                {
                    tempReaderName[tempIndex] = readers[index];
                    tempIndex++;
                    continue;
                }
                tempIndex = 0;
                NSLog(@"9999");
                [self showLog:[[NSString alloc] initWithCString:tempReaderName encoding:NSUTF8StringEncoding]];
            
               self.listreadername  =  [[NSString alloc] initWithCString:tempReaderName encoding:NSUTF8StringEncoding];
                if(self.listreadername.length >0)
                {
                      NSLog(@"9999------->%@",_listreadername);
                self.readerdetailName.text = _listreadername;
                }
                
                memset(tempReaderName, 0, sizeof(tempReaderName));
            }
        }
    }
    else
        //        _passportTextView.text = [NSString stringWithFormat:@"SCardListReaders Error:%d\n",iRet];
        
        [self showLog:[NSString stringWithFormat:@"SCardListReaders Error:%d\n",iRet]];
    
    if(readers != NULL)
    {
        free(readers);
        readers = NULL;
    }
}


-(void)scardreleasecontext:(id)sender
{
    self.readerdetailName.text = @"";
    [self showLog:[NSString stringWithFormat:@"SCARDCONTEXT: %d",gContxtHandle]];
    LONG iR = SCardReleaseContext(gContxtHandle);
     gCardHandle = 0;
    if (iR != SCARD_S_SUCCESS)
    {
        [self showLog:[NSString stringWithFormat:@"SCardListReaders Error:%d",iR]];
    }
    else
    {
        [self showLog:[NSString stringWithFormat:@"SCARDCONTEXT after SCardReleaseContext: %d",gContxtHandle]];
    }
}


-(void)scardestablishcontext:(id)sender
{
    LONG iRet = SCardIsValidContext(gContxtHandle);
    [self showLog:[NSString stringWithFormat:@"%@%08x\n",NSLocalizedString(@"ValidContext:", nil),iRet]];
    [self createReaderContext];
}

-(void)disconnectCard
{
    LONG iRet = 0;
    iRet = SCardDisconnect(gCardHandle,SCARD_UNPOWER_CARD);
    if (iRet != 0)
        //        _passportTextView.text = @"Disconnect Error";
        [self showLog:@"Disconnect Error"];
    else
    {
        //        _passportTextView.text = @"Disconnect sucess.";
        [self showLog:@"Disconnect success."];
        NSLog(@"Disconect success.");
    }
}


-(void)createReaderContext
{
    @try
    {
        //        readerDescription = [[ReaderInterface alloc] init];
        //        [readerDescription setDelegate:self];
        SCardEstablishContext(SCARD_SCOPE_SYSTEM,NULL,NULL,&gContxtHandle);
    }
    @catch(NSException *ex)
    {
        NSString *errmsg = [@"createReaderContext Error:" stringByAppendingString:ex.description ];
        //        _passportTextView.text = errmsg;
        [self showLog:errmsg];
    }
}

-(void)showLog:(NSString *)log
{
    __block NSString *strLog = log;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *temp = weakSelf.passportTextView.text;
        strLog = [strLog stringByAppendingString:@"\n"];
        if(strLog != nil)
        {
        temp = [temp stringByAppendingString:strLog];
        weakSelf.passportTextView.text = temp;
        }
    });
}

-(void)readFlashClick
{
    //    _passportTextView.text = @"Read Flash...";
    [self showLog:@"Read Flash..."];
    
    unsigned char buffer[256] = {0};
    unsigned int length = 255;
    LONG iRet = FtReadFlash(gContxtHandle,0,&length, buffer);
    
    if(iRet != 0 )
        //        _passportTextView.text = @"Read Flash Error";
        [self showLog:@"Read Flash Error"];
    else
    {
        NSData *temp = [NSData dataWithBytes:buffer length:length];
        //        _passportTextView.text = [NSString stringWithFormat:@"%@\n", temp];
        
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
                                 
        NSString *str1 = [NSString stringWithFormat:@"<%@>", deviceTokenString];
        [self showLog:[NSString stringWithFormat:@"%@\n", str1]];
    }
}

-(void)sendCommandClick
{
    LONG iRet = 0;
    unsigned  int capdulen;
    unsigned char capdu[2056];
    unsigned char resp[2056];
    unsigned int resplen = sizeof(resp) ;
    
    //1.judge apdu length
    if([_commandtext.text length] < 5  )
    {
        //        _passportTextView.text = [_passportTextView.text  stringByAppendingString:NSLocalizedString(@"Invalid APDU", nil)];
        [self showLog:NSLocalizedString(@"Invalid APDU", nil)];
        return;
    }
    
    //2.change the format of data
    NSData *apduData =[hex hexFromString:_commandtext.text];
    [apduData getBytes:capdu length:apduData.length];
    capdulen = (unsigned int)[apduData length];
    
    //3.send data
    SCARD_IO_REQUEST pioSendPci;
    iRet=SCardTransmit(gCardHandle,&pioSendPci, (unsigned char*)capdu, capdulen,NULL,resp, &resplen);
    //    _passportTextView.text = [_passportTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"send", nil),_command.text]];
    [self showLog:[NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"send:", nil),_commandtext.text]];
    if (iRet != 0)
    {
        //        _passportTextView.text = [_passportTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@%08x\n",NSLocalizedString(@"Rec:", nil),iRet]];
        [self showLog:[NSString stringWithFormat:@"%@%08x\n",NSLocalizedString(@"Rec:", nil),iRet]];
        return;
    }
    else
    {
        NSMutableData *RevData = [NSMutableData data];
        [RevData appendBytes:resp length:resplen];
        //        _passportTextView.text = [_passportTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"Rec:", nil),[RevData description]]];
        
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
        
        
        [self showLog:[NSString stringWithFormat:@"%@%@\n",NSLocalizedString(@"Rec:", nil),str1]];
    }
}






#pragma mark - ReaderInterfaceDelegate




-(void)viewDidAppear:(BOOL)animated
{


}


- (void) InitSCard
{
  
    ULONG ret = 0;
    ret = SCardEstablishContext(SCARD_SCOPE_SYSTEM, NULL, NULL, &ContxtHandle);
    if(ret != 0)
    {
        [label setText:[NSString stringWithFormat:@"SCardEstablishContext fail. rtn = %X\nRetry times: %d", ret, retry_count]];
        return;
    }
    
    DWORD readerLength = 0;
    ret = SCardListReaders(ContxtHandle, nil, nil, &readerLength);
    if(ret != 0)
    {
        [label setText:[NSString stringWithFormat:@"SCardListReaders 1 fail. rtn = %X\nRetry times: %d", ret, retry_count]];
        return;
    }
    
    LPSTR readers = (LPSTR)malloc(readerLength * sizeof(LPSTR));
    ret = SCardListReaders(ContxtHandle, nil, readers, &readerLength);
    if(ret != 0)
    {
        [label setText:[NSString stringWithFormat:@"SCardListReaders 2 fail. rtn = %X\nRetry times: %d", ret, retry_count]];
        free(readers);
        return;
    }
    free(readers);
}

- (IBAction)Retry:(id)sender
{
    retry_count ++;
    if(ContxtHandle != 0)
    {
        ULONG ret = SCardReleaseContext(ContxtHandle);
        if(ret != 0)
        {
            [label setText:[NSString stringWithFormat:@"SCardReleaseContext fail. rtn = %X\nRetry times: %d", ret, retry_count]];
            return;
        }
    }
    [self InitSCard];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.commandtext resignFirstResponder];
    [self.passportTextView resignFirstResponder];
}
@end
