//
//  BYQuestionView.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/9.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYQuestionView.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "UIColor+Extend.h"
#import "BYQuestionModel.h"
#import "MLMCircleView.h"
#import "BYConnectBlue.h"

@interface BYQuestionView()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题Lab
@property (nonatomic, assign) BOOL isLastOneQuestion;//是否是最后一道题

@property (nonatomic, strong) UIButton *alterAbtn;//遮罩按钮
@property (nonatomic, strong) UIButton *alterBbtn;
@property (nonatomic, strong) UIButton *alterCbtn;
@property (nonatomic, strong) UIButton *alterDbtn;

@end

@implementation BYQuestionView

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"BYQuestionView" owner:nil options:nil];
    self =[nibView objectAtIndex:0];
    
    self.isLastOneQuestion = NO;
    
    //初始化,默认低0题,从0 开始
    self.questionNum = 0;
    
    //初始化,得分为0
    self.score = 0;
    
    //添加问题相关元素
    [self addObjects];
    
    return self;
}


-(void)layoutSubviews{
    self.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
}

//添加问题选项按钮Lab
-(void)addObjects{
    self.questionBgVIew.layer.cornerRadius = 10;//设置那个圆角的有多圆
    self.questionBgVIew.layer.borderWidth = 0;//设置边框的宽度，当然可以不要
    
    //题目大纲的Lab
    self.questionOneLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, kScreen_Width-90, 50)];
    self.questionOneLab.text = @"下面一些问题是关于您最近1个月的睡眠情况，请选择回填写最符合您近1个月实际情况的答案。 请回答下列问题！";
    self.questionOneLab.backgroundColor = [UIColor clearColor];
    self.questionOneLab.textColor = [UIColor hexColorWithString:@"333333"];
    self.questionOneLab.font = [UIFont systemFontOfSize:15];
    self.questionOneLab.numberOfLines = 0;
    CGFloat height = [UILabel getHeightByWidth:self.questionOneLab.frame.size.width title:self.questionOneLab.text font:self.questionOneLab.font] ;
    
    //修改这里才是Lab的实际值
    self.questionOneLab.frame = CGRectMake(15, 45, kScreen_Width-90, height);
    [self.questionBgVIew addSubview:self.questionOneLab];
    
    
    
    //小题题目的Lab
    self.questionTwoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 100+height, kScreen_Width-90, 100)];
    self.questionTwoLab.text = @"1. 近1个月，从上床到入睡通常需要——分钟。";
    self.questionTwoLab.backgroundColor = [UIColor clearColor];
    self.questionTwoLab.textColor = [UIColor hexColorWithString:@"333333"];
    self.questionTwoLab.font = [UIFont systemFontOfSize:15];
    self.questionTwoLab.numberOfLines = 0;
    CGFloat height2 = [UILabel getHeightByWidth:kScreen_Width-90 title:self.questionTwoLab.text font:[UIFont systemFontOfSize:15]];
    
    //修改这里才是Lab的实际值
    self.questionTwoLab.frame = CGRectMake(15, 15+height+45, kScreen_Width-90, height2);
    [self.questionBgVIew addSubview:self.questionTwoLab];
    
    //答案按钮a
    self.buttonA = [[UIButton alloc] initWithFrame:CGRectMake(25, 50+height+height2+30, 20, 20)];
    [self.buttonA setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    [self.questionBgVIew addSubview:self.buttonA];
    //答案选项a
    self.answerALab = [[UILabel alloc] initWithFrame:CGRectMake(25+20, 50+height+height2+30, 90, 20)];
    self.answerALab.text = @"≤15分钟";
    self.answerALab.font = [UIFont systemFontOfSize:15];
    self.answerALab.textColor = [UIColor hexColorWithString:@"8c8c8c"];
    [self.questionBgVIew addSubview:self.answerALab];
    //A遮罩按钮
    self.alterAbtn = [[UIButton alloc] initWithFrame:CGRectMake(25+20, 50+height+height2+30, 90, 20)];
    [self.questionBgVIew addSubview:self.alterAbtn];
    
    //b
    self.buttonB = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_CenterX-20, 50+height+height2+30, 20, 20)];
    [self.buttonB setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    [self.questionBgVIew addSubview:self.buttonB];
    //答案选项b
    self.answerBLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_CenterX-20+20, 50+height+height2+30, 90, 20)];
    self.answerBLab.text = @"16—30分钟";
    self.answerBLab.font = [UIFont systemFontOfSize:15];
    self.answerBLab.textColor = [UIColor hexColorWithString:@"8c8c8c"];
    [self.questionBgVIew addSubview:self.answerBLab];
    //b遮罩按钮
    self.alterBbtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_CenterX-20+20, 50+height+height2+30, 90, 20)];
    [self.questionBgVIew addSubview:self.alterBbtn];
    
    //c
    self.buttonC = [[UIButton alloc] initWithFrame:CGRectMake(25, 50+height+height2+30+30, 20, 20)];
    [self.buttonC setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    [self.questionBgVIew addSubview:self.buttonC];
    //答案选项c
    self.answerCLab = [[UILabel alloc] initWithFrame:CGRectMake(25+20, 50+height+height2+30+30, 90, 20)];
    self.answerCLab.text = @"130—60分钟";
    self.answerCLab.font = [UIFont systemFontOfSize:15];
    self.answerCLab.textColor = [UIColor hexColorWithString:@"8c8c8c"];
    [self.questionBgVIew addSubview:self.answerCLab];
    //c遮罩按钮
    self.alterCbtn = [[UIButton alloc] initWithFrame:CGRectMake(25+20, 50+height+height2+30+30, 90, 20)];
    [self.questionBgVIew addSubview:self.alterCbtn];
    
    //d
    self.buttonD = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_CenterX-20, 50+height+height2+30+30, 20, 20)];
    [self.buttonD setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    [self.questionBgVIew addSubview:self.buttonD];
    //答案选项d
    self.answerDLab = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_CenterX-20+20, 50+height+height2+30+30, 90, 20)];
    self.answerDLab.text = @"≥60分钟";
    self.answerDLab.font = [UIFont systemFontOfSize:15];
    self.answerDLab.textColor = [UIColor hexColorWithString:@"8c8c8c"];
    [self.questionBgVIew addSubview:self.answerDLab];
    //d遮罩按钮
    self.alterDbtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_CenterX-20+20, 50+height+height2+30+30, 90, 20)];
    [self.questionBgVIew addSubview:self.alterDbtn];
    
    
    [self.buttonA addTarget:self action:@selector(chooseA) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonB addTarget:self action:@selector(chooseB) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonC addTarget:self action:@selector(chooseC) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonD addTarget:self action:@selector(chooseD) forControlEvents:UIControlEventTouchUpInside];
    [self.alterAbtn addTarget:self action:@selector(chooseA) forControlEvents:UIControlEventTouchUpInside];
    [self.alterBbtn addTarget:self action:@selector(chooseB) forControlEvents:UIControlEventTouchUpInside];
    [self.alterCbtn addTarget:self action:@selector(chooseC) forControlEvents:UIControlEventTouchUpInside];
    [self.alterDbtn addTarget:self action:@selector(chooseD) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击选项按钮的相关方法
//选择A
-(void)chooseA{
    [self selectAnswerButton:self.buttonA btnB:self.buttonB btnC:self.buttonC btnD:self.buttonD];
}

//选择B
-(void)chooseB{
    [self selectAnswerButton:self.buttonB btnB:self.buttonA btnC:self.buttonC btnD:self.buttonD];
}

//选择C
-(void)chooseC{
    [self selectAnswerButton:self.buttonC btnB:self.buttonB btnC:self.buttonA btnD:self.buttonD];
}

//选择D
-(void)chooseD{
    [self selectAnswerButton:self.buttonD btnB:self.buttonB btnC:self.buttonC btnD:self.buttonA];
}


/**
 *  选项按钮点击方法
 *
 *  @param btnA 点击的选项按钮
 *  @param btnB 其余三个选项按钮
 *  @param btnC 其余三个选项按钮
 *  @param btnD 其余三个选项按钮
 */
-(void)selectAnswerButton:(UIButton *)btnA btnB:(UIButton *)btnB btnC:(UIButton *)btnC btnD:(UIButton *)btnD{
    if (btnA.selected == NO) {//如果没选中
        btnA.selected = YES;//选中
        [btnA setImage:[UIImage imageNamed:@"duihao"] forState:UIControlStateSelected];//换图
    }else{
        btnA.selected = NO;//如果选中了,则变成没选中
        [btnA setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];//换图
    }
    //如果其他三个按钮有已经选中了的
    if (btnB.selected == YES || btnC.selected == YES || btnD.selected == YES) {
        btnB.selected = NO;//其他三个全变成没选中状态
        btnC.selected = NO;
        btnD.selected = NO;
    }
//    [self performSelector:@selector(nextOneQuestion:) withObject:nil/*可传任意类型参数*/ afterDelay:.5];
}


#pragma mark - 选择好答案点击确定下一题的相关方法
//确定下一题按钮方法
- (IBAction)nextOneQuestion:(UIButton *)sender {
    
    //四个按钮都没有选择,点击无效
    if (self.buttonA.selected == NO &&
        self.buttonB.selected == NO &&
        self.buttonC.selected == NO &&
        self.buttonD.selected == NO) {
        return;
    }
    
    //如果是最后一道题了,其实是进入到了报告界面
    if (self.isLastOneQuestion == YES) {
        BYConnectBlue *con = [BYConnectBlue sharedConnect];
        //如果连接了涉笔
        if (con.isConnect == YES){
            //点击完成的时候移除view
            [self cancelQuestionView:nil];
        }else{
            //没连接设备
            [self.delegate backZheUpView];
        }
        
    }
    
    //创建数据模型
    BYQuestionModel *model = [[BYQuestionModel alloc] init];
    //题目数 +1
    self.questionNum ++;
    //如果是最后一题了,确定按钮变成完成按钮
    if (self.questionNum == model.questionArr.count-1) {
        [sender setImage:[UIImage imageNamed:@"wancheng"] forState:UIControlStateNormal];
        
    }
    //如果题目小于等于问题长度,计分器++
    if (self.questionNum <= model.questionArr.count){
        int current = [self planScore:self.questionNum];
        self.score += current;
        
        NSLog(@"%d",self.score);
    }
    //如果题目数大于 题目数组长度-1
    if (self.questionNum > model.questionArr.count - 1) {
        
        //答题结束
        [self answerZheLastQuestion];
        //最后一道题 yes
        self.isLastOneQuestion = YES;
        
        NSLog(@"code");
        //退出,防止越界
        return;
    }
    //给副问题Lab赋值
    self.questionTwoLab.text = model.questionArr[self.questionNum];
    if (self.questionNum == 1) {
        [self answerLabAddText:model key:@"TwoAnswer"];
    }else if (self.questionNum == 12) {
        [self answerLabAddText:model key:@"FourAnswer"];
    }else if (self.questionNum == 15) {
        [self answerLabAddText:model key:@"FiveAnswer"];
    }else{
        [self answerLabAddText:model key:@"ThrAnswer"];
    }
    
    //初始化选项按钮
    [self initButtonImage];
}

/**
 *  答完最后一道题,变换背景控件,答题部分删除,计分进度条部分展现
 */
-(void)answerZheLastQuestion{
    //更换title标题
    self.titleLab.text = @"睡眠问答报告";
    //移除答题相关控件
    [self.questionOneLab removeFromSuperview];
    [self.questionTwoLab removeFromSuperview];
    [self.buttonB removeFromSuperview];
    [self.buttonA removeFromSuperview];
    [self.buttonC removeFromSuperview];
    [self.buttonD removeFromSuperview];
    [self.answerALab removeFromSuperview];
    [self.answerBLab removeFromSuperview];
    [self.answerCLab removeFromSuperview];
    [self.answerDLab removeFromSuperview];
    
    //创建一个半圆进度条表示得分情况
    MLMCircleView *circle = [[MLMCircleView alloc] initWithFrame:CGRectMake(self.questionBgVIew.frame.size.width/2-self.questionBgVIew.frame.size.width/2/2, self.questionBgVIew.frame.size.height/6, self.questionBgVIew.frame.size.width/2,self.questionBgVIew.frame.size.width/2) startAngle:150 endAngle:390];
    
    circle.bottomWidth = 6;
    circle.progressWidth = 6;
    circle.fillColor = RGB(247, 227, 158);
    circle.bgColor = RGB(212, 217, 222);
    circle.dotDiameter = 20;
    circle.edgespace = 5;
    [circle drawProgress];
    //设置进度
    NSString *pro = [NSString stringWithFormat:@"%0.1f",self.score/100.0];
    [circle setProgress:[pro floatValue]];
    [self.questionBgVIew addSubview:circle];
    
    //灰色小线条
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(circle.frame.size.width/2-17, circle.frame.size.height-45, 34, 3)];
    grayView.backgroundColor = RGB(169, 173, 174);
    grayView.layer.cornerRadius = 1;//设置那个圆角的有多圆
    grayView.layer.borderWidth = 0;//设置边框的宽度，当然可以不要
    [circle addSubview:grayView];
    
    //分数前半部分//大字
    UILabel *bigScore = [[UILabel alloc] initWithFrame:CGRectMake(circle.frame.size.width/2-55, circle.frame.size.height/2-25, 55, 40)];
    bigScore.text = [NSString stringWithFormat:@"%d",self.score];
    bigScore.font = [UIFont systemFontOfSize:30];
    bigScore.textAlignment = NSTextAlignmentRight;
    [circle addSubview:bigScore];
    
    //分数后半部分//小字
    UILabel *smallScore = [[UILabel alloc] initWithFrame:CGRectMake(circle.frame.size.width/2, circle.frame.size.height/2-12, 50, 20)];
    smallScore.text = @".00分";
    smallScore.font = [UIFont systemFontOfSize:18];
    [circle addSubview:smallScore];
    
    //文字描述状态Lab
    UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(0, circle.frame.size.height-25, circle.frame.size.width, 20)];
    if (self.score < 60) {
        textLab.text = @"睡眠质量很差";
    }else{
        textLab.text = @"睡眠质量较好";
    }
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = [UIFont systemFontOfSize:13];
    textLab.textColor = [UIColor hexColorWithString:@"333333"];
    [circle addSubview:textLab];
    
    //注: Lab
    UILabel *zhuLab = [[UILabel alloc] initWithFrame:CGRectMake(30, self.questionBgVIew.frame.size.width/2+self.questionBgVIew.frame.size.height/6, 30, 20)];
    zhuLab.text = @"注:";
    zhuLab.textColor = [UIColor redColor];
    zhuLab.font = [UIFont systemFontOfSize:13];
    [self.questionBgVIew addSubview:zhuLab];
    //tipLab
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, self.questionBgVIew.frame.size.width-50-20, 50)];
    tipLab.text = @"问答测试不能代表最终结论,建议您进行设备的评估测试,来更详细的了解您当前睡眠的状况。";
    tipLab.backgroundColor = [UIColor clearColor];
    tipLab.textColor = [UIColor hexColorWithString:@"636363"];
    tipLab.font = [UIFont systemFontOfSize:13];
    tipLab.numberOfLines = 0;
    CGFloat height2 = [UILabel getHeightByWidth:tipLab.frame.size.width title:tipLab.text font:tipLab.font];
    //修改这里才是Lab的实际值
    tipLab.frame = CGRectMake(50, self.questionBgVIew.frame.size.width/2+self.questionBgVIew.frame.size.height/6+2, self.questionBgVIew.frame.size.width-50-20, height2);
    [self.questionBgVIew addSubview:tipLab];
}

/**
 *  计算得分
 *
 *  @param questionNum 当前的题目
 *
 *  @return 当前题目的分数
 */
-(int)planScore:(int)questionNum{
    
    int score = 0;
    //1234题7分
    if (questionNum == 1 || questionNum == 2 || questionNum == 3 || questionNum == 4) {
        if (self.buttonA.selected == YES) {
            score = 7;
        }else if (self.buttonB.selected == YES){
            score = 6;
        }else if (self.buttonC.selected == YES){
            score = 5;
        }else{
            score = 4;
        }
        //其他的6分
    }else{
        if (self.buttonA.selected == YES) {
            score = 6;
        }else if (self.buttonB.selected == YES){
            score = 5;
        }else if (self.buttonC.selected == YES){
            score = 4;
        }else{
            score = 3;
        }
    }
    return score;
}

//确定下一题后按钮初始化
-(void)initButtonImage{
    self.buttonA.selected = NO;
    self.buttonB.selected = NO;
    self.buttonC.selected = NO;
    self.buttonD.selected = NO;
    [self.buttonA setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    [self.buttonB setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    [self.buttonC setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
    [self.buttonD setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
}

/**
 *  给四个选项Lab赋值
 *
 *  @param model 数据模型
 *  @param key   模型字典对应的键值
 */
-(void)answerLabAddText:(BYQuestionModel *)model key:(NSString *)key{
    NSArray *arr = [model.answerDict objectForKey:key];
    self.answerALab.text = arr[0];
    self.answerBLab.text = arr[1];
    self.answerCLab.text = arr[2];
    self.answerDLab.text = arr[3];
}

#pragma mark - 左上角取消方法
- (IBAction)cancelQuestionView:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
