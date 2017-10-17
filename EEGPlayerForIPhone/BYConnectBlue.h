//
//  BYConnectBlue.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/6.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYConnectBlue : NSObject

@property(nonatomic, copy) NSString *EEGBanben;
@property(nonatomic, assign) BOOL isConnect;

+ (instancetype)sharedConnect;

@end
