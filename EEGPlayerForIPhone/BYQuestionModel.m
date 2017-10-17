//
//  BYQuestionModel.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/12.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYQuestionModel.h"

@implementation BYQuestionModel


-(instancetype)init{
    
    self = [super init];
    self.answerDict = [[NSMutableDictionary alloc]init];
    
    NSArray *oneAnswer = [[NSArray alloc]initWithObjects:@"≤15分钟",@"16—30分钟",@"30—60分钟",@"≥60分钟", nil];
    [self.answerDict setValue:oneAnswer forKey:@"OneAnswer"];
    
    NSArray *twoAnswer = [[NSArray alloc]initWithObjects:@"＞7小时",@"6—7小时",@"5—6小时",@"＜5小时", nil];
    [self.answerDict setValue:twoAnswer forKey:@"TwoAnswer"];
    
    NSArray *thrAnswer = [[NSArray alloc]initWithObjects:@"无",@"<1次/周",@"1-2次/周",@"≥ 3次/周", nil];
    [self.answerDict setValue:thrAnswer forKey:@"ThrAnswer"];
    
    NSArray *fourAnswer = [[NSArray alloc]initWithObjects:@"很好",@"较好",@"较差",@"很差", nil];
    [self.answerDict setValue:fourAnswer forKey:@"FourAnswer"];
    
    NSArray *fiveAnswer = [[NSArray alloc]initWithObjects:@"没有",@"偶尔有",@"有时有",@"经常有", nil];
    [self.answerDict setValue:fiveAnswer forKey:@"FiveAnswer"];
    
    
    self.questionArr  = @[@"1. 近1个月，从上床到入睡通常需要——分钟。",@"2. 近1个月，每夜通常实际睡眠——小时(不等于卧床时间)",@"3. 入睡困难(30分钟内不能入睡)",@"4. 夜间易醒或早醒",@"5. 夜间去厕所",@"6. 呼吸不畅",@"7. 咳嗽或鼾声高",@"8. 感觉冷",@"9. 感觉热",@"10. 做恶梦",@"11. 疼痛不适",@"12. 其它影响睡眠的事情",@"13. 近1个月，总的来说，您认为自己的睡眠质量",@"14. 近1个月，您用药物催眠的情况",@"15. 近1个月，您常感到困倦吗",@"16. 近1个月，您做事情的精力不足吗"];
    
    

//    [self.answerDict setValue:@"1. 近1个月，从上床到入睡通常需要——分钟。" forKey:@"one"];
//    
//    [self.answerDict setValue:@"2. 近1个月，每夜通常实际睡眠——小时(不等于卧床时间)" forKey:@"two"];
//    
//    [self.answerDict setValue:@"3. 入睡困难(30分钟内不能入睡)" forKey:@"three"];
//    
//    [self.answerDict setValue:@"4. 夜间易醒或早醒" forKey:@"four"];
//    
//    [self.answerDict setValue:@"5. 夜间去厕所" forKey:@"five"];
//    
//    [self.answerDict setValue:@"6. 呼吸不畅" forKey:@"one"];
//    
//    [self.answerDict setValue:@"7. 咳嗽或鼾声高" forKey:@"one"];
//    
//    [self.answerDict setValue:@"8. 感觉冷" forKey:@"one"];
//    
//    [self.answerDict setValue:@"9. 感觉热" forKey:@"one"];
//    
//    [self.answerDict setValue:@"10. 做恶梦" forKey:@"one"];
//    
//    [self.answerDict setValue:@"11. 疼痛不适" forKey:@"one"];
//    
//    [self.answerDict setValue:@"12. 其它影响睡眠的事情" forKey:@"one"];
//    
//    [self.answerDict setValue:@"13. 近1个月，总的来说，您认为自己的睡眠质量" forKey:@"one"];
//    
//    [self.answerDict setValue:@"14. 近1个月，您用药物催眠的情况" forKey:@"one"];
//    
//    [self.answerDict setValue:@"15. 近1个月，您常感到困倦吗" forKey:@"one"];
//    
//    [self.answerDict setValue:@"16. 近1个月，您做事情的精力不足吗" forKey:@"one"];
    
    
    
    return self;
}

@end
