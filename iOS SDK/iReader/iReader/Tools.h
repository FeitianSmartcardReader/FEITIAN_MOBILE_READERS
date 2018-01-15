//
//  Tools.h
//  eID Viewer
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+(instancetype)shareTools;
-(void)showMsg:(NSString *)msg;
-(void)showError:(long)errorCode;
-(NSArray *)apduArray;
-(void)hideMsgView;
-(NSData *)readFileContent:(NSString *)fileName;
-(NSArray *)commandArray;
@end
