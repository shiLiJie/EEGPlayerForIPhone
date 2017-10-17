//
//  MBProgressHUD+YCL.h
//  HUD
//
//  Created by Chenglin Yu on 3/15/15.
//  Copyright (c) 2015 yclzone. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (YCL)
/**
 *    成功提示，1秒自动消失
 *
 *    @param successString 描述文字
 */
+ (void)showSuccess:(NSString *)successString;

/**
 *    成功提示，?秒自动消失
 *
 *    @param successString 描述文字
 */
+ (void)showSuccess:(NSString *)successString hideAfterDelay:(NSTimeInterval)time;

/**
 *    失败提示，1秒自动消失
 *
 *    @param errorString 描述文字
 */
+ (void)showError:(NSString *)errorString;

/**
 *    失败提示，?秒自动消失
 *
 *    @param errorString 描述文字
 */
+ (void)showError:(NSString *)errorString hideAfterDelay:(NSTimeInterval)time;

/**
 *  提示，?秒自动消失
 *
 *  @param text 提示文字
 */
+ (void)showText:(NSString *)text;

/**
 *  提示，?秒自动消失
 *
 *  @param text 提示文字
 */
+ (void)showText:(NSString *)text hideAfterDelay:(NSTimeInterval)time;

/**
 *    执行提示
 *
 *    @param message 消息内容
 */
+ (instancetype)showWhileExecuting:(NSString *)message;
@end
