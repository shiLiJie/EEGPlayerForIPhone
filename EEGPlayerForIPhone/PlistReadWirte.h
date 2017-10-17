//
//  PlistReadWirte.h
//  PCIM
//
//  Created by 凤凰八音 on 16/2/2.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistReadWirte : NSObject

+(void)Modify:(NSDictionary *)getvalue;

+(void)ModifyArray:(NSDictionary *)geeee;

+ (NSDictionary *)readingPlist:(NSString *)key;

+ (NSDictionary *)readingSamllPlist:(NSString *)key;

@end
