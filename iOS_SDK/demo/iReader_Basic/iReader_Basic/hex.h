//
//  hex.h
//  bR500Sample
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hex : NSObject
+(NSData *)hexFromString:(NSString *)cmd;
void StrToHex(unsigned char *pbDest, char *szSrc, unsigned int dwLen);
int filterStr(char *szSrc, unsigned int dwLen);
@end
