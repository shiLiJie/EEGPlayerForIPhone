//
//  AppDelegate.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/6/27.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "AppDelegate.h"
#import "BYMainTabbarVC.h"
#import "BYLoginViewController.h"
#import "BYNomalRegistController.h"


@interface AppDelegate ()<UITabBarControllerDelegate,UITabBarDelegate>
@property (nonatomic, strong) BYMainTabbarVC *main;
@property (nonatomic, strong) BYLoginViewController *loginVc;
@property (nonatomic, assign) BOOL isPinggu;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initMainVcForRootVc) name:SUCCESSREGISTCHANGEROOT object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:kScreen_Frame];
    
    //读取沙盒路径下的用户缓存
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:kDocuments error:nil]];
    //判断存在用户文件
    if ([tempFileList containsObject:@"user.data"]){
        //存在,先进行登陆请求,还要再次判断用户是否登陆成功
        UserObj *user = [UserTool readTheUserModle];
        NSString *token = [NSString md5WithString];
        NSDictionary *dict = @{
                               @"token":token,
                               @"login_name":user.userID,
                               @"password":user.password
                               };
        [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_login" parameters:dict success:^(id obj) {
            int code;
            if ([[obj valueForKey:@"code"] isKindOfClass:[NSNumber class]]) {
                code = [[obj valueForKey:@"code"] intValue];
            }
            if (code == [SucceedCoder intValue]) {
                //进入程序
                [self initMainVcForRootVc];
                //从网络获取一下用户信息
                [self getUserInfo];
            }
            if (code == [FailureCoder intValue]) {
                //弹出登录
                [self initLoginVcForRootVc];
            }
            
        } fail:^(NSError *error) {
            //弹出登录
            [self initLoginVcForRootVc];
        }];
    }else{
        //不存在.弹出登录
        [self initLoginVcForRootVc];
    }

    self.isPinggu = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Pinggu) name:@"ISPINGGU" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noPinggu) name:@"NOPINGGU" object:nil];
    
    
    
    return YES;
}

#pragma mark - Private Methods
//从网络获取一下用户信息
-(void)getUserInfo{
    //从网络获取一下用户信息
    UserObj *user = [UserTool readTheUserModle];
    BYHttpRequest *re = [[BYHttpRequest alloc] init];
    [re userInfoRequestWithUid:user.ID];
}
-(void)saveUserInfo{
    //从网络获取一下用户信息
    UserObj *user = [UserTool readTheUserModle];
    BYHttpRequest *re = [[BYHttpRequest alloc] init];
    [re userInfoRequestWithUid:user.ID];
}

//创建主控制器vc
-(void)initMainVcForRootVc{
    self.main = [[BYMainTabbarVC alloc] init];
    self.main.delegate = self;
    self.window.rootViewController = self.main;
    [self.window makeKeyAndVisible];
    //从网络获取一下用户信息
    [self getUserInfo];
    
    [HttpRequest netWorkStatus];
}

//创建一个登陆控制器为跟控制器
-(void)initLoginVcForRootVc{
    //如果不是第一次启动的话,使用LoginViewController作为根视图
    self.loginVc = [BYLoginViewController loginControllerWithBlock:^(BOOL result, NSString *message) {
        if (result) {
            self.main = [[BYMainTabbarVC alloc] init];
            self.main.delegate = self;
            self.window.rootViewController = self.main;
            [self.window makeKeyAndVisible];
            //从网络获取一下用户信息
            [self getUserInfo];
        }else{
            [MBProgressHUD showError:message];
        }
    }];
    UINavigationController *logNav = [[UINavigationController alloc] initWithRootViewController:self.loginVc];
    // navibar设置透明
    logNav.navigationBar.translucent = YES;
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, kScreen_Width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [logNav.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    logNav.navigationBar.clipsToBounds = YES;
    self.window.rootViewController = logNav;
    [self.window makeKeyAndVisible];
    
    [HttpRequest netWorkStatus];
}

//监听正在评估
-(void)Pinggu{
    self.isPinggu = YES;
}
//监听停止评估
-(void)noPinggu{
    self.isPinggu = NO;
}
//控制器0
-(void)goToConnectBlue{
    
    self.main.selectedIndex = 0;
}
//控制器1
-(void)goSleepChangeOneVc{
    
    self.main.selectedIndex = 1;
}
//控制器3
-(void)goRelaxMusic{

    self.main.selectedIndex = 3;
}
//控制器4
-(void)goToPersonal{
    
    self.main.selectedIndex = 4;
}

//点击tabbar切换控制器代理方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (self.isPinggu){
        //评估中弹出提示框结束评估
        NSNotification *notification = [NSNotification notificationWithName:@"STOPPINGGU" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        return NO;
    }else{
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
