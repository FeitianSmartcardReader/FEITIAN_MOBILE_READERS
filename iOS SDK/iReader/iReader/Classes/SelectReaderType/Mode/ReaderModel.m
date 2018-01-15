//
//  ReaderModel.m
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import "ReaderModel.h"

@implementation ReaderModel

-(instancetype)initWithImage:(NSString *)image title:(NSString *)title
{
    if(self = [super init]){
        _title = title;
        _image = image;
    }
    
    return self;
}

+(instancetype)ReaderModelWithImage:(NSString *)image title:(NSString *)title
{
    return [[self alloc] initWithImage:image title:title];
}

@end
