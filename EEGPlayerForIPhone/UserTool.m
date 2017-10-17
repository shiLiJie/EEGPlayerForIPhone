//
//  UserTool.m
//  PCIM
//
//  Created by 凤凰八音 on 16/2/17.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "UserTool.h"
#import "UserObj.h"
//只能存一组 多组怎么找???
#define TheUserFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"user.data"]


static UserTool *_sharedModel = nil;

@implementation UserTool

+ (void)saveTheUserInfo:(UserObj *)modle {
    
    [NSKeyedArchiver archiveRootObject:modle toFile:TheUserFilePath];
}

//获取对应
+ (UserObj *)readTheUserModle {
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:TheUserFilePath];
}

+ (NSString *)getUserPhoneHideInfo:(BOOL)hide {
    UserObj *user = [UserTool readTheUserModle];
    NSString *phoneText = [user.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    if (hide) {
        return phoneText;
    }else {
        return user.mobile;
    }
}


@end
