//
//  BYTrainReportVc.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/6.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYTrainReportVc : UIViewController


@property (nonatomic, copy) NSString *totalTime;//训练总时长
@property (nonatomic, assign) NSString *musicTime;//开启音乐总时长
@property (nonatomic, copy) NSString *stateLabText;//状态栏评价

@property (nonatomic, assign) int xiangshiCount;//想事总次数/时长
@property (nonatomic, assign) int jiujieCount;//纠结
@property (nonatomic, assign) int yunzhuanCount;//运转
@property (nonatomic, assign) int pingjingCount;//平静
@property (nonatomic, assign) int fangsongCount;//放松
@property (nonatomic, assign) int buxihuanCount;//不喜欢
@end
