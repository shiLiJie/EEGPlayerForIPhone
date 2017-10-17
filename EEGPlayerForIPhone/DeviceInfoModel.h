//
//  DeviceInfoModel.h
//  PCIM
//
//  Created by 凤凰八音 on 16/1/25.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoModel : NSObject

/** deviceName */
@property (nonatomic, copy) NSString *deviceName;
/** deviceID */
@property (nonatomic, copy) NSString *deviceID;
/** data */
@property (nonatomic, strong) NSData *deviceData;
/** deviceRSSI */
@property (nonatomic, copy) NSString *deviceRSSI;

+ (instancetype)device;

@end
