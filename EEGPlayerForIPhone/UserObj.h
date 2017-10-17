//
//  UserObj.h
//  PCIM
//
//  Created by 凤凰八音 on 16/1/25.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUserTable                  @"UserTable"

#define kUserHeadImg                @"UserHeadImg"
#define kUserName                   @"UserName"
#define kUserSex                    @"UserSex"
#define kUserBirthDate              @"UserBirthDate"
#define kUserHeight                 @"UserHeight"
#define kUserWeight                 @"UserWeight"

@interface UserObj : NSObject<NSCoding>
/** 用户ID */
@property (nonatomic, copy) NSString *ID;
/** 账号 */
@property (nonatomic, copy) NSString *userID;
/** 密码 */
@property (nonatomic, copy) NSString *password;
/** 身份证号 */
@property (nonatomic, copy) NSString *famID;         
/** 手机 */
@property (copy, nonatomic) NSString *mobile;
/** 邮箱 */
@property (copy, nonatomic) NSString *mail;

@property (nonatomic, copy) NSString *devicename;

@property (nonatomic, copy) NSString *jiancecishu;

@property (nonatomic, copy) NSString *jianceshijian;

@property (nonatomic, copy) NSString *banbenhao;

@property (nonatomic, copy) NSString *macAdd;

@property (nonatomic, copy) NSString *count;
/**
 *  呼呼冲分数
 */
@property (nonatomic, copy) NSString *score;



/** 网络端头像地址 */
@property (nonatomic,copy)NSString *headImg;
/** 姓名 */
@property (nonatomic,copy) NSString *name;//姓名
@property (nonatomic,copy) NSString *sex;//性别
@property (nonatomic,copy) NSString  *birthDate;//年龄

@property (nonatomic,copy) NSString *totalScore;//性别
@property (nonatomic,copy) NSString  *totalTime;//年龄



+ (instancetype)sharedUser;


@end
