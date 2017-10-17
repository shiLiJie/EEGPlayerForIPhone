//
//  BluetoothManager.h
//  EEGSDK
//
//  Created by 凤凰八音 on 16/8/15.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID     0xFFE0
#define CHAR_UUID        0xFFE1

@protocol BTSmartSensorDelegate

@optional
/**
 *  搜索周边设备
 *
 *  @param peripheral 设备信息
 */
- (void) peripheralFound:(CBPeripheral *)peripheral;

/**
 *  获取版本号方法
 *
 *  @param version 版本号
 */
-(void) getDeviceVersion:(NSString *)version;

/**
 *  接收解析周边广播
 *
 *  @param UUID UUID //不用传值
 *  @param data 广播数据
 */
- (void) serialGATTCharValueUpdated:(NSString *)UUID
//                              value:(NSData *)data
                           getDelta:(int)delta
                           LowAlpha:(int)LowAlpha
                            LowBeta:(int)LowBeta
                           LowGamma:(int)LowGamma
                        MiddleGamma:(int)MiddleGamma
                              Theta:(int)Theta
                          highAlpha:(int)highAlpha
                           highBeta:(int)highBeta
                          Attention:(int)Attention
                         Meditation:(int)Meditation
                             singel:(int)singel
                           Original:(int)Original
                            version:(NSString *)version;

/**
 *  获取原始脑波数据
 *
 *  @param Original 获取原始脑波数据,不用上边的方法
 */
-(void)getOriginalValue:(int)Original;
/**
 *  刷新原始脑波视图
 */
-(void)reloadOriginalView;

/**
 *  连接
 */
- (void) setConnect;

/**
 *  断开连接
 */
- (void) setDisconnect;
@end


@interface BYBluetoothManager : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>
//代理属性
@property (nonatomic, assign) id <BTSmartSensorDelegate> delegate;

//存放搜索到的设备的可变数组
@property (strong, nonatomic) NSMutableArray *peripherals;
//蓝牙中心
@property (strong, nonatomic) CBCentralManager *manager;
//周边设备
@property (strong, nonatomic) CBPeripheral *activePeripheral;
//设备服务
@property (strong, nonatomic) CBService *findeService;
//设备特征值
@property (strong, nonatomic) CBCharacteristic *fincharater;
//设备UUID
@property (strong, nonatomic) CBUUID *finduuid;
//储存接收到的数据
@property (copy, nonatomic) NSString *receivedData;
//版本号
@property (copy, nonatomic) NSString *version;
//判断是否连接
@property (nonatomic, assign) BOOL isConnect;
//脑波输出的数据
@property (nonatomic, strong) NSMutableData * output;

@property (nonatomic, assign) BOOL oldReadingStop;
/**
 *  创建单例
 *
 *  @return 单例对象
 */
+ (instancetype)sharedManager;
#pragma mark - Methods for controlling the BLKApp Sensor
/*
 * 设置
 * 设置 SerialGATT 成为 CoreBluetooth CentralManager 的代理
 *
 */
-(void) setup;

/*
 * -(int) 搜索周边设备超时
 *
 */
-(int) findBLKAppPeripherals:(int)timeout;

/*
 * scanTimer
 * 当 findblkappperipherals 超时时，这个函数将被调用
 *
 */
-(void) scanTimer: (NSTimer *)timer;

/*
 * 连接
 * 连接到给定的外围设备
 *
 */
-(void) connect: (CBPeripheral *)peripheral;

/*
 * 连接
 * 断开指定的设备
 *
 */
-(void) disconnect: (CBPeripheral *)peripheral;



#pragma mark - 基本操作
/**
 *  读取固件版本号命令
 */

-(void)ReadFirmwareVersion;
/**
 *  配置时间命令
 */
-(void)ConfigurationTime;

/**
 *  清空sd卡数据命令
 */
-(void)clearData;

/**
 *  开始接收数据命令
 */
-(void)startText;

/**
 *  停止接收数据命令
 */
-(void)stopText;

/**
 *  读特征值
 *
 *  @param peripheral 类对象, 在setconnect里调用
 */
-(void) read:(CBPeripheral *)peripheral;

/**
 *  回顾历史数据首先调用的方法
 *
 *  @param path 路径
 */
- (void)readingData:(NSString *)path;

@end
