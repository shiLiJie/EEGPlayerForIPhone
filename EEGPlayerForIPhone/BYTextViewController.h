//
//  BYTextViewController.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/6/30.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extend.h"
#import "popView.h"
#import "AppDelegate.h"
#import "BYEEGDataModel.h"
#import "BYBluetoothManager.h"


// the eSense values
typedef struct {
    int attention;
    int meditation;
} ESenseValues;

// the EEG power bands
typedef struct {
    int delta;
    int theta;
    int lowAlpha;
    int highAlpha;
    int lowBeta;
    int highBeta;
    int lowGamma;
    int highGamma;
} EEGValues;
@interface BYTextViewController : UIViewController<BTSmartSensorDelegate,PopDriverDelegate,UITableViewDelegate,UITableViewDataSource>

{
    short rawValue;
    int rawCount;
    int buffRawCount;
    int blinkStrength;
    int poorSignalValue;
    int heartRate;
    float respiration;
    int heartRateAverage;
    int heartRateAcceleration;
    
    ESenseValues eSenseValues;
    EEGValues eegValues;
    
    bool logEnabled;

    NSMutableData * output;
    
    UIView * loadingScreen;
    
    NSThread * updateThread;
    
}

@property (strong, nonatomic) BYBluetoothManager *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;


- (UIImage *)updateSignalStatus;

@end
