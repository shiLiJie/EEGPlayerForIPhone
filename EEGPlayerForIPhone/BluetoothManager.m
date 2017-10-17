//
//  BluetoothManager.m
//  PCIM
//
//  Created by 凤凰八音 on 16/1/25.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BluetoothManager.h"

@interface BluetoothManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong)CBCentralManager           *manager;   //中央
@property (nonatomic)        CBCentralManagerState       centralManagerState;//中央状态


@property (nonatomic, strong)NSMutableArray             *scannedPeripherals;
@property (nonatomic, strong)NSMutableArray             *advertisementDataArray;
@property (nonatomic, strong)NSMutableArray             *rssiArray;

/** 所有扫描到的设备 */
@property (nonatomic, strong) NSMutableArray *devices;

@property (assign, nonatomic)NSUInteger                  peripheralsCountToStop;

@property (copy, nonatomic) BYCompleteBlock scanFinishedBlock;

@end


@implementation BluetoothManager

#pragma mark - 接口方法

// 扫描指定服务的设备
- (void)scanForPeripheralsWithServices:(NSArray *)serviceUUIDs
                               options:(NSDictionary *)options {
    [self.scannedPeripherals removeAllObjects];
    //    [self.advertisementDataArray removeAllObjects];
    //    [self.rssiArray removeAllObjects];
    
    [self.devices removeAllObjects];
    
    self.scanning = YES;
    [self.manager scanForPeripheralsWithServices:serviceUUIDs
                                         options:options];
}

// 开始扫描（所有设备）
- (void)scanForPeripherals {
    [self scanForPeripheralsWithServices:nil
                                 options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
}

// 停止扫描，回调
- (void)stopScanForPeripherals {
    // 先取消上次操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(stopScanForPeripherals)
                                               object:nil];
    
    self.scanning = NO;
    [self.manager stopScan];
    if (self.scanFinishedBlock) {
        self.scanFinishedBlock(self.devices);
    }
    self.scanFinishedBlock = nil;
}

// 限时扫描指定服务的设备，回调
- (void)scanForPeripheralsByInterval:(NSUInteger)aScanInterval
                            services:(NSArray *)serviceUUIDs
                             options:(NSDictionary *)options
                          completion:(BYCompleteBlock)aCallback {
    self.scanFinishedBlock = aCallback;
    // 开始扫描
    [self scanForPeripheralsWithServices:serviceUUIDs
                                 options:options];
    
    // 延时 aScanInterval 后，再次取消扫描
    [self performSelector:@selector(stopScanForPeripherals)
               withObject:nil
               afterDelay:aScanInterval];
}


// 限时扫描（所有设备），回调
- (void)scanForPeripheralsByInterval:(NSUInteger)aScanInterval
                          completion:(BYCompleteBlock)aCallback {
    [self scanForPeripheralsByInterval:aScanInterval
                              services:nil
                               options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}
                            completion:aCallback];
}



#pragma mark - Setter and Getter
- (BOOL)isCentralReady {
    return (self.manager.state == CBCentralManagerStatePoweredOn);
}

- (NSString *)stateInfo {
    return [self stateMessage];
}

- (NSArray *)peripherals {
    return [self.scannedPeripherals copy];
}

- (NSArray *)datas {
    return [self.advertisementDataArray copy];
}


- (NSMutableArray *)scannedPeripherals {
    if (!_scannedPeripherals) {
        _scannedPeripherals = [NSMutableArray array];
    }
    return _scannedPeripherals;
}

- (NSMutableArray *)advertisementDataArray {
    if (!_advertisementDataArray) {
        _advertisementDataArray = [NSMutableArray array];
    }
    return _advertisementDataArray;
}

- (NSMutableArray *)rssiArray {
    if (!_rssiArray) {
        _rssiArray = [NSMutableArray array];
    }
    return _rssiArray;
}

- (NSMutableArray *)devices {
    if (!_devices) {
        _devices = [NSMutableArray array];
    }
    return _devices;
}


#pragma mark -
#pragma mark - Private Methods
- (NSString *)stateMessage {
    NSString *message = nil;
    switch (self.manager.state) {
        case CBCentralManagerStateUnsupported:
            message = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            message = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnknown:
            message = @"Central not initialized yet.";
            break;
        case CBCentralManagerStatePoweredOff:{
            message = @"Bluetooth is currently powered off.";
        }
            break;
        case CBCentralManagerStatePoweredOn:
            break;
        default:
            break;
    }
    return message;
}


#pragma mark -
#pragma mark CBCentralManagerDelegate

// 蓝牙状态改变
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    self.centralManagerState = central.state;
    NSString *message = [self stateMessage];
    if (message) {
        NSLog(@"本机蓝牙状态：%@", message);
    }
}

// 发现设备
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    
    // 只添加 TEM 开头的设备
    if (![self.scannedPeripherals containsObject:peripheral] && [peripheral.name hasPrefix:@"TEM"]) {
        // 保存设备，广告数据
        [self.scannedPeripherals     addObject:peripheral];
        //        [self.advertisementDataArray addObject:advertisementData];
        //        [self.rssiArray              addObject:RSSI];
        
        DeviceInfoModel *device = [DeviceInfoModel device];
        device.deviceName = peripheral.name;
        device.deviceData = advertisementData[@"kCBAdvDataManufacturerData"];
        device.deviceID = [peripheral.identifier UUIDString];
        device.deviceRSSI = [NSString stringWithFormat:@"%@", RSSI];
        [self.devices addObject:device];
    }
    
    // 扫描到一定数量后 停止扫描
    if ([self.scannedPeripherals count] >= self.peripheralsCountToStop) {
        [self stopScanForPeripherals];
    }
}


#pragma mark - 初始化方法
static BluetoothManager *_sharedManager = nil;
+ (instancetype)sharedManager {
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedManager = [[BluetoothManager alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self
                                                        queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        _centralManagerState  = _manager.state;
        _peripheralsCountToStop = NSUIntegerMax;
    }
    return self;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [super allocWithZone:zone];
    });
    
    return _sharedManager;
}

@end
