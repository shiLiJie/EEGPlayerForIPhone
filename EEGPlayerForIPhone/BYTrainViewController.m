//
//  BYTrainViewController.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/6.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYTrainViewController.h"
#import "BYSheetPickerView.h"
#import "BYTrainReportVc.h"
#import "BYWorkTools.h"
#import "BYEEGDataModel.h"
#import "UserObj.h"
#import "TAGPlayer.h"

@interface BYTrainViewController ()<PlayEvent>{

    NSString *fileName;
    NSString *fileNameChart;
    NSFileHandle * logFile;
    NSFileHandle * logFileChart;
    NSMutableData * output;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eyesConstraint;//眼睛的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eyesCloseConstraint;//闭眼的约束
@property (weak, nonatomic) IBOutlet UIImageView *eyesImage;//眼睛image
@property (weak, nonatomic) IBOutlet UIImageView *eyesZhezhao;

@property (weak, nonatomic) IBOutlet UILabel *daojishiLab;//倒计时Lab
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;//选择时间按钮
@property (weak, nonatomic) IBOutlet UIButton *startTrainBtn;//开始训练按钮
@property (nonatomic, weak) NSTimer *countDownTimer;//倒计时定时器
@property (weak, nonatomic) IBOutlet UILabel *disConnectLabOne;//未连接提示Lab
@property (weak, nonatomic) IBOutlet UILabel *disConnectLabTwo;//未连接提示Lab
@property (weak, nonatomic) IBOutlet UIImageView *leftLightImg;//左侧好多小灯的img,现在是占位
@property (weak, nonatomic) IBOutlet UIImageView *catBirdImg;//猫头鹰
@property (weak, nonatomic) IBOutlet UIButton *lightBtn;//开关灯按钮
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;//开关音乐按钮
@property (weak, nonatomic) IBOutlet UIImageView *headThinkImg;//猫头鹰顶部提示描述image

@property (nonatomic, assign) BOOL isTraining;//是否正在训练
@property (nonatomic, assign) BOOL isLighting;//灯是否正在亮
@property (nonatomic, assign) BOOL isMusicing;//音乐是否正在播放

@property (nonatomic, assign) BOOL isXiangshi;//为了避免水滴状image频繁闪烁加的判断,如果在执行动画就不执行其他的
@property (nonatomic, assign) BOOL isJiujie;
@property (nonatomic, assign) BOOL isYunzhuan;
@property (nonatomic, assign) BOOL isPingjing;
@property (nonatomic, assign) BOOL isFangsong;
@property (nonatomic, assign) BOOL isBuxihuan;
@property (nonatomic, assign) BOOL isYiBan;

@property (nonatomic, assign) int xiangShiCount;//int类型记录六种状态出现的次数/持续时间
@property (nonatomic, assign) int jiuJieCount;
@property (nonatomic, assign) int yunZhuanCount;
@property (nonatomic, assign) int pingJingCount;
@property (nonatomic, assign) int fangSongCount;
@property (nonatomic, assign) int buXihuanCount;


@property(nonatomic, copy) NSString *totalTime;//训练总时长
@property(nonatomic, assign) NSInteger musicTime;//开启音乐总时长

@property(nonatomic, strong) NSDate *startDate;//阶段的开始时间
@property(nonatomic, strong) NSDate *stopDate;//阶段的结束时间

@property (strong, nonatomic) TAGPlayer *player;//播放器类
@property (nonatomic, strong) NSString *musicName;//歌曲名
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *birdDownConstraint;//猫头鹰下边的约束

@property(nonatomic, strong) NSString *startTextTime;//开始检测时间
@property(nonatomic, strong) NSString *stopTextTime;//结束检测时间

@end

@implementation BYTrainViewController

#pragma mark - 帮助方法 -
//计算时间差
-(NSInteger)getTimeInterval:(NSDate *)startDate stopDate:(NSDate *)stopDate{
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:startDate toDate:stopDate options:0];
    NSInteger sec = [d hour]*3600+[d minute]*60+[d second];
    return sec;
}
//格式化计算获取当前时间
-(NSString *)getNowTime{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

#pragma mark - 按钮点击事件方法 -
- (IBAction)lightOnOrOff:(UIButton *)sender {
    //开关灯按钮方法
    
}
//音乐介入按钮点击时间
- (IBAction)musicOnOrOff:(UIButton *)sender {
    //如果没在检测,禁用音乐音乐介入按钮
    if (self.isTraining == NO) {
        return;
    }
    //开关音乐按钮方法
    if (self.isMusicing == NO) {
        [self starMusic];//开始音乐计算时间
        [self.musicBtn setImage:[UIImage imageNamed:@"yinyue1"] forState:UIControlStateNormal];
    }else{
        [self stopMusic];//结束音乐计算时间
        [self.musicBtn setImage:[UIImage imageNamed:@"yinyue"] forState:UIControlStateNormal];
    }
}
//开始音乐计算时间
-(void)starMusic{
    self.isMusicing = YES;
    //记录阶段的开始时间
    self.startDate = [NSDate date];
    if (self.isTraining){
        //开启音乐
        [self.player.musicPlayer play];
    }
    //如果后来再开启音乐就是一开始没有拿到歌曲名
    if (self.musicName == nil) {
        //控制在开始检测的时候
        if (self.isTraining) {
            //从头开始播放音乐
            [self playMusicWithPath];
        }
    }
}
//结束音乐计算时间
-(void)stopMusic{
    self.isMusicing = NO;
    //记录阶段的结束时间
    self.stopDate = [NSDate date];
    if (self.isTraining){
        [self.player.musicPlayer pause];
    }
    NSInteger time = [self getTimeInterval:self.startDate stopDate:self.stopDate];
    self.musicTime += time;
    //结束音乐
}

//播放训练音乐
-(void)playMusicWithPath{
    //获取主路径
    NSString *pathDocuments=kDocument
    NSString *createPath=[NSString stringWithFormat:@"%@/BYMusic/TrainingMusic",pathDocuments];
    //拿到音乐路径下的歌曲
    NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:createPath error:nil];
    //歌曲的全路径
    NSString *musicPath = [NSString stringWithFormat:@"%@/%@",createPath,arr[0]];
    //歌曲中含有中文,utf8转码
    NSString *music = [musicPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.musicName = music;
    NSURL *musicUrl = [NSURL URLWithString:music];
    //播放路径音乐
    [self.player PlayerName:musicUrl];
}

//选择时间按钮点击方法
- (IBAction)chooseTime:(UIButton *)sender {
//    [self zaixiangshi];
    //训练过程中不许弹出选择时间Pickerview
    if (self.isTraining == YES) {
        return;
    }
    //自定义的pickview,给出三个时间选项
    NSArray * str  = @[@"00:05",@"01:00",@"10:00"];

    BYSheetPickerView *pickerView  = [BYSheetPickerView BYSheetStringPickerWithTitle:str andHeadTitle:@"时间选择" Andcall:^(BYSheetPickerView *pickerView, NSString *choiceString) {
        _daojishiLab.text = choiceString;
        self.totalTime = choiceString;//这里选择的时间就是训练的总时长
        [pickerView dismissPicker];
    } compent:0 title1:nil title12:nil dismiss:^{
        //
    }];
    
    [pickerView show];
}

//开始训练按钮点击方法
- (IBAction)startTrain:(UIButton *)sender {
    
    [self initMusicTime];//初始化音乐累计时间
    //评估前先判断连接状态
    //如果断开了
    if ([BYBluetoothManager sharedManager].isConnect == NO) {
        return;//直接退出,不向下执行
    }
    
    if (self.isTraining == NO) {
        [self startTrain];//开始训练
        self.startTextTime = [self getNowTime];//拿到开始训练的格式时间
    }else{
        [self stopTrain];//停止训练
    }
}


//开始训练
-(void)startTrain{
    NSString *time = self.daojishiLab.text;//时间格式 00:00
    NSArray *timeArr = [time componentsSeparatedByString:@":"];//分割前后
    if ([timeArr[0] isEqualToString:@"00"] && [timeArr[1] isEqualToString:@"00"]) {//如果是00::00直接退出,不进行倒计时操作
        return;
    }
    //发送开始检测命令
    [self postStartToBLE];
    //只有时间不为00:00 的时候才会走下边的方法
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [self.countDownTimer fire];
    [self.startTrainBtn setImage:[UIImage imageNamed:@"jieshuxunlian"] forState:UIControlStateNormal];
    self.isTraining = YES;

    //GCD延迟一秒执行,为了配合动画效果
    [self enableBtn:self.startTrainBtn];
    
    if (self.isMusicing == NO) {//如果点击开始训练按钮的时候,音乐开关是关着的就直接退出不放音乐
        return;
    }
    [self starMusic];//开启音乐时间记录
    [self playMusicWithPath];//从头开始播放第一首音乐

}

//停止训练
-(void)stopTrain{
    //GCD延迟一秒执行,为了配合动画效果
    [self enableBtn:self.startTrainBtn];
    self.daojishiLab.text = @"00:00";
    [self initMusicTime];//初始化音乐累计时间
    [self.countDownTimer invalidate];//移除定时器
    [self.startTrainBtn setImage:[UIImage imageNamed:@"kaishixunlian"] forState:UIControlStateNormal];
    self.headThinkImg.hidden = YES;
    self.isTraining = NO;
    //向设备发送停止命令
    [self postStopToBLE];
    [self.player stopSong];
    self.isMusicing = NO;
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

#pragma mark - 定时器倒计时方法,跳转到报告界面 -
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
        [self postStopToBLE];// 发送停止命令
        self.daojishiLab.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
        [self.startTrainBtn setImage:[UIImage imageNamed:@"kaishixunlian"] forState:UIControlStateNormal];
        self.headThinkImg.hidden = YES;
        
        //如果在push跳转时需要隐藏tabBar，设置self.hidesBottomBarWhenPushed=YES;
        self.parentViewController.hidesBottomBarWhenPushed=YES;
        BYTrainReportVc *trReport = [[BYTrainReportVc alloc] init];
        //获取训练结束时的格式化时间
        self.stopTextTime = [self getNowTime];
        //在跳转的时候如果还在播放音乐,停止音乐
        if (self.isMusicing == YES) {
            //记录阶段的结束时间
            self.stopDate = [NSDate date];
            NSInteger time = [self getTimeInterval:self.startDate stopDate:self.stopDate];
            self.musicTime += time;//结束音乐计算时间
            [self.player stopSong];//停止音乐播放
            self.musicName = nil;//清空音乐名称
        }
        self.isTraining = NO;//停止训练了
        //给训练总时长Lab赋值
        trReport.totalTime = self.totalTime;
        //状态次数/时长赋值
        trReport.buxihuanCount = self.buXihuanCount;
        trReport.yunzhuanCount = self.yunZhuanCount;
        trReport.fangsongCount = self.fangSongCount;
        trReport.jiujieCount = self.jiuJieCount;
        trReport.xiangshiCount = self.xiangShiCount;
        trReport.pingjingCount = self.pingJingCount;
        //状态栏评价
        float a = self.fangSongCount / [self.totalTime floatValue];
        if (a > 30) {
            trReport.stateLabText = @"良好";
        }
        if (a < 30 && a > 15) {
            trReport.stateLabText = @"一般";
        }
        if (a < 15 && a >= 0) {
            trReport.stateLabText = @"差";
        }
        if (a == 0) {
            trReport.stateLabText = @"无";
        }
        //给训练是音乐介入的Lab赋值
        trReport.musicTime = [NSString stringWithFormat:@"%02ld:%02ld",self.musicTime/60,self.musicTime%60];
        [self.navigationController pushViewController:trReport animated:YES];

        //这样back回来的时候，tabBar会恢复正常显示。
        self.parentViewController.hidesBottomBarWhenPushed=NO;
        //训练成功结束,生成训练记录日志
        //发送通知存储
        [self performSelector:@selector(writeLog) withObject:nil afterDelay:0.01];
        NSNotification *notification =[NSNotification notificationWithName:@"WRITELOG" object:nil userInfo:nil];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        return;
    }
    if (sec != 0) {//普通秒!=0
        sec--;//秒--
        self.daojishiLab.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    }
}


#pragma mark - viewdidload -
//即将显示的时候判断连接状态
-(void)viewWillAppear:(BOOL)animated{
    
    [self initMusicTime];//初始化音乐累计时间/状态持续时间
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([BYBluetoothManager sharedManager].isConnect == YES) {
        self.chooseTimeBtn.hidden = NO;
        self.daojishiLab.hidden = NO;
        self.startTrainBtn.hidden = NO;
        self.leftLightImg.hidden = NO;
        self.catBirdImg.hidden = NO;
        self.lightBtn.hidden = NO;
        self.musicBtn.hidden = NO;
        self.eyesImage.hidden = NO;
        self.eyesZhezhao.hidden = NO;
        self.headThinkImg.hidden = NO;
        self.disConnectLabOne.hidden = YES;
        self.disConnectLabTwo.hidden = YES;
    }else{
        self.chooseTimeBtn.hidden = YES;
        self.daojishiLab.hidden = YES;
        self.startTrainBtn.hidden = YES;
        self.leftLightImg.hidden = YES;
        self.catBirdImg.hidden = YES;
        self.lightBtn.hidden = YES;
        self.musicBtn.hidden = YES;
        self.eyesImage.hidden = YES;
        self.eyesZhezhao.hidden = YES;
        self.headThinkImg.hidden = YES;
        self.disConnectLabOne.hidden = NO;
        self.disConnectLabTwo.hidden = NO;
    }
}

//初始化音乐累计时间
-(void)initMusicTime{
    self.musicTime = 0;//音乐开启累计时间初始化
    
    self.buXihuanCount = 0;
    self.pingJingCount = 0;
    self.fangSongCount = 0;
    self.jiuJieCount = 0;
    self.yunZhuanCount = 0;
    self.xiangShiCount = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //bool类型初始化为no
    self.isTraining = NO;
    self.isLighting = NO;
    self.isMusicing = YES;//默认是开启音乐模式
    
    self.isXiangshi = NO;
    self.isJiujie = NO;
    self.isFangsong = NO;
    self.isYunzhuan = NO;
    self.isPingjing = NO;
    self.isBuxihuan = NO;
    self.isYiBan = NO;
    
    [self.musicBtn setImage:[UIImage imageNamed:@"yinyue1"] forState:UIControlStateNormal];
    
    [self reciveNotification];//接收通知改变水滴UI
    
    self.birdDownConstraint.constant = kScreen_Height/10;
    
    
    if (IS_IPHONE_5) {
        self.eyesConstraint.constant = -83;
    }
    if (IS_IPHONE_6) {
        self.eyesConstraint.constant = -101.5;
    }
    if (IS_IPHONE_6P) {
        self.eyesConstraint.constant = -114;
    }
    
}

#pragma mark - 接收通知和通知执行的方法 -
//接收通知调用改变水滴UI的方法
-(void)reciveNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fangsong) name:@"FANGSONGZHONG" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yunzhuan) name:@"YUNZHUANZHONG" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yiban) name:@"YIBAN" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jiujie) name:@"JIUJIEZHONG" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buxihuan) name:@"BUXIHUAN" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zaixiangshi) name:@"ZAIXIANGSHI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pingjing) name:@"PINGJINGZHONG" object:nil];
}

//一般
//一般状态的图片变化
-(void)yiban{
    //不喜欢状态累计出现的次数/总时长
//    self.buXihuanCount++;
    
    if (!self.isJiujie && !self.isYunzhuan  && !self.isFangsong && !self.isBuxihuan && !self.isYiBan){
        self.isYiBan = YES;
        //顶部红色水滴状视图显示,从无到有给一个动画
        [UIView animateWithDuration:1 animations:^{
            
            self.headThinkImg.image = [UIImage imageNamed:@"yunzhuanzhongbg"];
            self.headThinkImg.alpha = 1;
            self.headThinkImg.hidden = NO;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1 animations:^{
                self.headThinkImg.alpha = 0;
            } completion:^(BOOL finished) {
                self.isYiBan = NO;
            }];
            
        }];
    }
}

//最差
//不喜欢状态的图片变化
-(void)buxihuan{
    //不喜欢状态累计出现的次数/总时长
    self.buXihuanCount++;
    
    if (!self.isJiujie && !self.isYunzhuan  && !self.isFangsong && !self.isBuxihuan && !self.isYiBan){
        self.isBuxihuan = YES;
        //顶部红色水滴状视图显示,从无到有给一个动画
        [UIView animateWithDuration:1 animations:^{
            
            self.headThinkImg.image = [UIImage imageNamed:@"zaixiangshi"];
            self.headThinkImg.alpha = 1;
            self.headThinkImg.hidden = NO;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1 animations:^{
                self.headThinkImg.alpha = 0;
            } completion:^(BOOL finished) {
                self.isBuxihuan = NO;
            }];
            
        }];
    }
}

//一般差
//纠结状态的图片变化
-(void)jiujie{
    
    self.jiuJieCount++;
    
    if (!self.isJiujie && !self.isYunzhuan  && !self.isFangsong && !self.isBuxihuan && !self.isYiBan){
        self.isJiujie = YES;
        //顶部红色水滴状视图显示,从无到有给一个动画
        [UIView animateWithDuration:1 animations:^{
            
            self.headThinkImg.image = [UIImage imageNamed:@"jiujiezhongbg"];
            self.headThinkImg.alpha = 1;
            self.headThinkImg.hidden = NO;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1 animations:^{
                self.headThinkImg.alpha = 0;
            } completion:^(BOOL finished) {
                self.isJiujie = NO;
            }];
            
        }];
    }
}
//最好
//放松状态的图片变化
-(void)fangsong{
    
    self.fangSongCount++;
    
    //四种状态都没有达到
    if (!self.isJiujie && !self.isYunzhuan  && !self.isFangsong && !self.isBuxihuan && !self.isYiBan){
        //开启放松
        self.isFangsong = YES;
        //顶部红色水滴状视图显示,从无到有给一个动画
        [UIView animateWithDuration:1 animations:^{
            //从透明变成不透明
            self.headThinkImg.image = [UIImage imageNamed:@"fangsongzhongbg"];
            self.headThinkImg.alpha = 1;
            self.headThinkImg.hidden = NO;
            
        } completion:^(BOOL finished) {
            //上边动画完成后再执行变成透明动画达到呼吸灯效果
            [UIView animateWithDuration:1 animations:^{
                self.headThinkImg.alpha = 0;
            } completion:^(BOOL finished) {
                //放松= no
                self.isFangsong = NO;
            }];
            
        }];
    }
}
//一般好
//运转状态图片变化
-(void)yunzhuan{
    
    self.yunZhuanCount++;
    
    if (!self.isFangsong && !self.isJiujie  && !self.isYunzhuan && !self.isBuxihuan && !self.isYiBan){
        self.isYunzhuan = YES;
        //顶部红色水滴状视图显示,从无到有给一个动画
        [UIView animateWithDuration:1 animations:^{
            
            self.headThinkImg.image = [UIImage imageNamed:@"pingjingzhongbg"];
            self.headThinkImg.alpha = 1;
            self.headThinkImg.hidden = NO;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:1 animations:^{
                self.headThinkImg.alpha = 0;
            } completion:^(BOOL finished) {
                self.isYunzhuan = NO;
            }];
        }];
    }
}


//在想事眼睛动画
-(void)zaixiangshi{
    
    self.xiangShiCount++;
    
    [UIView animateWithDuration:2 animations:^{
        self.eyesCloseConstraint.constant = -19;
        [self.view layoutIfNeeded];
    }];
}
//平静眼睛动画
-(void)pingjing{
    
    self.pingJingCount++;
    
    [UIView animateWithDuration:2 animations:^{
        self.eyesCloseConstraint.constant = -1.3;
        [self.view layoutIfNeeded];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        
//        [self pingjing];    
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
    //初始化数据
    [[BYEEGDataModel sharedEEGData] initSleepDataModel];
    //发送通知创建一个文件夹存放脑波数据
    NSNotification *notification =[NSNotification notificationWithName:@"INITLOG" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
//向设备发送停止命令
-(void)postStopToBLE{
    //创建蓝牙传感器单例
    BYBluetoothManager *sensor = [BYBluetoothManager sharedManager];
    [sensor stopText];
    //删除数据
    [[BYEEGDataModel sharedEEGData] remveAllData];
    
}


#pragma mark - TAGPlayerDelegate -
//音乐类的代理
-(void)backTouchEvent:(NSNumber *)status{
    
}


#pragma mark - 有关数据储存和创建文件方法 -
//txt文件存储和数据库存储全在这里
- (void)writeLog {
    //明天检测是否会没有数据,没有数据就把判断删掉
//    if (logFile) {
        //脑波数据写入文件
//        [logFile writeData:output];
        NSArray *array = [self.totalTime componentsSeparatedByString:@":"];
        float a = self.fangSongCount / ([array[0] floatValue]*60 + [array[1] floatValue]);
        if (a > 30) {
            [self creatLog:@"0"];
        }
        if (a < 30 && a > 15) {
            [self creatLog:@"1"];
        }
        if (a < 15 && a >= 0) {
            [self creatLog:@"2"];
        }
//    }
}

//通过放松的程度来分别记录训练的状态,创建文件夹
-(void)creatLog:(NSString *)stateStr{
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@",self.startTextTime,self.stopTextTime,stateStr];
    //        //把有用的数据拼接写入文件中
    //        [str writeToFile:fileNameChart atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //获取主路径
    NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath=[NSString stringWithFormat:@"%@/user/%@",pathDocuments,[UserObj sharedUser].userID];
    //主路径拼接命名
    fileNameChart = [NSString stringWithFormat:@"%@/%@-%@.txt1", createPath,[[BYWorkTools sharedTools] getTimeNow],str];
    
    //检查是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileNameChart])
        [[NSFileManager defaultManager] createFileAtPath:fileNameChart contents:nil attributes:nil];
    
    logFileChart = [NSFileHandle fileHandleForWritingAtPath:fileNameChart];
    [logFileChart seekToEndOfFile];
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
