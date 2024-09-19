//
//  Tools.h
//  eID Viewer
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "wintypes.h"

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

#define commonColor [UIColor colorWithRed:0/255.0 green:126/255.0 blue:246/255.0 alpha:1]

typedef NS_ENUM(NSInteger, FTReaderType) {
    FTReaderiR301 = 0,
    FTReaderbR301 = 1,
    FTReaderbR301BLE = 2,
    FTReaderbR500 = 3,
    FTReaderBLE = 4,
    FTReaderOTHER = 5,
};

typedef NS_ENUM(NSInteger, FTCardStatus) {
    FTCardStatusDefault = 0,
    FTCardStatusPresent,
    FTCardStatusExcute,
    FTCardStatusReady,
    FTCardStatusError
};

static NSString *welcomeKey = @"welcome";
static NSString *autoConnectKey = @"autoConnect";
static NSString *autoPowerOffKey = @"autoPowerOff";

@interface Tools : NSObject

+ (instancetype)shareTools;
- (void)showMsg:(NSString *)msg;
- (void)showError:(NSString *)error;
- (NSArray *)apduArray;
- (void)hideMsgView;
- (NSData *)readFileContent:(NSString *)fileName;
- (NSArray *)commandArray;
- (NSString *)mapErrorCode:(LONG)ret;
- (BOOL)getHexDataFormString:(NSString *)text withBuf:(unsigned char *)pbuf
                     AndLen:(unsigned int *)pLen;
- (NSString *)getStringFormHexData:(unsigned char *)buf withLen:( int )len;
- (BOOL)iPhonexSerial;
- (void)logToFile;
- (BOOL)isApduValid:(unsigned char *)apdu apduLen:(unsigned int)apduLen;
- (NSString *)getIPAddress;
- (NSArray *)getAPDU;

-(NSData *)hexFromString:(NSString *)cmd;
- (void)StrToHex:(unsigned char *)pbDest src:(char *)szSrc len:(unsigned int) dwLen;
- (int)filterStr:(char *)szSrc len:(unsigned int)dwLen;
-(NSArray *)escapeapduArray;

@property (nonatomic, copy) NSString *logFilePath;
@end
