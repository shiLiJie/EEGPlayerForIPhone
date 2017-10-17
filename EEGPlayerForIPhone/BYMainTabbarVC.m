//
//  BYMainTabbarVC.m
//  UITabBarController
//
//  Created by 凤凰八音 on 16/4/27.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "BYMainTabbarVC.h"
#import "BYTextViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BYEvaluateViewController.h"
#import "BYSleepHandViewController.h"
#import "BYMyController.h"
#import "AppDelegate.h"
#import "BYConnectBlue.h"
#import "AFNetworking.h"

@interface BYMainTabbarVC ()
@property (nonatomic, strong) UIButton *button;

@end

@implementation BYMainTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置底部连接设备大按钮
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_CenterX-kScreen_Width/5/2, -26, kScreen_Width/5, kScreen_Width/5)];
    [self.button setImage:[UIImage imageNamed:@"weilianjieicon"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(connectBlueButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //五个控制器,大按钮处占位一个空的
    BYTextViewController *aController = [[BYTextViewController alloc] init];
    BYEvaluateViewController *bController = [[BYEvaluateViewController alloc] init];
    UIViewController *cController = [[UIViewController alloc] init];
    BYSleepHandViewController *dController = [[BYSleepHandViewController alloc] init];
    BYMyController *eController = [[BYMyController alloc] init];
    

    NSMutableArray *mArray = [NSMutableArray array];
    //标签控制器集合
    NSArray *array = @[aController, bController, cController,dController,eController];
    //标签控制器名称
    NSArray *textArray = @[@"主页", @"评估实训", @"",@"睡眠助手",@"我的"];
    
    //图片是镂空的要这样写
    //NSArray *imageArray = @[[UIImage imageNamed:@"jianceicon"], [UIImage imageNamed:@"baogaoicon"], [UIImage imageNamed:@"shezhiicon"]];
    //NSArray *selectedArray = @[[UIImage imageNamed:@"xuanzhongjianceicon"], [UIImage imageNamed:@"xuanzhongbaogaoicon"], [UIImage imageNamed:@"shezhixuanzhongicon"]];
    
    //如果你的图片不是镂空的 要这样写
    NSArray *originalArray=@[[[UIImage imageNamed:@"zhuyeicon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                                 [[UIImage imageNamed:@"pinggushixunicon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                                 [[UIImage imageNamed:@"Snip20160921_6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                             [[UIImage imageNamed:@"shuimianzhuicon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                             [[UIImage imageNamed:@"wodeicon1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    NSArray *originalArray1=@[[[UIImage imageNamed:@"zhuyeicon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                             [[UIImage imageNamed:@"pinggushixunicon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                             [[UIImage imageNamed:@"Snip20160921_6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                              [[UIImage imageNamed:@"shuimianzhushouicon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
                              [[UIImage imageNamed:@"wodeicon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //标签控制器 嵌套 导航控制器
    for (int i = 0; i < array.count; i++) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:array[i]];
        
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:textArray[i] image:originalArray[i] selectedImage:originalArray1[i]];
        
        navigationController.tabBarItem = tabBarItem;
        //设置背景色
        navigationController.navigationBar.barTintColor = RGB(0, 0, 0);
        
        //设置字体色
//        [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
//                                                       NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
//                                                       }];
        navigationController.navigationBar.tintColor =[UIColor whiteColor];
        
        [mArray addObject:navigationController];
        
    }
    
    
    
    
    self.viewControllers = mArray;
    
    // 选中颜色
//    [self.tabBar setTintColor:[UIColor whiteColor]];
    // 默认
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor hexColorWithString:@"cccccc"];
    
    // 选中
    NSMutableDictionary *attrSelected = [NSMutableDictionary dictionary];
//    attrSelected[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrSelected[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:attrSelected forState:UIControlStateSelected];
    
    // 背景颜色
    self.tabBar.barTintColor = RGB(0, 0, 0);
    // 设置tabbar 不透明
    self.tabBar.translucent = NO;
    
    [self.tabBar addSubview:self.button];

    //tabbar去掉顶部线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    //通知过里啊,如果连接成功,更改大按钮的图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnImg) name:@"CONNECTBLUECHANGEBTNIMG" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBtnImg1) name:@"DISCONNECTBLUECHANGEBTNIMG" object:nil];
    
    
}
//通知方法,点击底部连接按钮后通知其他控制器,弹出popview搜索蓝牙
-(void)connectBlueButtonClick{
    //单例记录是否连接,如果已经连接直接退出不进行搜索
    BYConnectBlue *con = [BYConnectBlue sharedConnect];
    if (con.isConnect == YES) {
        return;
    }
    //appdelegata方法切换tabbar控制器的当前控制器
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate goToConnectBlue];
    
    NSNotification *notification = [NSNotification notificationWithName:@"PUSHCONNECTBLUEPOP" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

//连接成功后收到通知,改变大按钮的背景色
-(void)changeBtnImg{
    [self.button setImage:[UIImage imageNamed:@"yilianjieicon"] forState:UIControlStateNormal];
}
//连接失败.红色
-(void)changeBtnImg1{
    [self.button setImage:[UIImage imageNamed:@"weilianjieicon"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
