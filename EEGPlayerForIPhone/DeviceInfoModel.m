//
//  DeviceInfoModel.m
//  PCIM
//
//  Created by 凤凰八音 on 16/1/25.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "DeviceInfoModel.h"

@implementation DeviceInfoModel

+ (instancetype)device {
    return [[self alloc] init];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"< name: %@, UUID: %@, RSSI: %@ >", self.deviceName, self.deviceID, self.deviceRSSI];
}

@end
