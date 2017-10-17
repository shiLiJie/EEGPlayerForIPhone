//
//  BYEvaReportVc.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/6.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYEvaReportVc.h"
#import "MLMCircleView.h"

@interface BYEvaReportVc ()
@property (weak, nonatomic) IBOutlet UIView *bgView;//底部大视图,存放半圆和其他image
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;//得分Lab
@property (weak, nonatomic) IBOutlet UILabel *gradeLab;//评级Lab
@property (weak, nonatomic) IBOutlet UILabel *stateLab;//状态Lab

@property (weak, nonatomic) IBOutlet UILabel *pingjiaLab;//评价Lab
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConstraint;//去训练按钮距离上边猫头鹰距离约束
@end

@implementation BYEvaReportVc
//返回评估界面按钮
- (IBAction)backToEvalVc:(UIButton *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
//去检测按钮
- (IBAction)goToTrain:(UIButton *)sender {
    [[self navigationController] popViewControllerAnimated:NO];
    //给主控制器发送通知,告诉住控制器切换segement到训练界面
    NSNotification *notification = [NSNotification notificationWithName:@"GOTOTRAIN" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self creatCircle];// 创建进度条view
    
    //设置得分Lab
    self.scoreLab.text = [NSString stringWithFormat:@"%.0f",self.progress * 100];
    if (self.progress > 0.6) {
        self.gradeLab.text = @"A";//设置评级Lab
        self.stateLab.text = @"好";//设置状态Lab
        self.pingjiaLab.text = @"经过评估检测,您的大脑处于健康状态,建议您去训练。";
    }else{
        self.gradeLab.text = @"B";
        self.stateLab.text = @"差";
        self.pingjiaLab.text = @"经过评估检测,您的大脑处于危险状态,建议您去训练。";
    }
    
    self.btnConstraint.constant = kScreen_Height * 0.1154;
}

//创建进度条
-(void)creatCircle{
    //可以带头部图片的进度条
    MLMCircleView *circle = [[MLMCircleView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width * 0.824,kScreen_Width * 0.824) startAngle:180 endAngle:360];
    //位置
    circle.center = CGPointMake(kScreen_Width * 0.824 / 2, kScreen_Width * 0.824 / 2);
    //容器宽
    circle.bottomWidth = 4;
    //进度条宽
    circle.progressWidth = 4;
    //填充色
    circle.fillColor = RGB(243, 182, 123);
    //背景色
    circle.bgColor = [UIColor colorWithWhite:1 alpha:.6];
    //光标头直径
    circle.dotDiameter = 8;
    //光标间隔
    circle.edgespace = 5;
    //光标头
    circle.dotImage = [UIImage imageNamed:@"xiaodian"];
    //添加动画
    [circle drawProgress];
    //设置进度
    [circle setProgress:self.progress];
    NSLog(@"%f",self.progress);
    circle.backgroundColor = [UIColor clearColor];
    
    [self.bgView addSubview:circle];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
