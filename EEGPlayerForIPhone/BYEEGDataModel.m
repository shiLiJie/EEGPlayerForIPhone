//
//  BYEEGDataModel.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/22.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYEEGDataModel.h"

static BYEEGDataModel *_sharedModel = nil;

@implementation BYEEGDataModel

//单例初始化
+ (instancetype)sharedEEGData {
    if (!_sharedModel) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedModel = [[self alloc] init];
        });
    }
    return _sharedModel;
}

#pragma mark - 睡眠评估部分运算逻辑 -
//初始化睡眠评估部分数据
-(void)initSleepDataModel{
    self.sleepEvalArray = [[NSMutableArray alloc] init];
    self.sleepCount = 1;
    self.maxSleepValue = 0;
    
    self.theatArr = [[NSMutableArray alloc] init];
    self.lowaArr = [[NSMutableArray alloc] init];
    self.highaArr = [[NSMutableArray alloc] init];
    self.lowbArr = [[NSMutableArray alloc] init];
    self.highbArr = [[NSMutableArray alloc] init];
    self.lowgArr = [[NSMutableArray alloc] init];
    self.highgArr = [[NSMutableArray alloc] init];
    self.dertaArr = [[NSMutableArray alloc] init];
    self.guanzhuArr = [[NSMutableArray alloc] init];
    self.mingxiangArr = [[NSMutableArray alloc] init];
    
    self.theatMax = 0;
    self.lowaMax = 0;
    self.highaMax = 0;
    self.lowbMax = 0;
    self.highbMax = 0;
    self.lowgMax = 0;
    self.highgMax = 0;
    self.dertaMax = 0;
    self.guanzhuMax = 0;
    self.mingxiangMax = 0;

}

//清空所有数据
-(void)remveAllData{
    //清空所有数据
    [self.sleepEvalArray removeAllObjects];
    self.sleepCount = 1;
    self.maxSleepValue = 0;
    
    [self.theatArr removeAllObjects];
    [self.lowaArr removeAllObjects];
    [self.highaArr removeAllObjects];
    [self.lowbArr removeAllObjects];
    [self.highbArr removeAllObjects];
    [self.lowgArr removeAllObjects];
    [self.highgArr removeAllObjects];
    [self.dertaArr removeAllObjects];
    [self.guanzhuArr removeAllObjects];
    [self.mingxiangArr removeAllObjects];
    
    self.theatMax = 0;
    self.lowaMax = 0;
    self.highaMax = 0;
    self.lowbMax = 0;
    self.highbMax = 0;
    self.lowgMax = 0;
    self.highgMax = 0;
    self.dertaMax = 0;
    self.guanzhuMax = 0;
    self.mingxiangMax = 0;
}

//睡眠 gamma 波持续高于 10000 表示睡眠不好
-(void)sleepGamma{
    //元素加到 arrsleep 数组里, sleepCount默认是1,如果最后一个元素小于 10000
    if (self.sleepEvalArray.count == self.sleepCount && [self.sleepEvalArray[self.sleepCount - 1] integerValue] < 10000) {
        //那么数组移除全部元素
        [self.sleepEvalArray removeAllObjects];
        //睡眠计数还原成 1
        self.sleepCount = 1;
    }else{
        //大于 10000 sleepCount递加
//        NSLog(@"%ld",(long)[self.sleepEvalArray[self.sleepCount - 1] integerValue]);
        self.sleepCount ++;
//        NSLog(@"%d",self.sleepCount);
        
    }
    //元素个数大于五个
    if (self.sleepCount >= 5) {
        //从新开始记录
        self.sleepCount = 1;
//        NSLog(@"11111111111111111111111111");
        //去5个之中的最大值
        NSNumber *max = [self.sleepEvalArray valueForKeyPath:@"@max.floatValue"];
        //如果比已经记录的大就替换
        if (max > self.maxSleepValue) {
            self.maxSleepValue = max;            
            NSLog(@"%@",self.maxSleepValue);
        }
        [self.sleepEvalArray removeAllObjects];
    }
}

//在有噪音的情况下调用,删除错误数据
-(void)deletaWrongData{
    //训练排除错误信号
    //如果三个存平均值的数组有值得话, 就移除最后一个元素
    if (self.theatArr.count > 0 && self.theatArr.count < 10) {
        [self.theatArr removeLastObject];
    }
    if (self.lowaArr.count > 0 && self.lowaArr.count < 10) {
        [self.lowaArr removeLastObject];
    }
    if (self.highaArr.count > 0 && self.highaArr.count < 10) {
        [self.highaArr removeLastObject];
    }
    if (self.highbArr.count > 0 && self.highbArr.count < 10) {
        [self.highbArr removeLastObject];
    }
    if (self.highgArr.count > 0 && self.highgArr.count < 10) {
        [self.highgArr removeLastObject];
    }
    if (self.lowbArr.count > 0 && self.lowbArr.count < 10) {
        [self.lowbArr removeLastObject];
    }
    if (self.lowgArr.count > 0 && self.lowgArr.count < 10) {
        [self.lowgArr removeLastObject];
    }
    if (self.dertaArr.count > 0 && self.dertaArr.count < 10) {
        [self.dertaArr removeLastObject];
    }
    if (self.guanzhuArr.count > 0 && self.guanzhuArr.count < 10) {
        [self.guanzhuArr removeLastObject];
    }
    if (self.mingxiangArr.count > 0 && self.mingxiangArr.count < 10) {
        [self.mingxiangArr removeLastObject];
    }
    //睡眠评估排除错误信号
    //那么数组移除全部元素
    [self.sleepEvalArray removeAllObjects];
    //睡眠计数还原成 1
    self.sleepCount = 1;
}


/**
 *  取出十秒有效数据的最大值
 *
 *  @param getObject 当前的脑波数据
 *  @param valueArr  存放数据的数组
 *
 *  @return 最大值
 */
-(NSNumber *)maxValue:(int)getObject valueArr:(NSMutableArray *)valueArr{
    
    NSNumber *maxValue = 0;
    
    //如果数组长度 == 11
    if (valueArr.count == 11) {
        //移除最后一个剩下10个
        [valueArr removeLastObject];
        //求出最大值
        maxValue = [valueArr valueForKeyPath:@"@avg.floatValue"];
    }
    NSNumber *num = [NSNumber numberWithInt:getObject];
    //向数组中添加脑波数据
    [valueArr addObject:num];
    
    return maxValue;
}


@end
