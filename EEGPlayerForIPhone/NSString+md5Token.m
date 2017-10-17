//
//  NSString+md5Token.m
//  Http929Demo
//
//  Created by 凤凰八音 on 16/11/4.
//  Copyright © 2016年 铅笔. All rights reserved.
//

#import "NSString+md5Token.h"
#import<CommonCrypto/CommonDigest.h>

@implementation NSString (md5Token)

#define publicKey @"fhby_cloud_20161031001"

// MD5加密方法
+ (NSString *)md5WithString
{
    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH"];
    NSString *tokenTime = [df stringFromDate:now];
    NSString *token = [NSString stringWithFormat:@"%@%@",tokenTime,publicKey];
    
    const char* str = [token UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    return ret;
}

+(NSString *)getResponseMsgWithObject:(id)obj{
    
    NSString *mess = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"result"] valueForKey:@"msg"]];
    NSString *mes = [mess stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *arr = [mes componentsSeparatedByString:@"("];
    NSString *str = [NSString stringWithFormat:@"%@",arr[0]];
    return str;
}

+(NSString *)getResponseUIDWithObject:(id)obj{
    
    NSString *mes = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"result"] valueForKey:@"uid"]];
    return mes;
}

@end
