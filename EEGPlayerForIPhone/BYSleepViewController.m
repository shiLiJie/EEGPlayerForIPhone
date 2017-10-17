//
//  BYSleepViewController.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/5.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYSleepViewController.h"
#import "BYWaterView.h"
#import "AppDelegate.h"
#import "UIColor+Extend.h"
#import "BYWorkTools.h"
#import "TAGPlayer.h"
#import "LXAlertView.h"

@interface BYSleepViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backHomeBtn;//左上返回按钮
@property (weak, nonatomic) IBOutlet UILabel *goToSleepLab;//我要睡觉Lab
@property (weak, nonatomic) IBOutlet UIButton *startMarryBtn;//开始匹配按钮

@property (weak, nonatomic) IBOutlet UILabel *stopLab;//00:00
@property (weak, nonatomic) IBOutlet UILabel *startLab;//03:00

@property (weak, nonatomic) IBOutlet UIButton *connectBlue;//连接蓝牙按钮
@property (weak, nonatomic) IBOutlet UIButton *listenMusicBtn;//试听音乐按钮
@property (weak, nonatomic) IBOutlet UILabel *disconnectLab;//文字描述Lab
@property (weak, nonatomic) IBOutlet UILabel *disconnectLab1;//文字描述Lab
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (nonatomic, strong) BYWaterView *waterView;//中心水波纹视图
@property (nonatomic, weak) NSTimer *waterTimer;//水波纹定时器

@property (weak, nonatomic) IBOutlet UIView *proBg;//进度条背景
@property (nonatomic, strong) UIView *clipView;;//进度条背景上增加一个透明的view用来添加填充视图

@property (nonatomic, assign) BOOL isMarrying;//bool类型判断是否正在匹配
@property (nonatomic, assign) BOOL isOkMarry;//bool类型判断是否正在匹配成功

@property (nonatomic, strong) UILabel *marryMusicLab;//放在水波纹view上的Lab,显示正在匹配或匹配成功

@property (strong, nonatomic) TAGPlayer *player;//播放器类

@end

@implementation BYSleepViewController

-(void)viewWillAppear:(BOOL)animated{
    //判断是否连接,没连接走没连接UI
    if ([BYBluetoothManager sharedManager].isConnect == YES) {//连接
        _backHomeBtn.hidden = NO;
        _goToSleepLab.hidden = NO;
        _startMarryBtn.hidden = NO;
        _proBg.hidden = NO;
        _waterView.hidden = NO;
        _stopLab.hidden = NO;
        _startLab.hidden = NO;
        _connectBlue.hidden = YES;
        _listenMusicBtn.hidden = YES;
        _disconnectLab.hidden = YES;
        _disconnectLab1.hidden = YES;
        self.bgImage.image = [UIImage imageNamed:@"woyaoshuijiaobg"];
        //隐藏navbar
        [self.navigationController setNavigationBarHidden:YES];
    }else{//没连接
        _backHomeBtn.hidden = YES;
        _goToSleepLab.hidden = YES;
        _startMarryBtn.hidden = YES;
        _proBg.hidden = YES;
        _waterView.hidden = YES;
        _stopLab.hidden = YES;
        _startLab.hidden = YES;
        _connectBlue.hidden = NO;
        _listenMusicBtn.hidden = NO;
        _disconnectLab.hidden = NO;
        _disconnectLab1.hidden = NO;
        self.bgImage.image = [UIImage imageNamed:@""];
        self.navigationItem.title = @"我要睡觉";
        //不隐藏navbar
        [self.navigationController setNavigationBarHidden:NO];
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
    }
}

//初始化添加视图,bool
-(void)initialAllObject{
    //初始化的时候创建一个水波纹视图,用来站位用
    self.waterView = [[BYWaterView alloc]initWithFrame:CGRectMake(kScreen_CenterX-kScreen_Width/5, kScreen_CenterY-kScreen_Width/2.5, kScreen_Width/2.5, kScreen_Width/2.5)];
    _waterView.layer.masksToBounds = YES;
    _waterView.layer.cornerRadius = kScreen_Width/5;
    _waterView.layer.borderWidth = 0;
    _waterView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _waterView.backgroundColor = [UIColor hexColorWithString:@"fafafa"];
    _waterView.alpha = 0.6;
    [self.view addSubview:self.waterView];
    
    [self.startMarryBtn setImage:[UIImage imageNamed:@"woyaoshuijiaokaishi"] forState:UIControlStateNormal];
    
    self.isMarrying = NO;
    self.isOkMarry = NO;
    
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化基本内容
    [self initialAllObject];
}


-(void)viewWillDisappear:(BOOL)animated{
    //匹配不成功时已经开始匹配时点击开始匹配按钮
    [self stopMarry];
}


//给进度条添加填充图片
- (void)addImageViewWithImage:(NSString *)image
                      SupView:(UIView *)supView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.proBg.frame.size.width, self.proBg.frame.size.height)];
    imageView.image = [UIImage imageNamed:image];
    [supView addSubview:imageView];
}
#pragma mark - TAGPlayerDelegate -
//音乐类的代理
-(void)backTouchEvent:(NSNumber *)status{
    
}

//播放匹配音乐
-(void)playMusicWithPath{
    //获取主路径
    NSString *pathDocuments=kDocument
    NSString *createPath=[NSString stringWithFormat:@"%@/BYMusic/MarryMusic",pathDocuments];
    //拿到音乐路径下的歌曲
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:createPath error:nil];
    //歌曲的全路径
    NSString *musicPath = [NSString stringWithFormat:@"%@/%@",createPath,arr[0]];
    //歌曲中含有中文,utf8转码
    NSString *music = [musicPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *musicUrl = [NSURL URLWithString:music];
    //播放路径音乐
    [self.player PlayerName:musicUrl];
}

#pragma mark - 已经成功连接好设备时的按钮方法
//左上角返回首页按钮
- (IBAction)backHomeView:(UIButton *)sender {
    //评估中返回,弹出提示框

    
    if (self.isMarrying == YES) {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"提示" message:@"确定要停止匹配音乐么?" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            if (clickIndex == 0) {//取消
                return ;
            }else{//确定
                [self.clipView removeFromSuperview];
                [[self navigationController] popViewControllerAnimated:YES];
                //匹配不成功时已经开始匹配时点击开始匹配按钮
                [self stopMarry];
            }
        }];
        [alert showLXAlertView];
    }else{
        [self.clipView removeFromSuperview];
        [[self navigationController] popViewControllerAnimated:YES];
        //匹配不成功时已经开始匹配时点击开始匹配按钮
        [self stopMarry];
    }
}

//开始匹配按钮
- (IBAction)startMarry:(UIButton *)sender {
    
    if ([BYBluetoothManager sharedManager].isConnect == YES){
        //如果匹配成功
        if (self.isOkMarry == YES) {
            self.isMarrying = NO;
            //切换到音乐控制器
            [self listenMusic:nil];
            [self backHomeView:nil];
            [self.clipView removeFromSuperview];
            
        }else{//匹配不成功
            //点击时先判断是否正在匹配,如果没有,就开启匹配动画
            if (self.isMarrying == NO) {
                //匹配不成功时没有开始匹配时点击开始匹配按钮
                [self toMarry];
                //如果正在匹配,停止动画
            }else{
                //匹配不成功时已经开始匹配时点击开始匹配按钮
                [self stopMarry];
            }
        }
    }else{
        //匹配不成功时已经开始匹配时点击开始匹配按钮
        [self stopMarry];
    }
}
#pragma mark - 匹配没成功时,点击开始匹配按钮的判断
/**
 *  匹配不成功时没有开始匹配时点击开始匹配按钮
 */
-(void)toMarry{
    //开始匹配,给设备发送开始命令
    [self postStartToBLE];
    //创建正在匹配音乐的lab添加到水波纹视图上
    self.marryMusicLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.waterView.frame.size.height/2-self.waterView.frame.size.height/10, self.waterView.frame.size.width, self.waterView.frame.size.height/5)];
    self.marryMusicLab.text = @"正在匹配音乐";
    self.marryMusicLab.font = [UIFont systemFontOfSize:13];
    self.marryMusicLab.textAlignment = NSTextAlignmentCenter;
    [self.waterView addSubview:self.marryMusicLab];
    
    //如果没有开始匹配,创建一个view用来添加进度条
    self.clipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.proBg.frame.size.height)];
    self.clipView.backgroundColor = [UIColor clearColor];
    self.clipView.clipsToBounds = YES;
    [self.proBg addSubview:self.clipView];
    //给容器添加进度条
    [self addImageViewWithImage:@"jindutiao" SupView:self.clipView];
    //调取定时器方法,水波纹
    self.waterTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waterAnimation) userInfo:nil repeats:YES];
    //开启定时器
    [self.waterTimer fire];
    
    //给黄色不规则进度条添加动画,改变width
    CGRect rect = self.clipView.frame;
    rect.size.width = self.proBg.frame.size.width;
    [UIView animateWithDuration:(136) animations:^{
        self.clipView.frame = rect;
    }];
    self.isMarrying = YES;
    //设置开始匹配按钮变成停止匹配
    [self.startMarryBtn setImage:[UIImage imageNamed:@"woyaoshuijiaojieshu"] forState:UIControlStateNormal];
    //按钮禁用防止命令乱掉
    [self enableBtn:self.startMarryBtn];
    //播放匹配音乐
    [self playMusicWithPath];
}

/**
 *  匹配不成功时已经开始匹配时点击开始匹配按钮
 */
-(void)stopMarry{
    //结束匹配,给设备发送结束命令
    [self postStopToBLE];
    //手动结束,初始化时间Lab
    self.startLab.text = @"00:00";
    //把正在匹配音乐的Lab清空
    [self.marryMusicLab removeFromSuperview];
    //移除进度条的容器view
    [self.clipView removeFromSuperview];
    //停止定时器,不在水波纹
    [self.waterTimer invalidate];
    //把停止容器动画,这里是多此一举了
    [self.clipView.layer removeAllAnimations];
    self.clipView.frame = CGRectMake(0, 0, 0, self.proBg.frame.size.height);
    self.isMarrying = NO;
    //设置停止匹配按钮为开始匹配
    [self.startMarryBtn setImage:[UIImage imageNamed:@"woyaoshuijiaokaishi"] forState:UIControlStateNormal];
    //按钮禁用防止命令乱掉
    [self enableBtn:self.startMarryBtn];
    //音乐停止
    [self.player.musicPlayer stop];
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

#pragma mark - 普通状态下开始匹配,计算时间添加水波纹和进度条动画
//创建水波纹视图
-(void)waterAnimation{
    if ([self.startLab.text isEqualToString:@"00:00"]) {
        //执行代理方法
        [self.delegate starStage];
    }
    if ([self.startLab.text isEqualToString:@"00:06"]) {
        //执行代理方法
        [self.delegate oneStage];
    }
    if ([self.startLab.text isEqualToString:@"00:18"]) {
        //执行代理方法
        [self.delegate twoStage];
    }
    if ([self.startLab.text isEqualToString:@"01:00"]) {
        //执行代理方法
        [self.delegate thrStage];
    }
    if ([self.startLab.text isEqualToString:@"01:46"]) {
        //执行代理方法
        [self.delegate fouStage];
    }
    if ([self.startLab.text isEqualToString:@"02:16"]) {
        //执行代理方法
        [self.delegate fivStage];
    }
    

    NSString *time = self.startLab.text;//时间格式 00:00
    NSArray *timeArr = [time componentsSeparatedByString:@":"];//分割前后
    int sec = [timeArr[1] intValue];//秒
    int min = [timeArr[0] intValue];//分钟
    if (sec == 59) {
        sec = 0;
        min ++;
        self.startLab.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
        return;
    }else if (sec == 16 && min == 2){
        self.startLab.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
        //匹配音乐倒计时结束,成功
        self.marryMusicLab.text = @"匹配音乐成功";//把正在匹配音乐的Lab清空
        self.isOkMarry = YES;//匹配成功
        [self.waterTimer invalidate];//停止定时器,不在水波纹
        [self.player.musicPlayer stop];//播放匹配音乐
        self.isMarrying = NO;
        //设置停止匹配按钮为开始匹配
        [self.startMarryBtn setImage:[UIImage imageNamed:@"qushitinganniu"] forState:UIControlStateNormal];
        //发送停止脑波数据命令
        [self postStopToBLE];
        //代理方法
        [self.delegate stopStage];
        return;
    }
    if (sec != 59) {
        sec ++;
        self.startLab.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    }
    
    //循环创建水波纹视图
    __block BYWaterView *waterView = [[BYWaterView alloc]initWithFrame:CGRectMake(kScreen_CenterX-kScreen_Width/5, kScreen_CenterY-kScreen_Width/2.5, kScreen_Width/2.5, kScreen_Width/2.5)];
    //设置基本属性
    waterView.layer.masksToBounds = YES;
    waterView.layer.cornerRadius = kScreen_Width/5;
    waterView.layer.borderWidth = 0;
    waterView.layer.borderColor = [[UIColor whiteColor] CGColor];
    waterView.backgroundColor = [UIColor hexColorWithString:@"fafafa"];
    waterView.alpha = 0.15;
    [self.view addSubview:waterView];
    //永远保证跟视图,开始创建的圆和提示正在匹配音乐的Lab在最上层
    [self.view bringSubviewToFront:self.waterView];
    //添加动画,放大,结束移除waterview
    [UIView animateWithDuration:6 animations:^{
        waterView.transform = CGAffineTransformScale(waterView.transform, 2, 2);
        waterView.alpha = 0;
    } completion:^(BOOL finished) {
        [waterView removeFromSuperview];
    }];
}

#pragma mark - 还没有连接设备时的按钮方法 -
//连接蓝牙按钮方法
- (IBAction)connectBlue:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
    //appdelegata方法切换tabbar控制器的当前控制器
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate goToConnectBlue];
    
    NSNotification *notification = [NSNotification notificationWithName:@"PUSHCONNECTBLUEPOP" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//试听音乐按钮方法
- (IBAction)listenMusic:(UIButton *)sender {
    //appdelegata方法切换tabbar控制器的当前控制器
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate goRelaxMusic];
    
    [self backHomeView:nil];
}

#pragma mark - 向设备发送开始停止命令 -
//向设备发送开始命令
-(void)postStartToBLE{
    //创建蓝牙传感器单例
    BYBluetoothManager *sensor = [BYBluetoothManager sharedManager];
    //开始的时候先发送一条结束命令
    [sensor stopText];
    //发送开始命令
    [sensor startText];
}
//向设备发送停止命令
-(void)postStopToBLE{
    //创建蓝牙传感器单例
    BYBluetoothManager *sensor = [BYBluetoothManager sharedManager];
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


#pragma mark - 懒加载 -
//播放器类对象
-(TAGPlayer *)player{
    if (!_player) {
        _player = [TAGPlayer shareTAGPlayer];
    }
    return _player;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
