//
//  EEGManager.h
//  PCIM
//
//  Created by 凤凰八音 on 16/1/25.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfoModel.h"

@class EEGManager;


@protocol EEGManagerDelegate <NSObject>

@optional
- (void)manager:(EEGManager *)manager didScanedDevices:(NSArray *)devices;
- (void)manager:(EEGManager *)manager didConnectedDevice:(DeviceInfoModel *)deviceInfo;

- (void)managerDidDisconnected:(EEGManager *)manager;

@end
@interface EEGManager : NSObject

/** 代理 */
@property (nonatomic, weak) id<EEGManagerDelegate> delegate;

/**
 *  扫描完成回调
 *
 *  peripherals 是所有扫描到的设备
 *  rssis       信号强度
 */
@property (nonatomic, copy) void (^scanCompletionHandler) (NSArray *devices);

/**
 *  设备连接成功回调
 *
 *  peripherals     是连接的设备名称
 *  firmwareVersion 是连接的设备的固件版本号
 */
@property (nonatomic, copy) void (^connectedHandler) (NSString *deviceName, NSString *firmwareVersion);

/**
 *  断开处理Block
 *
 *  deviceName 设备名称
 */
@property (nonatomic, copy) void (^disconnectedHandler) (NSString *deviceName);

/** 是否连接成功 */
@property (nonatomic, assign, getter=isConnected, readonly) BOOL connected;

/** 无效扫描次数 */
@property (nonatomic, assign) int invalidScanCount;

/**
 *  最后一次连接的设备名称
 */
@property (nonatomic, copy) NSString *lastConnectedName;

+ (instancetype)sharedManager;

/**
 *  开始扫描设备
 */
- (void)startScan;

/**
 *  停止测量
 */
- (void)unbind;
@end
