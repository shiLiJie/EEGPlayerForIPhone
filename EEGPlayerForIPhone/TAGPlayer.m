//
//  TAGPlayer.m
//  PCIM
//
//  Created by 凤凰八音 on 16/1/25.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "TAGPlayer.h"
#import "Tool.h"

static TAGPlayer *staticSelf = nil;

@interface TAGPlayer()

@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, strong) NSTimer *timer1;

@property (nonatomic, assign) float allTime;

@end

@implementation TAGPlayer

#pragma mark - init

- (void)setupLockScreenSongInfos
{
    // 设置锁屏歌曲专辑图片
    
    //获取沙盒图片
//    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/saveFore.png"];
//    UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
//    
//    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:savedImage];
//    
//    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = @{
//                                                              MPMediaItemPropertyPlaybackDuration:@(_musicPlayer.duration),
//                                                              MPMediaItemPropertyTitle:@"凤凰八音",
//                                                              MPMediaItemPropertyArtist:@"凤凰八音",
//                                                              MPMediaItemPropertyArtwork:artWork,
//                                                              MPNowPlayingInfoPropertyPlaybackRate:@(1.0f)
//                                                              };
}



- (void)setAudio2SupportBackgroundPlay
{
    UIDevice *device = [UIDevice currentDevice];
    
    if (![device respondsToSelector:@selector(isMultitaskingSupported)]) {
        NSLog(@"Unsupported device!");
        return;
    }
    
    if (!device.multitaskingSupported) {
        NSLog(@"Unsupported multiTasking!");
        return;
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *error;
    
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    [session setActive:YES error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
}

- (void)initAllObject:(NSURL *)playUrl{
    
//    UITapGestureRecognizer *singleOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickProgress:)];
//    [self.progressBG addGestureRecognizer:singleOne];
//    [singleOne setNumberOfTapsRequired:1];
//    
//    self.slider.userInteractionEnabled = YES;
//    UIPanGestureRecognizer *singleTwo = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(clickSlider:)];
//    [self.slider addGestureRecognizer:singleTwo];


    
    NSError* error=nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:playUrl error:&error];
    
    self.musicPlayer = player;
    
    self.musicPlayer.delegate = self;
    
    self.musicPlayer.enableRate = YES;
    
    [self.musicPlayer prepareToPlay];
    
    self.musicPlayer.volume = 0.0;
    
    [self.play_Button setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
    [self.play_Button setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateHighlighted];
    //设定定时器
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(show) userInfo:nil repeats:YES];
//    self.timer1=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(show1) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate date]];
    
    [self.timer fire]; // 触发
//    [self.timer1 fire];
    
    [self updatePlayOrPauseBtn:YES];
    
    // 3. 设置音频支持后台播放
    [self setAudio2SupportBackgroundPlay];
    // 4. 设置锁屏歌曲信息
    [self setupLockScreenSongInfos];
    
//    if ([[ViewController shareVC] MyappComeSleep]) {
//        return;
//    }
    
    [self playOrPause:nil];
}

+ (instancetype )shareTAGPlayer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticSelf = [[TAGPlayer alloc] init];
    });
    
    return staticSelf;
}

#pragma mark - 功能

- (void)updatePlayOrPauseBtn:(BOOL)isPlaying
{
    
}

- (void)stopSong{
    
    [self.musicPlayer stop];
    
    
    [self.play_Button setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
    [self.play_Button setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateHighlighted];
    
    // 暂停定时器`
    self.timer.fireDate = [NSDate distantFuture];
    
    [self updatePlayOrPauseBtn:NO];
    
    
    self.allTime = 0;
    
}

- (void )playOrPause:(id)sender {
    
    // 重置播放速率
    self.musicPlayer.rate = 1;
    
    if (self.musicPlayer.isPlaying) {
        // 正在播放，则暂停，并更新button
        [self.musicPlayer pause];
        
        
        [self.play_Button setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        [self.play_Button setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateHighlighted];
        
        // 暂停定时器
        self.timer.fireDate = [NSDate distantFuture];
        
        [self updatePlayOrPauseBtn:NO];
    } else {
        [self.musicPlayer play];
        [self.play_Button setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateNormal];
        [self.play_Button setImage:[UIImage imageNamed:@"kaishi"] forState:UIControlStateHighlighted];
        //设定定时器
        self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(show) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate date]];
        
        [self.timer fire]; // 触发
        
        
        [self updatePlayOrPauseBtn:YES];
    }
}

#pragma mark 定时器设定

//播放进度处理方法
-(void)show
{
    
    //当前时长
    NSString *currentTimeStr=[NSString stringWithFormat:@"%02d:%02d",(int)self.musicPlayer.currentTime/60,(int)self.musicPlayer.currentTime%60];
    //总共时长
    NSString *totalTime =[NSString stringWithFormat:@"%02d:%02d",(int)self.musicPlayer.duration/60,(int)self.musicPlayer.duration%60];
    self.currentTime.text = [NSString stringWithFormat:@"%@/%@",currentTimeStr,totalTime];
    
    self.totalTime = totalTime;
    
    if ([[Tool getyinxiao] boolValue]) {
        
    }else{
        if (self.musicPlayer.volume < 1) {
            self.musicPlayer.volume = 1;
        }
    }
    
//    //计算进度值
//    CGFloat progress=self.musicPlayer.currentTime/self.musicPlayer.duration;
//    
//    //计算滑块的最大x值
//    CGFloat sliderMaxX = self.progressBG.frame.size.width - self.slider.frame.size.width;
//    CGFloat a = self.slider.center.x;
//    a = sliderMaxX * progress;
//    
//    //改动这里可以调整进度条
//    self.slider.center = CGPointMake(a+10, 0);
//    
//    //设置滑块上的当时播放时间
////    [self.slider setTitle:[NSString stringWithString:currentTimeStr] forState:UIControlStateNormal];
//    
//    //设置进度条的宽度
//    CGFloat b = self.progressView.frame.size.width;
//    b = self.slider.center.x;
//    
//    //改动这里可以调整进度条
//    self.progressView.frame = CGRectMake(0, 0, b+7, 3);
    
    CGFloat value =self.musicPlayer.duration - self.musicPlayer.currentTime;
    
    CGFloat value1 =self.musicPlayer.currentTime/self.musicPlayer.duration;
    
    if (value <= 1) {
        
        [self stopSong];
        
        [self nextButtonClick];
        
    }else if (value1>0.99999) {
        
        [self stopSong];
        
        [self nextButtonClick];
    }
}

- (void)nextButtonClick {

    if (_deleagete) {
        [_deleagete performSelector:@selector(backTouchEvent:) withObject:[NSNumber numberWithInteger:TAGPlayerStatus_Next]];
    }
    
}

//点击进度条方法
-(void)clickProgress:(UITapGestureRecognizer *)sender
{
    //当前点击点
    CGPoint point = [sender locationInView:sender.view];
    //切换歌曲的当前播放时间
    self.musicPlayer.currentTime = (point.x/sender.view.frame.size.width)*self.musicPlayer.duration;
    //更新播放进度
    [self show];
}

//拖动滑块方法
 -(void)clickSlider:(UIPanGestureRecognizer *)sender {
     
     
         //1.获得挪动的距离
         CGPoint t=[sender translationInView:sender.view];
         //把挪动清零
         [sender setTranslation:CGPointZero inView:sender.view];
     
         
//         2.控制滑块和进度条的frame
         CGFloat a = self.slider.center.x;
         a += t.x;
     
     self.slider.center = CGPointMake(a, 0);

         CGFloat b = self.progressView.frame.size.width;
         b = a;
     
     self.progressView.frame = CGRectMake(0, 0, b+3, 5);
     
         
         //3.设置时间值
         CGFloat sliderMaxX=self.progressBG.frame.size.width-self.slider.frame.size.width;
         double progress=self.slider.center.x/sliderMaxX;
         //当前的时间值=音乐的时长*当前的进度值
         NSTimeInterval time=self.musicPlayer.duration*progress;
         //     [self.slider setTitle:[NSString stringWithFormat:@"%f",time] forState:UIControlStateNormal];
         
         //4.如果开始拖动，那么就停止定时器
         if (sender.state==UIGestureRecognizerStateBegan) {
             //停止定时器
//             [self removeCurrentTime1];

         }else if(sender.state==UIGestureRecognizerStateEnded)
         {
             //设置播放器播放的时间
             self.musicPlayer.currentTime=time;
             //开启定时器
//             [self show1];
         }
}
//移除一个定时器
 -(void)removeCurrentTime
 {
     [self.timer invalidate];

     //把定时器清空
     self.timer = nil;
 }

-(void)removeCurrentTime1
{
    [self.timer1 invalidate];
    
    //把定时器清空
    self.timer1 = nil;
}

#pragma mark 加载音乐
- (void)PlayerName:(NSURL *)playerUrl
{
    [self initAllObject:playerUrl];
}


#pragma mark - muscidelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self nextButtonClick];
}

//播放进度处理方法
-(void)show1
{
    
    //计算进度值
    CGFloat progress=self.musicPlayer.currentTime/self.musicPlayer.duration;
    
    //计算滑块的最大x值
    CGFloat sliderMaxX = self.progressBG.frame.size.width - self.slider.frame.size.width;
    CGFloat a = self.slider.center.x;
    a = sliderMaxX * progress;
    
    //改动这里可以调整进度条
    self.slider.center = CGPointMake(a+5.5, 2.5);
    
    //设置滑块上的当时播放时间
    //    [self.slider setTitle:[NSString stringWithString:currentTimeStr] forState:UIControlStateNormal];
    
    //设置进度条的宽度
    CGFloat b = self.progressView.frame.size.width;
    b = self.slider.center.x;
    
    //改动这里可以调整进度条
    self.progressView.frame = CGRectMake(0, 0, b+7, 5);
    
    CGFloat value =self.musicPlayer.duration - self.musicPlayer.currentTime;
    
    CGFloat value1 =self.musicPlayer.currentTime/self.musicPlayer.duration;
    
//    if (value <= 1) {
//        
//        [self stopSong];
//        
//        [self nextButtonClick];
//        
//    }else if (value1>0.99999) {
//        
//        [self stopSong];
//        
//        [self nextButtonClick];
//    }
}




@end
