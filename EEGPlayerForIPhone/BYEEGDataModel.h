//
//  BYEEGDataModel.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/22.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <Foundation/Foundation.h>

//这个模型为了给猫头鹰出提示框用的

@interface BYEEGDataModel : NSObject

@property (nonatomic, strong) NSMutableArray *sleepEvalArray;//睡眠评估
@property (nonatomic, assign) NSNumber *maxSleepValue;//睡眠评估状态下的最高值
@property (nonatomic, assign) int sleepCount;//连续五次的次数

//保存前十秒钟数值的数组 theat 阿尔法波
@property (nonatomic, strong) NSMutableArray *theatArr;
@property (nonatomic, strong) NSMutableArray *lowaArr;
@property (nonatomic, strong) NSMutableArray *highaArr;
@property (nonatomic, strong) NSMutableArray *lowbArr;
@property (nonatomic, strong) NSMutableArray *highbArr;
@property (nonatomic, strong) NSMutableArray *lowgArr;
@property (nonatomic, strong) NSMutableArray *highgArr;
@property (nonatomic, strong) NSMutableArray *dertaArr;
@property (nonatomic, strong) NSMutableArray *guanzhuArr;
@property (nonatomic, strong) NSMutableArray *mingxiangArr;

//十秒之内的最大值
@property (nonatomic, copy) NSNumber *theatMax;
@property (nonatomic, copy) NSNumber *lowaMax;
@property (nonatomic, copy) NSNumber *highaMax;
@property (nonatomic, copy) NSNumber *lowbMax;
@property (nonatomic, copy) NSNumber *highbMax;
@property (nonatomic, copy) NSNumber *lowgMax;
@property (nonatomic, copy) NSNumber *highgMax;
@property (nonatomic, copy) NSNumber *dertaMax;
@property (nonatomic, copy) NSNumber *guanzhuMax;
@property (nonatomic, copy) NSNumber *mingxiangMax;

+ (instancetype)sharedEEGData;


//初始化睡眠评估的数据
-(void)initSleepDataModel;
//清空数据
-(void)remveAllData;
//睡眠评估数据运算
-(void)sleepGamma;
//删除错误数据
-(void)deletaWrongData;

-(NSNumber *)maxValue:(int)getObject valueArr:(NSMutableArray *)valueArr;

@end
