//
//  EEGDataModel.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/11/11.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EEGDataModel : NSObject

//每次二十秒数据的数组
@property (nonatomic, strong) NSMutableArray *delta;
@property (nonatomic, strong) NSMutableArray *theta;
@property (nonatomic, strong) NSMutableArray *lowalpha;
@property (nonatomic, strong) NSMutableArray *highalpha;
@property (nonatomic, strong) NSMutableArray *lowbeta;
@property (nonatomic, strong) NSMutableArray *hightbeta;
@property (nonatomic, strong) NSMutableArray *lowgamma;
@property (nonatomic, strong) NSMutableArray *highgamma;
@property (nonatomic, strong) NSMutableArray *Attention;
@property (nonatomic, strong) NSMutableArray *Meditation;
@property (nonatomic, strong) NSMutableArray *singel;


+ (instancetype)sharedEEGData;
//发送数据带的索引,标记次数
@property (nonatomic, assign) int index;

//清楚二十秒数据的数据,进行下一个二十秒赋值
-(void)removeAllEEGData;

@end
