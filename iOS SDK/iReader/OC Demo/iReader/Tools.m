//
//  Tools.m
//  eID Viewer
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "Tools.h"
#import "commandModel.h"
#import "SVProgressHUD.h"

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

-(void)showMsg:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:msg maskType:SVProgressHUDMaskTypeBlack];
    });
}

-(void)hideMsgView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

-(void)showError:(long)errorCode
{
    NSString *errorMsg = [NSString stringWithFormat:@"error: %08x",errorCode];
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:errorMsg maskType:SVProgressHUDMaskTypeClear];
    });
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

-(NSArray *)commandArray
{
    commandModel *model2 = [commandModel commandModelWithName:@"writeFlash" image:@"WriteFlash"];
    commandModel *model3 = [commandModel commandModelWithName:@"readFlash" image:@"ReadFlash"];
    commandModel *model1 = [commandModel commandModelWithName:@"readUID" image:@"UID"];
    
    return @[model1, model2 ,model3];
}

-(NSArray *)apduArray
{
    return
    
  @[@"0084000008",
    @"008400007F",
    @"00A4040008D156000001010301",
    @"00A40000023F00",
    @"00e4010002a001",
    @"00e00000186216820238008302a00185020000860800000000000000ff",
    @"00A4000002A001",
    @"00E00000186216820201018302B001850200ff86080000000000000000",
 @"00D60000FA00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849",
 @"00D60000FB0001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061626364656667686970717273747576777879808182838485868788899091929394959697989900010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950",
 @"00D60000FF000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061626364656667686970717273747576777879808182838485868788899091929394959697989900010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354",
    @"00b00000FF",
    @"00A40000023F00",
    @"00A4000002A001",
    @"00e4020002B001",
    @"00A40000023F00",
    @"00e4010002a001"
    ];
}

@end
