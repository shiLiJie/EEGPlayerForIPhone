//
//  AppDelegate.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/6/27.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const failureCoder;
extern NSString *const succeedCoder;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//0
-(void)goToConnectBlue;

//1
-(void)goSleepChangeOneVc;

//控制器2是占位控制器,不操作

//3
-(void)goRelaxMusic;

//4
-(void)goToPersonal;
@end

