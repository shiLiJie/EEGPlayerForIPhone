//
//  BYSleepHandViewController.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/6.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYSleepHandViewController.h"
#import "TAGPlayer.h"

@interface BYSleepHandViewController ()<PlayEvent>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourBtnSpace;//下载按钮距右距离约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourBtnSpacetwo;//第二个按钮和第三个按钮的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourBtnSpacethr;//第三个按钮和第四个按钮的距离

@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;//下载按钮
@property (weak, nonatomic) IBOutlet UIButton *favouriteBtn;//喜欢按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *musicListBtn;//音乐列表按钮

@property (weak, nonatomic) IBOutlet UIImageView *imageView;//背景image
@property (weak, nonatomic) IBOutlet UIButton *playOrStopBtn;//开始停止播放按钮
@property (weak, nonatomic) IBOutlet UIButton *nextMusicBtn;//下一首按钮
@property (weak, nonatomic) IBOutlet UIButton *upMusicBtn;//上一首按钮
@property (weak, nonatomic) IBOutlet UILabel *musicNameLab;

@property (nonatomic, strong) NSTimer *bgTime;//背景图片动画定时器
@property (strong, nonatomic) TAGPlayer *player;//播放器类
@property (nonatomic, assign) BOOL isPlaying;//是否正在播放
@property (nonatomic, strong) NSString *musicName;//歌曲名

@end

@implementation BYSleepHandViewController
//下载音乐
- (IBAction)downLoadMusic:(UIButton *)sender {
}

//喜欢音乐
- (IBAction)favouriteMusic:(UIButton *)sender {
}

//分享音乐
- (IBAction)shareMusic:(UIButton *)sender {
}

//打开音乐列表
- (IBAction)openMusicList:(UIButton *)sender {
}

//开始/暂停播放
- (IBAction)starOrStopMusic:(UIButton *)sender {
    if (!self.isPlaying) {
        if (self.musicName == nil) {
            //播放指定路径按钮
            [self playMusicWithPath];
            self.isPlaying = YES;
            [self.playOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        }else{
            [self.player.musicPlayer play];
            self.isPlaying = YES;
            [self.playOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
        }
    }else{
        [self.player.musicPlayer pause];
        self.isPlaying = NO;
        [self.playOrStopBtn setImage:[UIImage imageNamed:@"bofangicon"] forState:UIControlStateNormal];
    }
}

//下一曲
- (IBAction)nextOneMusic:(UIButton *)sender {
    //播放指定路径按钮
    [self playMusicWithPath];
    self.isPlaying = YES;
    [self.playOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
}

//上一曲
- (IBAction)upOneMusic:(UIButton *)sender {
    //播放指定路径按钮
    [self playMusicWithPath];
    self.isPlaying = YES;
    [self.playOrStopBtn setImage:[UIImage imageNamed:@"zantingicon"] forState:UIControlStateNormal];
}

//只播放第一首播放训练音乐
-(void)playMusicWithPath{
    
    
    NSString *music = [[[NSBundle mainBundle] pathForResource:@"凤凰八音乐器" ofType:@"mp3"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *musicUrl = [NSURL URLWithString:music];
    //播放路径音乐
    [self.player PlayerName:musicUrl];
    self.musicNameLab.text = @"凤凰八音";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    [self setUpUI];
    //默认没有开启播放
    self.isPlaying = NO;
}

//设置UI
-(void)setUpUI{
    // navibar标题
    self.title = @"专属音乐";
    // navibar字体大小,颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // navibar设置透明
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, kScreen_Width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.clipsToBounds = YES;
    
    //两个按钮的父类view
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //返回主页
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"fenlei"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(musicCatigray) forControlEvents:UIControlEventTouchUpInside];
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = leftCunstomButtonView;
    
    //设置约束0.088
    self.fourBtnSpace.constant = 0.08 * kScreen_Width;
    self.fourBtnSpacetwo.constant = self.fourBtnSpace.constant;
    self.fourBtnSpacethr.constant = self.fourBtnSpace.constant;
    
    //适配,设置四个按钮的大小
    CGRect frame = self.downLoadBtn.frame;
    frame.size.width = kScreen_Width * 0.072;
    self.downLoadBtn.frame = frame;
}

//右上角音乐分类按钮
-(void)musicCatigray{
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    //初始化定时器
    self.bgTime = [NSTimer scheduledTimerWithTimeInterval:11
                                                   target:self
                                                 selector:@selector(startAnimation:)
                                                 userInfo:nil
                                                  repeats:YES];
    [self.bgTime fire];//开启动画
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self.bgTime invalidate];//取消定时器
}


//背景图片动画方法
-(void)startAnimation:(CGFloat)duration{
    
    self.imageView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.transform = CGAffineTransformMakeScale(1.1,1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:5  animations:^{
            self.imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }];
}

#pragma mark - 播放器类代理 - 
-(void)backTouchEvent:(NSNumber *)status{
    [self playMusicWithPath];
}

#pragma mark - 懒加载 -
//播放器类对象
-(TAGPlayer *)player{
    if (!_player) {
        _player = [TAGPlayer shareTAGPlayer];
        _player.deleagete = self;
    }
    return _player;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
