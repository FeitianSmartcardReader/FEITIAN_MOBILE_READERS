//
//  Tools.m
//  eID Viewer
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "Tools.h"

@implementation Tools
static Tools *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
}

+(instancetype)shareTools
{
    return [[self alloc]init];
}

-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

-(BOOL)getHexDataFormString:(NSString *)text withBuf:(unsigned char *)pbuf
                     AndLen:(unsigned int *)pLen
{
    
    unsigned  int capdulen;
    unsigned char capdu[512];
    
    NSString* tempBuf = [NSString string];
    
    if([text length] < 2 ) {
        
        *pLen = 0;
        return TRUE;
    }
    
    tempBuf = text;
    
    //  NSString* comand = [tempBuf stringByAppendingString:@"\n"];
    const char *buf = [tempBuf UTF8String];
    NSMutableData *data = [NSMutableData data];
    uint32_t len = strlen(buf);
    
    //to hex
    char singleNumberString[3] = {'\0', '\0', '\0'};
    uint32_t singleNumber = 0;
    for(uint32_t i = 0 ; i < len; i+=2) {
        if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) ) {
            singleNumberString[0] = buf[i];
            singleNumberString[1] = buf[i + 1];
            sscanf(singleNumberString, "%x", &singleNumber);
            uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
            [data appendBytes:(void *)(&tmp) length:1];
        } else {
            break;
        }
    }
    
    [data getBytes:capdu];
    capdulen = [data length];
    
    if (*pLen < capdulen ) {
        return FALSE;
    }
    *pLen = capdulen;
    memcpy(pbuf, capdu, *pLen);
    return TRUE;
    
}

-(NSString *)getStringFormHexData:(unsigned char *)buf withLen:( int )len
{
    NSMutableData *tmpData = [NSMutableData data];
    [tmpData appendBytes:buf length:len];
    
    NSString* dataString= [NSString stringWithFormat:@"%@",tmpData];
    NSRange begin = [dataString rangeOfString:@"<"];
    NSRange end = [dataString rangeOfString:@">"];
    NSRange range = NSMakeRange(begin.location + begin.length, end.location- begin.location - 1);
    dataString = [dataString substringWithRange:range];
    
    return dataString;
    
}

-(NSData *)readFileContent:(NSString *)fileName
{
//    NSData* fileData = nil;
//    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docmentDirectory = [directoryPaths objectAtIndex:0];
//    NSString *filePath = [docmentDirectory stringByAppendingPathComponent:fileName];
//
//    fileData = [[NSData alloc] initWithContentsOfFile:filePath];
//    NSString *srcString = [[NSString alloc] initWithData:fileData  encoding:NSUTF8StringEncoding];;
//    NSString *desString = [srcString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//    fileData = [desString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flash.txt" ofType:nil];
    
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSString *srcString = [[NSString alloc] initWithData:fileData  encoding:NSUTF8StringEncoding];;
    NSString *desString = [srcString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    fileData = [desString dataUsingEncoding:NSUTF8StringEncoding];
    return fileData;
}

-(NSArray *)apduArray
{
    return
    @[
          @"0084000008"
    ];
}

-(NSString *)mapErrorCode:(LONG)ret {
    
    NSString *info = @"success";
    
    switch (ret) {
        case SCARD_E_INVALID_HANDLE:
            info = [NSString stringWithFormat:@"0x%08x:The supplied handle was invalid.", ret];
            break;
            
        case SCARD_E_INVALID_PARAMETER:
            info = [NSString stringWithFormat:@"0x%08x:One or more of the supplied parameters could not be properly interpreted.", ret];
            break;
            
        case SCARD_E_INSUFFICIENT_BUFFER:
            info = [NSString stringWithFormat:@"0x%08x:The data buffer to receive returned data is too small for the returned data.", ret];
            break;
            
        case SCARD_E_TIMEOUT:
            info = [NSString stringWithFormat:@"0x%08x:The user-specified timeout value has expired. ", ret];
            break;
            
        case SCARD_E_NO_SMARTCARD:
            info = [NSString stringWithFormat:@"0x%08x:The operation requires a Smart Card, but no Smart Card is currently in the device.", ret];
            break;
            
        case SCARD_E_INVALID_VALUE:
            info = [NSString stringWithFormat:@"0x%08x:One or more of the supplied parameters values could not be properly interpreted.", ret];
            break;
            
        case SCARD_F_COMM_ERROR:
            info = [NSString stringWithFormat:@"0x%08x:An internal communications error has been detected.", ret];
            break;
            
        case SCARD_E_NOT_TRANSACTED:
            info = [NSString stringWithFormat:@"0x%08x:An attempt was made to end a non-existent transaction.", ret];
            break;
            
        case SCARD_E_READER_UNAVAILABLE:
            info = [NSString stringWithFormat:@"0x%08x:The specified reader is not currently available for use.", ret];
            break;
            
        case SCARD_E_READER_UNSUPPORTED:
            info = [NSString stringWithFormat:@"0x%08x:The reader driver does not meet minimal requirements for support.", ret];
            break;
            
        case SCARD_E_CARD_UNSUPPORTED:
            info = [NSString stringWithFormat:@"0x%08x:The smart card does not meet minimal requirements for support.", ret];
            break;
            
        default:
            info = [NSString stringWithFormat:@"0x%08x:Unknown error", ret];
            break;
    }
    
    return info;
}

@end
