//
//  UserTool.h
//  PCIM
//
//  Created by 凤凰八音 on 16/2/17.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserObj;

typedef NS_ENUM(int, HYSexType) {
    SexMale   = 1,
    SexFemale = 2,
};

@interface UserTool : NSObject

/**
 *  存储用户信息
 *
 */
+ (void)saveTheUserInfo:(UserObj *)user;
/**
 *  获取用户信息
 *
 */
+ (UserObj *)readTheUserModle;
/**
 *  获取用户的手机号
 *
 *  @param hide 是否隐藏信息
 *
 */
+ (NSString *)getUserPhoneHideInfo:(BOOL)hide;



@end
