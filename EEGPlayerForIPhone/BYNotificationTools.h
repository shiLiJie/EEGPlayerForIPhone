//
//  BYNotificationTools.h
//  NewSuperGymForCoach
//
//  Created by 凤凰八音 on 16/6/22.
//  Copyright © 2016年 HanYouApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYNotificationTools : NSObject
/**
 *  发送通知
 *
 *  @param dict       字典, 可有可无
 *  @param methodName 通知名字
 */
+(void)postNotification:(NSDictionary *)dict methodName:(NSString *)methodName;
/**
 *  接收通知
 *
 *  @param selector   接收通知后执行的方法
 *  @param methodName 字典, 基本没有
 */
+(void)addNotification:(SEL)selector methodName:(NSString *)methodName;

@end
