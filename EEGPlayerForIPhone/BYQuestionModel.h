//
//  BYQuestionModel.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/12.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYQuestionModel : NSObject

/**
 *  问题数组
 */
@property (nonatomic, strong) NSArray *questionArr;
/**
 *  答案字典
 */
@property (nonatomic, strong) NSMutableDictionary *answerDict;

@end
