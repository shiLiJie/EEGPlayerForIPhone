//
//  BYTrainReportVc.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/6.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYTrainReportVc.h"
#import "AppDelegate.h"

@interface BYTrainReportVc ()

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLab;//总时长Lab
@property (weak, nonatomic) IBOutlet UILabel *evaluationLab;//评价Lab

@property (weak, nonatomic) IBOutlet UILabel *xiangshiLab;//想事Lab
@property (weak, nonatomic) IBOutlet UILabel *jiujieLab;//纠结
@property (weak, nonatomic) IBOutlet UILabel *yunzhuanLab;//运转
@property (weak, nonatomic) IBOutlet UILabel *pingjingLab;//平静
@property (weak, nonatomic) IBOutlet UILabel *fangsongLab;//放松
@property (weak, nonatomic) IBOutlet UILabel *buxihuanLab;//不喜欢

@end

@implementation BYTrainReportVc
//返回去训练界面
- (IBAction)backToTrainVc:(UIButton *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
//再次训练
- (IBAction)trainAgain:(UIButton *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
//去听音乐,切换第三个控制器
- (IBAction)relaxMusicToTabbarThree:(UIButton *)sender {
    //appdelegata方法切换tabbar控制器的当前控制器
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate goRelaxMusic];
    //返回上级页面
    [self trainAgain:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏状态栏
    [self.navigationController setNavigationBarHidden:YES];
    //给总时长Lab赋值
    self.totalTimeLab.text = self.totalTime;
    self.evaluationLab.text = self.stateLabText;
    //给状态持续时间赋值
    self.xiangshiLab.text = [NSString stringWithFormat:@"%02d:%02d",self.xiangshiCount/60,self.xiangshiCount%60];
    self.jiujieLab.text = [NSString stringWithFormat:@"%02d:%02d",self.jiujieCount/60,self.jiujieCount%60];
    self.yunzhuanLab.text = [NSString stringWithFormat:@"%02d:%02d",self.yunzhuanCount/60,self.yunzhuanCount%60];
    self.pingjingLab.text = [NSString stringWithFormat:@"%02d:%02d",self.pingjingCount/60,self.pingjingCount%60];
    self.fangsongLab.text = [NSString stringWithFormat:@"%02d:%02d",self.fangsongCount/60,self.fangsongCount%60];
    self.buxihuanLab.text = [NSString stringWithFormat:@"%02d:%02d",self.buxihuanCount/60,self.buxihuanCount%60];
    //自定义返回按钮后需要加这句话实现右滑返回
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}

-(void)viewWillAppear:(BOOL)animated{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
