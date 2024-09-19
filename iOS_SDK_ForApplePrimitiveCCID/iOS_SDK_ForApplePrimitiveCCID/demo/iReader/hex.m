//
//  hex.m
//  bR500Sample
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "hex.h"

@implementation hex

/**
 *  NSString hex
 *
 *  @param cmd src
 *
 *  @return
 */
+(NSData *)hexFromString:(NSString *)cmd
{
    NSData *cmdData = nil;
    char *pbDest = NULL;
    unsigned int length = 0;
    
    char h1,h2;
    unsigned char s1,s2;
    pbDest = malloc(cmd.length/2 + 1);
    for (int i=0; i<[cmd length]/2; i++)
    {

        h1 = [cmd characterAtIndex:2*i];
        h2 = [cmd characterAtIndex:2*i+1];
        
        s1 = toupper(h1) - 0x30;
        if (s1 > 9)
            s1 -= 7;
        
        s2 = toupper(h2) - 0x30;
        if (s2 > 9)
            s2 -= 7;
        
        pbDest[i] = s1*16 + s2;
        length++;
    }

    cmdData = [NSData dataWithBytes:pbDest length:length];
    return cmdData;
}

/**
 *  nsstring to hex
 *
 *  @param pbDest out
 *  @param szSrc  in
 *  @param dwLen  length of in
 */
void StrToHex(unsigned char *pbDest, char *szSrc, unsigned int dwLen)
{
    char h1,h2;
    unsigned char s1,s2;
    
    for (int i=0; i<dwLen; i++)
    {
        h1 = szSrc[2*i];
        h2 = szSrc[2*i+1];
        
        s1 = toupper(h1) - 0x30;
        if (s1 > 9)
            s1 -= 7;
        
        s2 = toupper(h2) - 0x30;
        if (s2 > 9)
            s2 -= 7;
        
        pbDest[i] = s1*16 + s2;
    }
}

/**
 * （0~9 a~f A~F）
 *
 *  @param szSrc
 *  @param dwLen 
 *
 *  @return
 */
int filterStr(char *szSrc, unsigned int dwLen)
{
 
    for (int i = 0; i < dwLen; i++) {
        if((szSrc[i]>='0')&&(szSrc[i]<='9')){
            continue;
        }
        
        if((szSrc[i]>='a')&&(szSrc[i]<='f')){
            continue;
        }
        
        if((szSrc[i]>='A')&&(szSrc[i]<='F')){
            continue;
        }
        return -1;
    }
    
    return 0;
}
@end
