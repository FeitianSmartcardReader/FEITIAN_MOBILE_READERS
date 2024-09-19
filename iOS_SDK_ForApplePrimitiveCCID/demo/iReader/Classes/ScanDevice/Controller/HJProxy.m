//
//  HJProxy.m
//  iReader
//
//  Created by Jermy on 2019/2/20.
//  Copyright © 2019年 ft. All rights reserved.
//

#import "HJProxy.h"

@interface HJProxy()
@property (weak, nonatomic) id target;
@end

@implementation HJProxy

+(instancetype)proxyWithTarget:(id)target
{
    HJProxy *proxy = [[HJProxy alloc] init];
    proxy.target = target;
    return proxy;
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;                                                                                                                                                                      
}

@end
