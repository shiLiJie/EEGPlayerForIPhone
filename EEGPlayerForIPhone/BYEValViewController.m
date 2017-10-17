//
//  BYEValViewController.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/6.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYEValViewController.h"
#import "LXAlertView.h"

@interface BYEValViewController ()

@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;//选择时间按钮
@property (weak, nonatomic) IBOutlet UIButton *answerQuestionBtn;//开始答题按钮
@property (weak, nonatomic) IBOutlet UILabel *daojishiLab;//倒计时Lab
@property (weak, nonatomic) IBOutlet UIButton *startEvalBtn;//开始评估按钮
@property (weak, nonatomic) IBOutlet UILabel *chooseTimeLab;//请选择评估时间Lab

@property (nonatomic, weak) NSTimer *countDownTimer;//倒计时定时器
@property (weak, nonatomic) IBOutlet UIImageView *yuanBg;//旋转灰色背景
@property (weak, nonatomic) IBOutlet UIImageView *xuanZhuanImg;//旋转条

@property (weak, nonatomic) IBOutlet UILabel *disConnectLabOne;//描述未连接Lab
@property (weak, nonatomic) IBOutlet UILabel *disConnectLabTwo;//描述未连接Lab

@property (nonatomic, assign) BOOL isEvaling;//已经开始评估

@end

@implementation BYEValViewController

//即将显示的时候判断连接状态
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([BYBluetoothManager sharedManager].isConnect == YES) {
        self.chooseTimeBtn.hidden = NO;
        self.daojishiLab.hidden = NO;
        self.startEvalBtn.hidden = NO;
        self.chooseTimeLab.hidden = NO;
        self.yuanBg.hidden = NO;
        self.xuanZhuanImg.hidden = NO;
        self.disConnectLabOne.hidden = YES;
        self.disConnectLabTwo.hidden = YES;
        
    }else{
        self.chooseTimeBtn.hidden = YES;
        self.daojishiLab.hidden = YES;
        self.startEvalBtn.hidden = YES;
        self.chooseTimeLab.hidden = YES;
        self.yuanBg.hidden = YES;
        self.xuanZhuanImg.hidden = YES;
        self.disConnectLabOne.hidden = NO;
        self.disConnectLabTwo.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isEvaling = NO;//加载开始没有开始评估
    
    //监听appdelegate发送过来的通知
    //在正在评估的时候才会发送过来
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPinggu) name:@"STOPPINGGU" object:nil];
    
}

//监听appdelegate发送过来的通知,弹出提示框是否停评估
-(void)stopPinggu{
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"确定要停止评估么?" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        if (clickIndex == 0) {//取消
            return ;
        }else{//确定
            [self startEval:nil];
        }
    }];
    [alert showLXAlertView];
}

//答题按钮方法
- (IBAction)answerQuestion:(UIButton *)sender {
    if ([BYBluetoothManager sharedManager].isConnect == YES) {
    
        BYQuestionView *questionView = [[BYQuestionView alloc] initWithFrame:CGRectMake(0, -60, 100, 100)];
        questionView.alterImg.image = [UIImage imageNamed:@"dtbg"];
        questionView.dismissBtn.hidden = NO;
        UIWindow *window = self.view.window;
        [window addSubview:questionView];
        
    
    }else{
        //如果在push跳转时需要隐藏tabBar，设置self.hidesBottomBarWhenPushed=YES;
        self.parentViewController.hidesBottomBarWhenPushed=YES;
        //推出开始匹配控制器
        BYSleepEvalVc *vc = [[BYSleepEvalVc alloc] init];
        [self.parentViewController.navigationController pushViewController:vc animated:YES];
        //并在push后设置self.hidesBottomBarWhenPushed=NO;
        //这样back回来的时候，tabBar会恢复正常显示。
        self.parentViewController.hidesBottomBarWhenPushed=NO;
        [self.navigationController setNavigationBarHidden:NO];
        //导航栏navbar标题颜色失灵的时候强行设置方法:
        vc.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
    }
}

//选择时间按钮方法,弹出pickview
- (IBAction)chooseTime:(UIButton *)sender {
    //自定义的pickview,给出三个时间选项
    NSArray * str  = @[@"00:05",@"01:00",@"03:00"];
    BYSheetPickerView *pickerView = [BYSheetPickerView BYSheetStringPickerWithTitle:str andHeadTitle:@"时间选择" Andcall:^(BYSheetPickerView *pickerView, NSString *choiceString) {
        _daojishiLab.text = choiceString;
        [pickerView dismissPicker];
    } compent:0 title1:nil title12:nil dismiss:^{
        //
    }];
    
    [pickerView show];
    
}

//开始评估按钮
- (IBAction)startEval:(UIButton *)sender {
    //评估前先判断连接状态
    //如果断开了
    if ([BYBluetoothManager sharedManager].isConnect == NO) {
        return;//直接退出,不向下执行
    }
    
    // 没有开始检测的时候,开始检测
    if (self.isEvaling == NO) {
        [self startEval];// 开始评估
    }else{
        [self stopEval];// 停止评估
    }
}

//开始评估
-(void)startEval{
    NSString *time = self.daojishiLab.text;//时间格式 00:00
    NSArray *timeArr = [time componentsSeparatedByString:@":"];//分割前后
    if ([timeArr[0] isEqualToString:@"00"] && [timeArr[1] isEqualToString:@"00"]) {//如果是00::00直接退出,不进行倒计时操作
        return;
    }
    //初始化睡眠评估模型数据
    [self initialEEGModelData];
    //向设备发送开始命令
    [self postStartToBLE];
    self.chooseTimeLab.text = @"评估时间剩余:";
    [self.startEvalBtn setBackgroundImage:[UIImage imageNamed:@"jieshupingguanniu"] forState:UIControlStateNormal];
    //禁用一秒按钮,防止重复点击命令乱掉
    [self.startEvalBtn setEnabled:NO];
    
    //给进度条添加动画
    [self addAnma];
    //GCD延迟一秒执行,为了配合动画效果
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        //开启定时器一秒一次进行倒计时
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        [self.countDownTimer fire];
        [self.startEvalBtn setEnabled:YES];
        
    });
    self.isEvaling = YES;
    
    
    //给通知
    //发送appdelegate通知他们我正在评估,切换控制器的时候要判断一下能不能直接跳转
    NSNotification *notification = [NSNotification notificationWithName:@"ISPINGGU" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

//停止评估
-(void)stopEval{
    // 已经开始检测
    // 更换开始检测按钮image
    [self.startEvalBtn setBackgroundImage:[UIImage imageNamed:@"kaishipingguanniu"] forState:UIControlStateNormal];
    self.isEvaling = NO;// 开始 = no
    //给通知
    //发送appdelegate通知他们我正在评估,切换控制器的时候要判断一下能不能直接跳转
    NSNotification *notification = [NSNotification notificationWithName:@"NOPINGGU" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.countDownTimer invalidate];// 移除定时器
    self.daojishiLab.text = @"00:00";// 初始化倒计时时间
    [self.xuanZhuanImg.layer removeAnimationForKey:@"1234"];// 移除旋转动画
    [self postStopToBLE];// 发送停止命令
    //禁用一秒按钮,防止命令乱
    [self enableBtn:self.startEvalBtn];
}

//禁用一秒按钮,防止命令乱
-(void)enableBtn:(UIButton *)btn{
    //按钮禁用防止命令乱掉
    [btn setEnabled:NO];
    //GCD延迟一秒执行,让按钮恢复
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [btn setEnabled:YES];
        
    });
}

//初始化睡眠评估模型数据
-(void)initialEEGModelData{
    BYEEGDataModel *model = [BYEEGDataModel sharedEEGData];
    [model initSleepDataModel];
}

// 加载动画
- (void)addAnma {
    
    NSString *time = self.daojishiLab.text;//时间格式 00:00
    NSArray *timeArr = [time componentsSeparatedByString:@":"];//分割前后
    int sec = [timeArr[1] intValue];//秒
    int min = [timeArr[0] intValue];//分钟
    int totalTime = min*60 + sec;//总计有多少秒
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];//角度,一周
    rotationAnimation.duration = 5;//五秒一圈
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = totalTime/5;//圈数:总秒数/5
    rotationAnimation.delegate = self;
    [self.xuanZhuanImg.layer addAnimation:rotationAnimation forKey:@"1234"];
    
}

#pragma mark - 定时器方法 -
//定时器倒计时方法
-(void)timeFireMethod{
    NSString *time = self.daojishiLab.text;//时间格式 00:00
    NSArray *timeArr = [time componentsSeparatedByString:@":"];//分割前后
    int sec = [timeArr[1] intValue];//秒
    int min = [timeArr[0] intValue];//分钟
    if (sec == 0 && min != 0) {//秒=0,分!=0
        sec = 59;//秒=59
        min --;//分钟-1
        self.daojishiLab.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
        return;
    }else if (sec == 0 && min == 0){//分秒==0
        [self.countDownTimer invalidate];//移除定时器
        if (self.isEvaling == YES) {//只有在评估的时候才会跳转
            [self postStopToBLE];// 发送停止命令
            [self.countDownTimer invalidate];//移除定时器
            self.daojishiLab.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
            [self.startEvalBtn setBackgroundImage:[UIImage imageNamed:@"kaishipingguanniu"] forState:UIControlStateNormal];
            
            //如果在push跳转时需要隐藏tabBar，设置self.hidesBottomBarWhenPushed=YES;
            self.parentViewController.hidesBottomBarWhenPushed=YES;
            //评估推出报告界面
            BYEvaReportVc *evReport = [[BYEvaReportVc alloc] init];
            //中速伽马波最大值
            NSNumber *maxValue = [BYEEGDataModel sharedEEGData].maxSleepValue;
            CGFloat progress = 1 - [maxValue floatValue] / 600000.0f;
            if (progress < 0) {
                progress = 0;
            }
            evReport.progress = progress;
            
            [self.parentViewController.navigationController pushViewController:evReport animated:YES];
            //这样back回来的时候，tabBar会恢复正常显示。
            self.parentViewController.hidesBottomBarWhenPushed=NO;
            //结束评估
            self.isEvaling = NO;
            
            //给通知
            //发送appdelegate通知他们我正在评估,切换控制器的时候要判断一下能不能直接跳转
            NSNotification *notification = [NSNotification notificationWithName:@"NOPINGGU" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            return;
        }
    }
    if (sec != 0) {//普通秒!=0
        sec--;//秒--
        self.daojishiLab.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    }
}

#pragma mark - 向设备发送开始停止命令 -
//向设备发送开始命令
-(void)postStartToBLE{
    //创建蓝牙传感器单例
    BYBluetoothManager *sensor = [BYBluetoothManager sharedManager];
    //开始的时候先发送一条结束命令
    NSMutableData *datastop = [[BYWorkTools sharedTools] huahsakdsa:kBlueStop];
//    [sensor write:sensor.activePeripheral data:datastop];
    [sensor stopText];
    //发送开始命令
    NSMutableData *data = [[BYWorkTools sharedTools] huahsakdsa:kBlueStar];
//    [sensor write:sensor.activePeripheral data:data];
    [sensor startText];
}
//向设备发送停止命令
-(void)postStopToBLE{
    //创建蓝牙传感器单例
    BYBluetoothManager *sensor = [BYBluetoothManager sharedManager];
    NSMutableData *data = [[BYWorkTools sharedTools] huahsakdsa:kBlueStop];
//    [sensor write:sensor.activePeripheral data:data];
    [sensor stopText];
    
    //不影响住线程,两秒后执行
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //延时执行的方法,判断是否是错误的
//        [sensor write:sensor.activePeripheral data:data];
        [sensor stopText];
    });// 发送停止命令
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
