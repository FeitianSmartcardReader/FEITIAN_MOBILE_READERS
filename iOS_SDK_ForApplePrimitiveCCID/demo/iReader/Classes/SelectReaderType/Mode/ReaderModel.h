//
//  ReaderModel.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReaderModel : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *image;

+(instancetype)ReaderModelWithImage:(NSString *)image title:(NSString *)title;

@end
