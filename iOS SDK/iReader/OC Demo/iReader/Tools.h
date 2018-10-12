//
//  Tools.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "wintypes.h"

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

#define commonColor [UIColor colorWithRed:0/255.0 green:126/255.0 blue:246/255.0 alpha:1]

static NSString *welcomeKey = @"welcome";
static NSString *autoConnectKey = @"autoConnect";

@interface Tools : NSObject

+(instancetype)shareTools;
-(void)showMsg:(NSString *)msg;
-(void)showError:(NSString *)error;
-(NSArray *)apduArray;
-(void)hideMsgView;
-(NSData *)readFileContent:(NSString *)fileName;
-(NSArray *)commandArray;
-(NSString *)mapErrorCode:(LONG)ret;
-(BOOL)getHexDataFormString:(NSString *)text withBuf:(unsigned char *)pbuf
                     AndLen:(unsigned int *)pLen;
-(NSString *)getStringFormHexData:(unsigned char *)buf withLen:( int )len;

-(BOOL)iPhonexSerial;
@end
