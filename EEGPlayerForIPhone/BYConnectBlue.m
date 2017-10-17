//
//  BYConnectBlue.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/6.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYConnectBlue.h"

static BYConnectBlue *_sharedModel = nil;

@implementation BYConnectBlue
+ (instancetype)sharedConnect {
    if (!_sharedModel) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedModel = [[self alloc] init];
        });
    }
    return _sharedModel;
}
@end
