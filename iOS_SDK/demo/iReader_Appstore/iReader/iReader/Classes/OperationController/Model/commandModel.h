//
//  commandModel.h
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commandModel : NSObject
@property (nonatomic, copy) NSString *commandName;
@property (nonatomic, copy) NSString *commandImage;

+(instancetype)commandModelWithName:(NSString *)commandName image:(NSString *)commandImage;
@end
