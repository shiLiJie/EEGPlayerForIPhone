//
//  BYSleepEvalVc.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/7.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYSleepEvalVc.h"
#import "BYQuestionView.h"

@interface BYSleepEvalVc ()<BYQuestionViewDelegate>

@end

@implementation BYSleepEvalVc

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpUI];// UI搭建
}

//设置UI部分,viewDidLoad里执行
-(void)setUpUI{
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"睡眠评估";
    //显示navbar
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //两个按钮的父类view
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    //返回主页
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(-15, 5, 40, 40)];
    [leftButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"fanhuiicon"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(backHomeView:) forControlEvents:UIControlEventTouchUpInside];
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftCunstomButtonView;
    
    BYQuestionView *questionView = [[BYQuestionView alloc] initWithFrame:CGRectMake(0, -60, 100, 100)];
    questionView.alterImg.image = [UIImage imageNamed:@""];
    questionView.dismissBtn.hidden = YES;
//    questionView.questionTwoLab.frame = CGRectMake(15, 100, kScreen_Width-90, 50);
    [self.view addSubview:questionView];
    questionView.delegate = self;
    
}

-(void)backZheUpView{
    [self backHomeView:nil];
}

//左上角返回首页按钮
- (IBAction)backHomeView:(UIButton *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
