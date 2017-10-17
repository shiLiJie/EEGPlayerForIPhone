//
//  BluetoothManager.h
//  PCIM
//
//  Created by 凤凰八音 on 16/1/25.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceInfoModel.h"

typedef void (^BYCompleteBlock) (NSArray *devices);

@interface BluetoothManager : NSObject

@property (nonatomic, getter = isScanning) BOOL scanning;
@property (assign, nonatomic, readonly, getter = isCentralReady) BOOL centralReady;
@property (strong, nonatomic, readonly) NSString *stateInfo;
@property (strong, nonatomic, readonly) NSArray *peripherals;
@property (strong, nonatomic, readonly) NSArray *datas;



/**
 *  蓝牙扫描单例
 *
 *  @return 蓝牙扫描单例
 */
+ (instancetype)sharedManager;

/**
 *  限时扫描所有设备
 *
 *  @param aScanInterval 扫描时间
 *  @param aCallback     完成回调
 */
- (void)scanForPeripheralsByInterval:(NSUInteger)aScanInterval
                          completion:(BYCompleteBlock)aCallback;

/**
 *  停止扫描
 */
- (void)stopScanForPeripherals;

@end
