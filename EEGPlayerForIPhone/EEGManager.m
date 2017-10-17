//
//  EEGManager.m
//  BlueTooth
//
//  Created by 凤凰八音 on 16/1/21.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "EEGManager.h"
#import "DeviceInfoModel.h"
#import "BluetoothManager.h"

static NSString * const kLastConnectedDeviceName = @"lastConnectedDeviceName";
static NSTimeInterval kScanTimeInterval = 6;
static NSTimeInterval kScanDelay = 3;
static NSInteger kValieScanCount = 6;



@interface EEGManager (){
    NSString *_lastConnectedName;
}

/** 扫描的的设备 */
@property (nonatomic, strong) NSMutableArray *peripheals;

/** 扫描计时器 */
@property (nonatomic, strong) NSTimer *scanTimer;

/** 最后一次连接状态 */
@property (nonatomic, assign, getter=isLastConnected) BOOL lastConnected;

@end

static EEGManager *_sharedManager = nil;


@implementation EEGManager

#pragma mark -
#pragma mark 单例初始化
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [super allocWithZone:zone];
    });
    return _sharedManager;
}

+ (instancetype)sharedManager {
    if (!_sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedManager = [[EEGManager alloc] init];
        });
    }
    return _sharedManager;
}

#pragma mark -
#pragma mark - 定时扫描

- (void)startScan {
    [self rescanAfterDelay:kScanTimeInterval];
}

// 获取一次体温数据 （扫描2s，查找选中的蓝牙，取出数据）
- (void)scanForTemperatureWithIdentifier {
    
    // 扫描 1秒
    
    BluetoothManager *BLE = [BluetoothManager sharedManager];
    
    [BLE scanForPeripheralsByInterval:kScanDelay completion:^(NSArray *devices) {
        
        //        NSLog(@"devices = %@", devices);
        // 保存扫描到的蓝牙设备
        //        [self.peripheals removeAllObjects];
        self.peripheals = [NSMutableArray arrayWithArray:devices];
        
        if (self.scanCompletionHandler) {
            self.scanCompletionHandler(devices);
        }
        
        
        if ([self.delegate respondsToSelector:@selector(manager:didScanedDevices:)]) {
            [self.delegate manager:self didScanedDevices:devices];
        }
        
        
        [self handleDataWithPeriphealArray:devices];
    }];
}

// 循环扫描
- (void)rescanAfterDelay:(NSTimeInterval)time {
    
    if (time <= 2) {
        time = 2;
    }
    
    
    [self invalidTimer:self.scanTimer reasion:@"取消上次扫描"];
    
    [self scanForTemperatureWithIdentifier];
    
    // 每隔 10s 再扫描一次
    self.scanTimer = [NSTimer timerWithTimeInterval:time
                                             target:self
                                           selector:@selector(scanForTemperatureWithIdentifier)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.scanTimer forMode:NSRunLoopCommonModes];
}

// 处理扫描到的设备和数据
- (void)handleDataWithPeriphealArray:(NSArray *)peripherals{
    
    BOOL connectToDevice = NO;
    
    NSData *advertisementData = nil;
    
    DeviceInfoModel *selectedDevice = nil;
    
    // 0. 未选择设备，无需处理
    if (!self.lastConnectedName) {
        return;
    }
    
    // 1. 通过无效扫描次数判断连接状态
    if (peripherals.count == 0) { // 扫描不到设备
        self.invalidScanCount++;
        connectToDevice = NO;
    }
    else {
        for (NSInteger i = 0; i < peripherals.count; i++) {
            DeviceInfoModel *peripheral = peripherals[i];
            // 先搜索上次连接的设备
            if ([self.lastConnectedName isEqualToString:peripheral.deviceName]) {
                // 扫描到，就认为连接上
                connectToDevice = YES;
                self.invalidScanCount = 0;
                
                selectedDevice = peripheral;
                
                // 取出对应的广告数据
                advertisementData = peripheral.deviceData;
                
                break; // 扫描到第一个即可
            }
            else { // 扫描不到指定设备
                self.invalidScanCount++;
                connectToDevice = NO;
            }
            
        }
    }
    
    if (self.invalidScanCount>0) {
        NSLog(@"扫描不到设备，第 %d 次", self.invalidScanCount);
    }
    
    // 2. 处理连接状态
    if (connectToDevice) { // 连接成功
        
        // -> 解析数据
        Byte *bytes = (Byte *)[(NSData *)(advertisementData) bytes];
        
//        // 接触状态
//        int touchState = bytes[kBLEStateByte];
//        
//        // 体温
//        int hight = bytes[kBLETemHightByte];
//        int low = bytes[kBLETemLowByte];
//        float temperatureValue = hight + low*0.01;
//        
//        // 电压状态
//        int powerState = bytes[kBLEPower];
//        //        powerState = 0;
//        
//        // 版本号
//        int mainVer = bytes[kBLEVerMainByte];
//        int subVer = bytes[kBLEVerSubByte];
//        
//        HYTemperatureModel *tempModel = self.model;
//        tempModel.temperature = temperatureValue;
//        tempModel.touchState  = touchState;
//        tempModel.powerState  = powerState;
//        tempModel.mainVersion = mainVer;
//        tempModel.subVersion  = subVer;
        
        //        NSLog(@"tempModel = %@", tempModel);
        
        // -> 只处理首次连接成功
        if (!self.isLastConnected) {
            
            if (self.connectedHandler) {
//                self.connectedHandler(self.lastConnectedName, tempModel.version);
            }
            
            if ([self.delegate respondsToSelector:@selector(manager:didConnectedDevice:)]) {
                [self.delegate manager:self didConnectedDevice:selectedDevice];
            }
            
            // 标记上一次连接成功
            self.lastConnected = YES;
            
        }
        
        
//        if (tempModel.touchState == 255) {
//            self.invalidTouchCount++;
//        } else {
//            self.invalidTouchCount = 0;
//        }
        
        
        
    }
    else {  // 扫描不到
        //        if (self.invalidScanCount>=1 && self.model.touchState == 255) {
        //
        //            // 处理断开连接，但是不取消绑定
        //            [self handleDisconnectedAndUnbound:NO];
        //        }
        if (self.invalidScanCount>=kValieScanCount) {
            [self handleDisconnectedAndUnbound:NO];
        }
        
    }
    
}

#pragma mark -
#pragma mark 处理断开

- (void)handleDisconnectedAndUnbound:(BOOL)unbound {
    
    // 清除上次连接设备
    if (unbound) {
        self.lastConnectedName = nil;
    }
    
    // 处理连接断开
    if (self.isLastConnected) {
        
        if (self.disconnectedHandler) {
            self.disconnectedHandler(self.lastConnectedName);
        }
        
        if ([self.delegate respondsToSelector:@selector(managerDidDisconnected:)]) {
            [self.delegate managerDidDisconnected:self];
        }
        
    }
    
    self.invalidScanCount = 0;
//    self.invalidTouchCount = 0;
//    self.model = nil;
    self.lastConnected = NO; // 标记上次连接失败
//    self.handleCount = 0;
//    self.currentValue = 0.0f;
//    self.previousValue = 0.0f;
//    self.overHighAlertTemp = NO;
//    self.overLowAlertTemp = NO;
    
}

#pragma mark -
#pragma mark 异常状态处理
- (void)unbind {
    
    //    NSLog(@"======  取消绑定 ");
    // 加入测量过程，用户注销
    [self handleDisconnectedAndUnbound:YES];
}

#pragma mark -
#pragma mark 停止计时
- (void)invalidTimer:(NSTimer *)timer reasion:(NSString *)reasion {
    if (timer) {
        if (timer.isValid) {
            [timer invalidate];
            if (reasion) {
                NSLog(@"停止计时：%@", reasion);
            }
        }
        
        timer = nil;
    }
}

#pragma mark -
#pragma mark - Getter && Setter
- (void)setLastConnectedName:(NSString *)lastConnectedName {
    _lastConnectedName = [lastConnectedName copy];
    
    // 保存最后连接的设备名
    NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
    [userDefs setObject:_lastConnectedName forKey:kLastConnectedDeviceName];
    [userDefs synchronize];
}

- (NSString *)lastConnectedName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLastConnectedDeviceName];
}

//- (HYTemperatureModel *)model {
//    if (!_model) {
//        _model = [[HYTemperatureModel alloc] init];
//    }
//    return _model;
//}

- (BOOL)isConnected {
    return self.isLastConnected;
}
@end
