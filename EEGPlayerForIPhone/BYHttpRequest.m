//
//  BYHttpRequest.m
//  Http929Demo
//
//  Created by 凤凰八音 on 16/11/8.
//  Copyright © 2016年 铅笔. All rights reserved.
//

NSString *const failureCoder = @"0";
NSString *const succeedCoder = @"1";

#import "BYHttpRequest.h"
#import "HttpRequest.h"
#import "NSString+md5Token.h"

//返回码的枚举,避免魔法数字
typedef enum
{
    //以下是枚举成员
    failRequset = 0,
    successRequest = 1,
 
}returnCode;//枚举名称

@implementation BYHttpRequest

/**
 *  发送获取用户信息查询请求
 *
 *  @param uid 用户id
 */
-(void)userInfoRequestWithUid:(NSString *)uid{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                            @"token":token,
                            @"uid":uid,
                            };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_userinfo" parameters:dict success:^(id obj) {
        if ([succeedCoder isEqualToString:[NSString stringWithFormat:@"%@",[obj valueForKey:@"code"]]]) {
            UserObj *user = [UserTool readTheUserModle];
            user.userID = [[[obj valueForKey:@"ressult"] valueForKey:@"userinfo"] valueForKey:@"username"];
            user.name = [[[obj valueForKey:@"ressult"] valueForKey:@"userinfo"] valueForKey:@"nickname"];
            user.headImg = [[[obj valueForKey:@"ressult"] valueForKey:@"userinfo"] valueForKey:@"head_pic"];
            user.mobile = [[[obj valueForKey:@"ressult"] valueForKey:@"userinfo"] valueForKey:@"phone"];
            user.mail = [[[obj valueForKey:@"ressult"] valueForKey:@"userinfo"] valueForKey:@"email"];
            user.birthDate = [[[obj valueForKey:@"ressult"] valueForKey:@"userinfo"] valueForKey:@"birthday"];
            //这些不单独传到后台,登陆的时候默认都是空的
            user.devicename = @"";
            user.banbenhao = @"";
            user.macAdd = @"";
            
            [UserTool saveTheUserInfo:user];
            
        }else{
            //获取信息失败
        }

        } fail:^(NSError *error) {
            
            NSLog(@"error--%@",error);
            
    }];
}

/**
 *  发送用户登录请求
 *
 *  @param loginName 登录名
 *  @param passWord  登录密码
 */
-(void)userLoginRequestWithLoginName:(NSString *)loginName
                            passWord:(NSString *)passWord{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"login_name":loginName,
                           @"password":passWord
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_login" parameters:dict success:^(id obj) {
        
        NSLog(@"success%@",obj);
        int code;
        if ([[obj valueForKey:@"code"] isKindOfClass:[NSNumber class]]) {
            code = [[obj valueForKey:@"code"] intValue];
        }
        if (code == successRequest) {
            NSLog(@"登陆成功");
        }
        if (code == failRequset) {
            NSLog(@"登陆失败");
            NSLog(@"账号或密码错误");
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"error--%@",error);
        NSLog(@"请检查网络");
        
    }];
}

/**
 *  用户手机获取验证码(type=register是注册 type=""是直接收验证码不验证注册)
 *
 *  @param phontNumber 手机号码
 */
-(void)getPhoneVerifyWithPhoneNumber:(NSString *)phontNumber
                                type:(NSString *)type{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"phone":phontNumber,
                           @"type":type
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_phone_verify" parameters:dict success:^(id obj) {
        
        NSLog(@"success%@",obj);
        NSLog(@"%@",[[obj valueForKey:@"result"] valueForKey:@"msg"]);
        
    } fail:^(NSError *error) {
        
        NSLog(@"error--%@",error);
    }];
}

/**
 *  用户邮箱注册获取验证码
 *
 *  @param mailNumber 邮箱地址
 */
-(void)getMailVerifyWithMailNumber:(NSString *)mailNumber{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"email":mailNumber
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_email_verify" parameters:dict success:^(id obj) {
        
        NSLog(@"success%@",obj);
        NSLog(@"%@",[[obj valueForKey:@"result"] valueForKey:@"msg"]);
        
    } fail:^(NSError *error) {
        
        NSLog(@"error--%@",error);
    }];
}

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
                             VerifyCode:(NSString *)verifyCode{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"register_name":loginName,
                           @"password":passWord,
                           @"re_password":rePassWord,
                           @"verify_code":verifyCode,
                           @"register_type":registerType,
                           @"register_form":@"app"
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_register" parameters:dict success:^(id obj) {
        
        NSLog(@"success%@",obj);
        NSLog(@"%@",[[obj valueForKey:@"result"] valueForKey:@"msg"]);
        
    } fail:^(NSError *error) {
        
        NSLog(@"error--%@",error);
    }];
}

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
                            headPic:(NSData *)headPicData{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"uid":uid,
                           @"nickname":nickname,
                           @"birthday":birthday,
                           @"sex":sex,
                           @"head_pic":headPicData
                           };
    [[HttpRequest shardWebUtil] uploadImageWithUrl:@"http://cloud.musiccare.cn/Api/NbApi/nb_userinfo_update" WithParams:dict image:headPicData filename:@"head_pic" mimeType:@"image/png" completion:^(id dic) {
        NSLog(@"%@",dic);
        NSLog(@"%@",[[dic valueForKey:@"result"] valueForKey:@"msg"]);
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

/**
 *  修改(绑定)用户手机号
 *
 *  @param uid   用户id
 *  @param phone 手机号
 *  @param code  验证码
 */
-(void)upatePhoneRequsetWithUid:(NSString *)uid
                          Phone:(NSString *)phone
                           Code:(NSString *)code{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"uid":uid,
                           @"phone":phone,
                           @"code":code
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_update_phone" parameters:dict success:^(id obj) {
        
        NSLog(@"success%@",obj);
        NSLog(@"%@",[[obj valueForKey:@"result"] valueForKey:@"msg"]);
        
    } fail:^(NSError *error) {
        
        NSLog(@"error--%@",error);
    }];
}

/**
 *  修改(绑定)用户手机号
 *
 *  @param uid   用户id
 *  @param phone 邮箱地址
 *  @param code  验证码
 */
-(void)upateMailRequsetWithUid:(NSString *)uid
                         email:(NSString *)email
                          Code:(NSString *)code{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"uid":uid,
                           @"email":email,
                           @"code":code
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_update_email" parameters:dict success:^(id obj) {
        
        NSLog(@"success%@",obj);
        NSLog(@"%@",[[obj valueForKey:@"result"] valueForKey:@"msg"]);
        
    } fail:^(NSError *error) {
        
        NSLog(@"error--%@",error);
    }];
}

/**
 *  发送修改用户登录密码
 *
 *  @param uid      uid
 *  @param password 新密码
 *  @param phone    电话号码
 *  @param code     验证码
 */
-(void)updatePasswordRequestWithUid:(NSString *)uid
                           Password:(NSString *)password
                              Phone:(NSString *)phone
                               Code:(NSString *)code{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"uid":uid,
                           @"password":password,
                           @"phone":phone,
                           @"code":code
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_update_password" parameters:dict success:^(id obj) {
        
        NSLog(@"success%@",obj);
        NSLog(@"%@",[[obj valueForKey:@"result"] valueForKey:@"msg"]);
        
    } fail:^(NSError *error) {
        
        NSLog(@"error--%@",error);
    }];
}

/**
 *  每 20 秒传输一次实时的脑波数据
 *
 *  @param uid     uid
 *  @param eegdata 20秒的脑波数据
 */
-(void)uploadTweSecEegDataWithUid:(NSString *)uid
                        EegData:(NSString *)eegdata{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"uid":uid,
                           @"exam_result":eegdata,
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_upload_EEG_data" parameters:dict success:^(id obj) {
        
        NSLog(@"success%@",obj);
        NSLog(@"%@",[[obj valueForKey:@"result"] valueForKey:@"msg"]);
        
    } fail:^(NSError *error) {
        
        NSLog(@"error--%@",error);
    }];
}

/**
 *  检测完毕后,传输一次完整的原始数据
 *
 *  @param uid      uid
 *  @param eegData  脑波txt的数据流
 *  @param fileName 上传到云端后的文件命名
 */
-(void)uploadEegFileWithUid:(NSString *)uid
                    EEGData:(NSData *)eegData
                   fileName:(NSString *)fileName{
    
    NSString *token = [NSString md5WithString];

    NSDictionary *dict = @{
                           @"token":token,
                           @"uid":uid,
                           @"file_name":eegData
                           };
    
    [[HttpRequest shardWebUtil] uploadTextWithUrl:@"http://cloud.musiccare.cn/Api/NbApi/nb_upload_file_data" WithParams:dict image:eegData filename:@"file_name" mimeType:@"text/plain" fileName:fileName completion:^(id dic) {
        
        NSLog(@"%@",dic);
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

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
                                IpCity:(NSString *)ipCity{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"equipment_id":uuid,
                           @"platform":platform,
                           @"sys_version":sysversion,
                           @"equipment_name":equipmentname,
                           @"ip_address":ipAddress,
                           @"ip_city":ipCity
                           };
    
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_get_mobile_information" parameters:dict success:^(id obj) {
        NSLog(@"success%@",obj);
        
        
    } fail:^(NSError *error) {
        NSLog(@"error--%@",error);
    }];
}

/**
 *  上传外接蓝牙设备信息接口
 *
 *  @param information 蓝牙设备信息的 json 数据
 */
-(void)uploadBlueToothInformationWithInformation:(NSString *)information{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"bluetooth_information":information,
                           };
    
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_get_bluetooth_information" parameters:dict success:^(id obj) {
        NSLog(@"success%@",obj);
        
        
    } fail:^(NSError *error) {
        NSLog(@"error--%@",error);
    }];
}

/**
 *  查询用户的完整脑波检测原始数据列表的接口
 *
 *  @param uid uid
 */
-(void)queryEEGDataListWithUid:(NSString *)uid{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"uid":uid,
                           };
    
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_user_EEG_data_list" parameters:dict success:^(id obj) {
        NSLog(@"success%@",obj);
        
        
    } fail:^(NSError *error) {
        NSLog(@"error--%@",error);
    }];
}

/**
 *  下载完整脑波检测原始数据的接口
 *
 *  @param uid uid
 *  @param ID  查询用户的完整脑波检测原始数据列表返回的数据文件 fid
 */
-(void)downLoadEEGDataWithUid:(NSString *)uid
                           ID:(NSString *)ID{
    
    NSString *token = [NSString md5WithString];
    
    NSDictionary *dict = @{
                           @"token":token,
                           @"uid":uid,
                           @"id":ID
                           };
    
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_download_EEG_data" parameters:dict success:^(id obj) {
        NSLog(@"success%@",obj);
        
        
    } fail:^(NSError *error) {
        NSLog(@"error--%@",error);
    }];
}

@end
