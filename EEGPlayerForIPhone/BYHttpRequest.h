//
//  BYHttpRequest.h
//  Http929Demo
//
//  Created by 凤凰八音 on 16/11/8.
//  Copyright © 2016年 铅笔. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BYHttpRequest : NSObject


/**
 *  发送获取用户信息查询请求
 *
 *  @param uid 用户id
 */
-(void)userInfoRequestWithUid:(NSString *)uid;

/**
 *  发送用户登录请求
 *
 *  @param loginName 登录名
 *  @param passWord  登录密码
 */

-(void)userLoginRequestWithLoginName:(NSString *)loginName
                            passWord:(NSString *)passWord;

/**
 *  用户手机获取验证码(type=register是注册 type=""是直接收验证码不验证注册)
 *
 *  @param phontNumber 手机号码
 */
-(void)getPhoneVerifyWithPhoneNumber:(NSString *)phontNumber
                                type:(NSString *)type;

/**
 *  用户邮箱注册获取验证码
 *
 *  @param mailNumber 邮箱地址
 */
-(void)getMailVerifyWithMailNumber:(NSString *)mailNumber;

/**
 *  发送用户注册网络请求
 *
 *  @param loginName    用户名
 *  @param passWord     密码
 *  @param rePassWord   重复密码
 *  @param RegisterForm 注册来源
 *  @param registerType 注册类型
 *  @param verifyCode   验证码
 */
-(void)userRegisterRequestWithLoginName:(NSString *)loginName
                               PassWord:(NSString *)passWord
                             RePassWord:(NSString *)rePassWord
                           RegisterForm:(NSString *)RegisterForm
                           RegisterType:(NSString *)registerType
                             VerifyCode:(NSString *)verifyCode;

/**
 *  发送更新用户信息的网络请求
 *
 *  @param uid      用户id
 *  @param nickname 昵称
 *  @param birthday 生日
 *  @param sex      性别
 */
-(void)userInfoUpdateRequestWithUid:(NSString *)uid
                           NickName:(NSString *)nickname
                           Birthday:(NSString *)birthday
                                Sex:(NSString *)sex
                            headPic:(NSData *)headPicData;

/**
 *  修改(绑定)用户手机号
 *
 *  @param uid   用户id
 *  @param phone 手机号
 *  @param code  验证码
 */
-(void)upatePhoneRequsetWithUid:(NSString *)uid
                          Phone:(NSString *)phone
                           Code:(NSString *)code;


/**
 *  修改(绑定)用户手机号
 *
 *  @param uid   用户id
 *  @param phone 邮箱地址
 *  @param code  验证码
 */
-(void)upateMailRequsetWithUid:(NSString *)uid
                         email:(NSString *)email
                          Code:(NSString *)code;


/**
 *  发送修改用户登录密码请求
 *
 *  @param uid      uid
 *  @param password 新密码
 *  @param phone    电话号码
 *  @param code     验证码
 */
-(void)updatePasswordRequestWithUid:(NSString *)uid
                           Password:(NSString *)password
                              Phone:(NSString *)phone
                               Code:(NSString *)code;

/**
 *  每 20 秒传输一次实时的脑波数据
 *
 *  @param uid     uid
 *  @param eegdata 20秒的脑波数据
 */
-(void)uploadTweSecEegDataWithUid:(NSString *)uid
                        EegData:(NSString *)eegdata;


/**
 *  检测完毕后,传输一次完整的原始数据
 *
 *  @param uid      uid
 *  @param eegData  脑波txt的数据流
 *  @param fileName 上传到云端后的文件命名
 */
-(void)uploadEegFileWithUid:(NSString *)uid
                    EEGData:(NSData *)eegData
                   fileName:(NSString *)fileName;


/**
 *  移动设备信息接口
 *
 *  @param uuid          设备UUID
 *  @param platform      设备系统(ios)
 *  @param sysversion    系统版本号
 *  @param equipmentname 设备名称
 *  @param ipAddress     ip 地址
 *  @param ipCity        ip 所在城市
 */
-(void)uploadMobileInformationWithUUID:(NSString *)uuid
                              Platform:(NSString *)platform
                            Sysversion:(NSString *)sysversion
                         Equipmentname:(NSString *)equipmentname
                             IpAddress:(NSString *)ipAddress
                                IpCity:(NSString *)ipCity;


/**
 *  上传外接蓝牙设备信息接口
 *
 *  @param information 蓝牙设备信息的 json 数据
 */
-(void)uploadBlueToothInformationWithInformation:(NSString *)information;


/**
 *  查询用户的完整脑波检测原始数据列表的接口
 *
 *  @param uid uid
 */
-(void)queryEEGDataListWithUid:(NSString *)uid;


/**
 *  下载完整脑波检测原始数据的接口
 *
 *  @param uid uid
 *  @param ID  查询用户的完整脑波检测原始数据列表返回的数据文件 fid
 */
-(void)downLoadEEGDataWithUid:(NSString *)uid
                           ID:(NSString *)ID;

@end
