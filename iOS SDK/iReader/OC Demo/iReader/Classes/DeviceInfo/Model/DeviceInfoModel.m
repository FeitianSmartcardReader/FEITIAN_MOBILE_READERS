//
//  DeviceInfoModel.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "DeviceInfoModel.h"

@implementation DeviceInfoModel

-(instancetype)initWithKey:(NSString *)key value:(NSString *)value
{
    if(self = [super init]){
        
        self.deviceInfoKey = key;
        self.deviceInfoValue = value;
    }
    
    return self;
}

+(instancetype)deviceInfoModelWithKey:(NSString *)key value:(NSString *)value
{
    return [[self alloc] initWithKey:key value:value];
}
@end
