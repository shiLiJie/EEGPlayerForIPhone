//
//  BYQuestionView.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/9.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BYQuestionViewDelegate

-(void)backZheUpView;

@end

@interface BYQuestionView : UIView

@property (weak, nonatomic) IBOutlet UIView *questionBgVIew;//题目有效区的存放view
@property (weak, nonatomic) IBOutlet UIImageView *alterImg;//灰色遮罩
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;//左上角×按钮

@property (nonatomic, strong) UILabel *questionOneLab;//提纲Lab
@property (nonatomic, strong) UILabel *questionTwoLab;//小题Lab

@property (nonatomic, strong) UIButton *buttonA;//a选项按钮
@property (nonatomic, strong) UIButton *buttonB;//b选项按钮
@property (nonatomic, strong) UIButton *buttonC;//c选项按钮
@property (nonatomic, strong) UIButton *buttonD;//d选项按钮

@property (nonatomic, strong) UILabel *answerALab;//a答案Lab
@property (nonatomic, strong) UILabel *answerBLab;//b答案Lab
@property (nonatomic, strong) UILabel *answerCLab;//c答案Lab
@property (nonatomic, strong) UILabel *answerDLab;//d答案Lab

@property (nonatomic, assign) int questionNum;//当前的题目数,从0开始

@property (nonatomic, assign) int score;//答题的得分

@property (nonatomic, weak) id<BYQuestionViewDelegate>delegate;

@end
