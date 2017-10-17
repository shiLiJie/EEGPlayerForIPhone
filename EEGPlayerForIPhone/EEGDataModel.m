//
//  EEGDataModel.m
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/11/11.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import "EEGDataModel.h"
static EEGDataModel *_sharedModel = nil;
@implementation EEGDataModel
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
#pragma mark - 私有方法 -
-(void)removeAllEEGData{
    
    [self.delta removeAllObjects];
    [self.theta removeAllObjects];
    [self.highalpha removeAllObjects];
    [self.lowalpha removeAllObjects];
    [self.hightbeta removeAllObjects];
    [self.lowbeta removeAllObjects];
    [self.highgamma removeAllObjects];
    [self.lowgamma removeAllObjects];
    [self.Attention removeAllObjects];
    [self.Meditation removeAllObjects];
    [self.singel removeAllObjects];
    
}

#pragma mark - 懒加载- 
-(int)index{
    if (!_index) {
        _index = 0;
    }
    return _index;
}

-(NSMutableArray *)delta{
    if (!_delta) {
        _delta = [[NSMutableArray alloc] init];
    }
    return _delta;
}

-(NSMutableArray *)theta{
    if (!_theta) {
        _theta = [[NSMutableArray alloc] init];
    }
    return _theta;
}

-(NSMutableArray *)lowalpha{
    if (!_lowalpha) {
        _lowalpha = [[NSMutableArray alloc] init];
    }
    return _lowalpha;
}

-(NSMutableArray *)highalpha{
    if (!_highalpha) {
        _highalpha = [[NSMutableArray alloc] init];
    }
    return _highalpha;
}

-(NSMutableArray *)lowbeta{
    if (!_lowbeta) {
        _lowbeta = [[NSMutableArray alloc] init];
    }
    return _lowbeta;
}

-(NSMutableArray *)hightbeta{
    if (!_hightbeta) {
        _hightbeta = [[NSMutableArray alloc] init];
    }
    return _hightbeta;
}

-(NSMutableArray *)lowgamma{
    if (!_lowgamma) {
        _lowgamma = [[NSMutableArray alloc] init];
    }
    return _lowgamma;
}

-(NSMutableArray *)highgamma{
    if (!_highgamma) {
        _highgamma = [[NSMutableArray alloc] init];
    }
    return _highgamma;
}

-(NSMutableArray *)Attention{
    if (!_Attention) {
        _Attention = [[NSMutableArray alloc] init];
    }
    return _Attention;
}

-(NSMutableArray *)Meditation{
    if (!_Meditation) {
        _Meditation = [[NSMutableArray alloc] init];
    }
    return _Meditation;
}

-(NSMutableArray *)singel{
    if (!_singel) {
        _singel = [[NSMutableArray alloc] init];
    }
    return _singel;
}



@end
