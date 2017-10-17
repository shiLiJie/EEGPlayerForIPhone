//
//  NSString+Base64.h
//  Http929Demo
//
//  Created by 凤凰八音 on 16/11/10.
//  Copyright © 2016年 铅笔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

/**
 *  转换为Base64编码
 */
- (NSString *)base64EncodedString;
/**
 *  将Base64编码还原(不转中文)
 */
- (NSString *)base64DecodedString;
/**
 *  文件md5
 *
 *  @param path 文件路径
 *
 *  @return <#return value description#>
 */
+(NSString*)fileMD5:(NSString*)path;
/**
 *  文件sha1
 *
 *  @param path 文件路径
 *
 *  @return <#return value description#>
 */
+(NSString*)fileSHA1:(NSString*)path;
/**
 *  普通sha1
 *
 *  @param input 字符串
 *
 *  @return <#return value description#>
 */
+ (NSString *) sha1:(NSString *)input;
/**
 *  普通md5
 *
 *  @param input 字符串
 *
 *  @return <#return value description#>
 */
+ (NSString *)md5WithString:(NSString *)input;

@end
