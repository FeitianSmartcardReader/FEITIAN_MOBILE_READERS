//
//  DeviceInfoModel.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoModel : NSObject
@property (nonatomic, copy)NSString *deviceInfoKey;
@property (nonatomic, copy)NSString *deviceInfoValue;

+(instancetype)deviceInfoModelWithKey:(NSString *)key value:(NSString *)value;
@end
