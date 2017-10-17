//
//  BYSleepViewController.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/5.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BYSleepViewDelegate <NSObject>

//第一阶段代理方法
- (void)starStage;
- (void)oneStage;
- (void)twoStage;
- (void)thrStage;
- (void)fouStage;
- (void)fivStage;
- (void)stopStage;
@end

@interface BYSleepViewController : UIViewController

@property (nonatomic, assign) id <BYSleepViewDelegate> delegate;

@end
