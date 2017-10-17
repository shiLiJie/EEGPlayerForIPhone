//
//  BYWorkTools.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/6/22.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UserObj.h"
#import "UserTool.h"
#import <AVFoundation/AVFoundation.h>
#import "FMDB.h"
#import "BYTextViewController.h"

@interface BYWorkTools : NSObject

@property (nonatomic, assign)float score;

/**
 *  单例方法
 *
 *  @return 单例方法
 */
+ (instancetype)sharedTools;


/**
 *  获取当前时间
 *
 *  @return 返回固定格式时间字符串
 */
- (NSString *)getTimeNow;


/**
 *  十六进制转换为普通字符串
 *
 *  @param hexString 十六进制
 *
 *  @return 普通字符串
 */
- (NSString *)stringFromHexString:(NSString *)hexString;


/**
 *  弹出登录界面的动画
 *
 *  @param view 当前view
 *
 *  @return 返回动画
 */
-(CAKeyframeAnimation *)loginViewAnima:(UIView *)view;


/**
 *  按格式分解字符串
 *
 *  @param str 字符串
 *
 *  @return data
 */
- (NSMutableData *)huahsakdsa:(NSString *)str;


/**
 *  时间编码
 *
 *  @param tmpid 时间
 *
 *  @return 时间编码
 */
- (NSString *)ToHex:(NSInteger )tmpid;


//阿尔法脑波换图片功能和计分功能在这里, 都收集在工具类里
-(void)changeImageBBT:(NSMutableArray *)arraa
                arrbb:(NSMutableArray *)arrbb
                arrcc:(NSMutableArray *)arrcc
                arrdd:(NSMutableArray *)arrdd
                arree:(NSMutableArray *)arree
                arrff:(NSMutableArray *)arrff
                arrgg:(NSMutableArray *)arrgg
                arrhh:(NSMutableArray *)arrhh
            imageView:(UIImageView *)imageView
             scoreLab:(UILabel *)scoreLab;


/**
 *  创建txt和caf文件方法
 *
 *  @param fileName txt名称
 *  @param logFile  文件handle
 *
 *  @return av名称
 */
-(NSString *)creatAvFileName:(NSString *)fileName logFile:(NSFileHandle *)logFile;


/**
 *  工具类方法往db中存放数据
 *
 *  @param starTime  开始时间
 *  @param stoptime  停止时间
 *  @param output    数据
 *  @param nametotal 名称列表
 *  @param timetotal 时间列表
 */
-(void)insertDB:(NSString *)starTime
       stoptime:(NSString *)stoptime
         output:(NSMutableData *)output
      nametotal:(NSString *)nametotal
      timetotal:(NSString *)timetotal;


/**
 *  登录时记录用户信息
 */
-(void)changeUser:(BYTextViewController *)vc;


@end
