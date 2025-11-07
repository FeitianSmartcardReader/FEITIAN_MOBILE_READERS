//
//  commandModel.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "commandModel.h"

@implementation commandModel

-(instancetype)initWithName:(NSString *)name image:(NSString *)image
{
    if(self = [super init]){
        self.commandName = name;
        self.commandImage = image;
    }
    
    return self;
}

+(instancetype)commandModelWithName:(NSString *)commandName image:(NSString *)commandImage
{
    return [[self alloc] initWithName:commandName image:commandImage];
}
@end
