//
//  readerModel.h
//  iReader
//
//  Copyright © 1998-2019, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface readerModel : NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, strong) NSDate *date;

+(instancetype)modelWithName:(NSString *)name scanDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
