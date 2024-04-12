//
//  readerModel.m
//  iReader
//
//  Copyright © 1998-2019, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "readerModel.h"

@implementation readerModel

-(instancetype)initWithName:(NSString *)name date:(NSDate *)date
{
    self = [super init];
    self.name = name;
    self.date =date;
    return self;
}

+(instancetype)modelWithName:(NSString *)name scanDate:(NSDate *)date
{
    return [[self alloc] initWithName:name date:date];
}
@end
