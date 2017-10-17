//
//  BYEvaluateViewController.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/5.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYEvaluateViewController.h"
#import "BYEValViewController.h"
#import "BYTrainViewController.h"
#import "BYConnectBlue.h"

@interface BYEvaluateViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *evaluateOrTrain;//顶部左右选择控制器
@property (nonatomic, strong)UIViewController *currentVC;//当前控制器
@property (nonatomic, strong)UIViewController *lastVC;//最后的控制器
@property (nonatomic, strong) BYTrainViewController *trainVc;//训练控制器
@property (nonatomic, strong) BYEValViewController *evalVc;//评估控制器

@property (nonatomic, strong) UIButton *evalBtn;//评估按钮
@property (nonatomic, strong) UIButton *trainBtn;//训练按钮

@property (nonatomic, assign) BOOL isEval;//评估按钮选中
@property (nonatomic, assign) BOOL isTrain;//训练按钮选中

@end

@implementation BYEvaluateViewController

-(void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化两个自控制器
    self.trainVc = [[BYTrainViewController alloc] init];
    self.evalVc = [[BYEValViewController alloc] init];
    //添加到子控制器里
    [self addchildvc];
    //默认当前是评估控制器
    self.currentVC = self.childViewControllers[0];
    //设置控制器视图位置大小
    self.currentVC.view.frame = CGRectMake(0, 30+kScreen_Width*0.208*0.5256, self.view.bounds.size.width, self.view.bounds.size.height-30+kScreen_Width*0.208*0.5256);
    //插入到当前控制器里
    [self.view insertSubview:self.currentVC.view atIndex:0];
    //segement默认选中左侧
    self.evaluateOrTrain.selectedSegmentIndex = 0;
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    //接收通知切换segement到训练界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToTrain) name:@"GOTOTRAIN" object:nil];
    //评估按钮选中
    [self evalBtnClick];
}

/**
 *  加入报告和方案控制器
 */
-(void)addchildvc
{
    [self.view addSubview:self.evalBtn];
    [self.view addSubview:self.trainBtn];
    [self addChildViewController:self.evalVc];
    [self addChildViewController:self.trainVc];
}

#pragma mark - 通知方法 -
//通知方法,去训练
-(void)goToTrain{
    [self trainBtnClick];
}

#pragma mark - 导航评估训练按钮点击方法 -
//点击评估导航按钮方法
-(void)evalBtnClick
{
    [self.evalBtn setBackgroundImage:[UIImage imageNamed:@"pingguanniu"] forState:UIControlStateNormal];
    [self.trainBtn setBackgroundImage:[UIImage imageNamed:@"xunliananniu"] forState:UIControlStateNormal];
    if (self.isEval) {
        return;
    }else{
        [self.currentVC.view removeFromSuperview];
        self.currentVC = self.childViewControllers[0];
        self.currentVC.view.frame = CGRectMake(0, 30+kScreen_Width*0.208*0.5256, self.view.bounds.size.width, self.view.bounds.size.height-60);
        [self.view addSubview:self.currentVC.view];
        NSLog(@"0");
        self.isEval = YES;
        self.isTrain = NO;
    }
}

//点击训练导航按钮方法
-(void)trainBtnClick
{
    [self.trainBtn setBackgroundImage:[UIImage imageNamed:@"xunliananniu1"] forState:UIControlStateNormal];
    [self.evalBtn setBackgroundImage:[UIImage imageNamed:@"pingguanniu1"] forState:UIControlStateNormal];
    if (self.isTrain) {
        return;
    }else{
        [self.currentVC.view removeFromSuperview];
        self.currentVC = self.childViewControllers[1];
        self.currentVC.view.frame = CGRectMake(0, 30+kScreen_Width*0.208*0.5256, self.view.bounds.size.width, self.view.bounds.size.height-60);
        [self.view addSubview:self.currentVC.view];
        NSLog(@"1");
        self.isEval = NO;
        self.isTrain = YES;
    }
}

#pragma mark - 懒加载 -
-(UIButton *)evalBtn{
    if (!_evalBtn) {
        _evalBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_CenterX - kScreen_Width*0.208, 30, kScreen_Width*0.208, kScreen_Width*0.208*0.5256)];
        [_evalBtn setBackgroundImage:[UIImage imageNamed:@"pingguanniu"] forState:UIControlStateNormal];
        [_evalBtn addTarget:self action:@selector(evalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _evalBtn;
}
-(UIButton *)trainBtn{
    if (!_trainBtn) {
        _trainBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_CenterX-0.5, 30, kScreen_Width*0.208, kScreen_Width*0.208*0.5256)];
        [_trainBtn setBackgroundImage:[UIImage imageNamed:@"xunliananniu"] forState:UIControlStateNormal];
        [_trainBtn addTarget:self action:@selector(trainBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _trainBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
