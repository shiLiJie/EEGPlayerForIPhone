//
//  BYTextViewController.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/6/30.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYTextViewController.h"
#import "popView.h"
#import "ParserObject.h"
#import "Masonry.h"
#import "MBProgressHUD+YCL.h"
#import "BYLoginViewController.h"
#import "ArticleTableViewCell.h"
#import "BYSleepViewController.h"
#import "BYConnectBlue.h"
#import "BYSleepEvalVc.h"
#import "BYEvaReportVc.h"
#import "BYWorkTools.h"
#import "BYTrainReportVc.h"
#import "DataBaseHelper.h"
#import "EEGDataModel.h"


@interface BYTextViewController ()<BYSleepViewDelegate>
{
    NSFileHandle * logFile;
    NSString *fileName;
    
    NSFileHandle * logFileData;
    NSString *dataFileName;
    
    NSURL* recordUrl;
    NSURL* audioFileSavePath;
    
    NSMutableDictionary *getDic ;
    NSMutableDictionary *getSamll;
    NSMutableArray *bqlArr;
    
    BOOL lianjieOK;//连接ok
    BOOL kaishiReading;//是否开始
    BOOL oldReadingStop;//老数据是否停止
}


@property (nonatomic, retain) BYWorkTools *workTools;//工具类对象
@property (nonatomic, strong) UserObj *userobj;//用户单例

@property (nonatomic, strong) popView *popView;//搜索按钮的弹窗pop
@property (nonatomic, assign) BOOL istongji;//是否统计
@property (nonatomic, assign) BOOL isMarryMusic;//是否匹配音乐
@property (nonatomic, strong) NSMutableArray *nozsy;//存放噪音的数组
@property (weak, nonatomic) IBOutlet UITableView *articleTable;//文章tableview
@property (weak, nonatomic) IBOutlet UIButton *sleepEvaluate;//睡眠评估按钮
@property (weak, nonatomic) IBOutlet UIButton *wantSleep;//去睡觉

@property (nonatomic, strong) BYEEGDataModel *EEGDataModel;//脑波数据模型
@property (nonatomic, assign) int xiangshi;
@property (nonatomic, assign) int pingjing;

@property (nonatomic, strong) NSMutableArray *ThetaArr;//存放每段脑波数据的数组
@property (nonatomic, strong) NSMutableArray *DeltaArr;
@property (nonatomic, strong) NSMutableArray *HighaArr;
@property (nonatomic, strong) NSMutableArray *LowaArr;
@property (nonatomic, strong) NSMutableArray *HighbArr;
@property (nonatomic, strong) NSMutableArray *LowbArr;
@property (nonatomic, strong) NSMutableArray *HighgArr;
@property (nonatomic, strong) NSMutableArray *LowgArr;

@property (nonatomic, strong) NSMutableArray *avgThetaArr;//存放每段脑波平均值数据的数组
@property (nonatomic, strong) NSMutableArray *avgDeltaArr;
@property (nonatomic, strong) NSMutableArray *avgHighaArr;
@property (nonatomic, strong) NSMutableArray *avgLowaArr;
@property (nonatomic, strong) NSMutableArray *avgHighbArr;
@property (nonatomic, strong) NSMutableArray *avgLowbArr;
@property (nonatomic, strong) NSMutableArray *avgHighgArr;
@property (nonatomic, strong) NSMutableArray *avgLowgArr;

@property (nonatomic, copy) NSString *marryString;//匹配音乐的脑波数据拼接成的字符串,测试用
@property (nonatomic, strong) EEGDataModel *eegDataModel;//20秒脑波数据模型

@end

@implementation BYTextViewController
//@synthesize sensor;
@synthesize peripheralViewControllerArray;
NSInteger numiii = 0;
NSInteger tongji = 1;
NSInteger countNum = 1;

//测试用
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    BYEvaReportVc *vc = [[BYEvaReportVc alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
//}


#pragma mark ----- 主页按钮方法 -----
//睡眠评估按钮方法
- (IBAction)sleepEvaluate:(UIButton *)sender {
    //判断连接状态
    if ([BYBluetoothManager sharedManager].isConnect == YES) {
//        appdelegata方法切换tabbar控制器的当前控制器
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate goSleepChangeOneVc];
    }else{
        //跳转到未连接答题模块 1-3
        self.hidesBottomBarWhenPushed=YES;
        BYSleepEvalVc *se = [[BYSleepEvalVc alloc] init];
        [self.navigationController pushViewController:se animated:YES];
        self.hidesBottomBarWhenPushed=NO;
    }

}
//去睡觉按钮方法
- (IBAction)wantToSleep:(UIButton *)sender {
    //如果在push跳转时需要隐藏tabBar，设置self.hidesBottomBarWhenPushed=YES;
    self.hidesBottomBarWhenPushed=YES;
    //推出开始匹配控制器
    BYSleepViewController *vc = [[BYSleepViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.delegate = self;
    //并在push后设置self.hidesBottomBarWhenPushed=NO;
    //这样back回来的时候，tabBar会恢复正常显示。
    self.hidesBottomBarWhenPushed=NO;
}

//初始化数据
-(void)initData{
    self.isMarryMusic = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据库
    DataBaseHelper *dataBase = [DataBaseHelper sharedInstance];
    [dataBase DatabaseWithDBName:@"slj.db"];
    NSDictionary *keyDict = @{@"id":@0,@"data":@0};
    [dataBase createTable:@"textone" WithKey:keyDict];
    NSDictionary *keyDict1 = @{@"id":@"2",@"data":@"5"};
    [dataBase insertInTable:@"textone" WithKey:keyDict1];
    NSDictionary *chadic = @{@"id":@0,@"data":@0};
    NSMutableArray *arr = [dataBase selectInTable:@"textone" WithKey:chadic];
    NSDictionary *chadic1 = @{@"id":@2};
    NSMutableArray *arr1 = [dataBase selectInTable:@"textone" WithKey:chadic whereCondition:chadic1];
//    NSLog(@"%@",arr1);
    
    
    
    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [self initData];
    //初始化噪音数组
    self.nozsy = [[NSMutableArray alloc] init];
    //单独设置navbar标题
    self.navigationItem.title = @"主页";
    //隐藏navbar
    [self.navigationController setNavigationBarHidden:YES];
    //标题颜色字号
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化蓝牙工具类设代理
    self.sensor = [BYBluetoothManager sharedManager];
    [self.sensor setup];
    self.sensor.delegate = self;
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
    self.articleTable.delegate = self;
    self.articleTable.dataSource = self;

    [self reviceNOtifi];//接收通知
    
    BYConnectBlue *connect = [BYConnectBlue sharedConnect];
    connect.EEGBanben = @"";
    connect.isConnect = NO;
    
    //工具类切换用户或者弹窗
    self.workTools = [BYWorkTools sharedTools];
    self.userobj = [UserObj sharedUser];
}

#pragma mark ----- 接收通知 -----
//接收通知的都在里面
-(void)reviceNOtifi{
    //监听popview点击indexpath的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chosePri:) name:@"NOTIFICATIONLIANJIE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDevice) name:@"PUSHCONNECTBLUEPOP" object:nil];
    //创建脑波数据文件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initDataLog) name:@"INITLOG" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(writeDataLog) name:@"WRITELOG" object:nil];
}

#pragma mark ----- 接收到通知后执行的方法 -----

- (void)writeDataLog {
    if (logFileData) {
        //脑波数据写入文件
        [logFileData writeData:output];
        
        //发送20次脑波数据到后台
        self.eegDataModel.index++;
        NSString *jsonstring = [self getJsonDataWithEEGModel];
        BYHttpRequest *request = [[BYHttpRequest alloc] init];
        [request uploadTweSecEegDataWithUid:[UserTool readTheUserModle].ID EegData:jsonstring];
        self.eegDataModel.index = 0;
        
        //给脑波文件命名,最后一个元素就是脑波文件名
        NSArray *filename = [fileName componentsSeparatedByString:@"/"];
        //传入uid和脑波txt数据流和后台的txt文件名,直接发送给后台
        [request uploadEegFileWithUid:[UserTool readTheUserModle].ID
                              EEGData:[self.sensor.output mutableCopy]
                             fileName:[NSString stringWithFormat:@"%@",filename.lastObject]];
    }
}

//写文件
- (void)initDataLog {
    output = nil;
    //获取主路径
    NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath=[NSString stringWithFormat:@"%@/user/%@",pathDocuments,[UserObj sharedUser].userID];
    
    //主路径拼接命名
    dataFileName = [NSString stringWithFormat:@"%@/log%@.txt", createPath,[[BYWorkTools sharedTools] getTimeNow]];
    
    //检查是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:dataFileName])
        [[NSFileManager defaultManager] createFileAtPath:dataFileName contents:nil attributes:nil];
    
    logFileData = [NSFileHandle fileHandleForWritingAtPath:dataFileName];
    [logFileData seekToEndOfFile];
}

//接收到pop穿过来通知后执行的方法, 弹出alterview
-(void)chosePri:(NSNotification *)indexpath{
    NSString *title = NSLocalizedString(ksureconnect, nil);
    NSString *OkButtonTitle = NSLocalizedString(ksure, nil);
    NSString *CancelButtonTitle = NSLocalizedString(kcancel, nil);
    
    //创建提示框头
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //创建提示框底部内容方法 ok
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OkButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self.sensor connect:self.sensor.activePeripheral];
        
        //确定连接, pop 移除
        [_popView removeFromSuperview];
        
    }];
    
    //取消方法
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        return;
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    //推出alterview视图
    [self presentViewController:alertController animated:YES completion:nil];
}

//搜索设备方法
-(void)searchDevice{
    
    [_popView removeFromSuperview];
    //弹出自定义pop
    _popView = [[popView alloc] initWithFrame:kScreen_Frame];
    _popView.degegate = self;
    [self.view addSubview:_popView];
    
    //再次点击可以断开上次的蓝牙
    if ([self.sensor activePeripheral]) {
        if (self.sensor.activePeripheral.state == CBPeripheralStateConnected) {
            [self.sensor.manager cancelPeripheralConnection:self.sensor.activePeripheral];
            self.sensor.activePeripheral = nil;
            self.sensor.isConnect = NO;
            NSNotification *notification = [NSNotification notificationWithName:@"DISCONNECTBLUECHANGEBTNIMG" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            NSLog(@"断开了");
        }
    }
    if ([self.sensor peripherals]) {
        self.sensor.peripherals = nil;
        [peripheralViewControllerArray removeAllObjects];
    }
    //蓝牙工具类代理
    self.sensor.delegate = self;
    //搜索一次持续五秒
    [self.sensor findBLKAppPeripherals:5];
    
    __weak BYTextViewController  *weakSelf = self;
    _popView.perI = ^(CBPeripheral *perI)
    {
        [weakSelf connetBlut:perI];
        
    };
}

#pragma mark ----- bluedelegate ------
//连接成功显示版本号, 显示隐藏视图
-(void)okConnectChangeView{
    //确认连接后移除popview
    [_popView removeFromSuperview];
}
//搜索周边设备
- (void) peripheralFound:(CBPeripheral *)peripheral{
    //判断蓝牙名称是否包含EEG
    if ([peripheral.name containsString:@"EEG"]) {
        //存放设备的数组如果为0
        if (peripheralViewControllerArray.count == 0) {
            //直接加进去EEG
            [peripheralViewControllerArray addObject:peripheral];
        }else{//不为0的话就要判断一下是否已经包含了相同的元素
            if ([peripheralViewControllerArray containsObject:peripheral]) {
                //数组中已经有了相同的设备
            }else{//不包含就直接加入
                [peripheralViewControllerArray addObject:peripheral];
            }
        }
    }
    
    [_popView setPeripheralViewControllerArray:peripheralViewControllerArray];
}

//三个代理方法不需要没有功能数据需求
-(void)getDeviceVersion:(NSString *)version{}
-(void)getOriginalValue:(int)Original{}
-(void)reloadOriginalView{}

/**
 *  接收解析周边广播
 *
 *  @param UUID UUID //不用传值
 *  @param data 广播数据
 */
- (void) serialGATTCharValueUpdated:(NSString *)UUID
                           getDelta:(int)delta
                           LowAlpha:(int)LowAlpha
                            LowBeta:(int)LowBeta
                           LowGamma:(int)LowGamma
                        MiddleGamma:(int)MiddleGamma
                              Theta:(int)Theta
                          highAlpha:(int)highAlpha
                           highBeta:(int)highBeta
                          Attention:(int)Attention
                         Meditation:(int)Meditation
                             singel:(int)singel
                           Original:(int)Original
                            version:(NSString *)version{
    //数据模型
    BYEEGDataModel *model = [BYEEGDataModel sharedEEGData];
    int delate = 0;
    int sita = 0;
    int Lowbeta = 0;
    int HighBeta = 0;
    int Lowa;
    int Higha;
    int Lowgama;
    int Highgama;
    
    //记录当前delta值
    delate = delta;
    //给训练用的最大值
    model.dertaMax = [model maxValue:delta valueArr:model.dertaArr];
    if (self.isMarryMusic == YES) {
        NSNumber *num = [NSNumber numberWithInt:delta];
        [self.DeltaArr addObject:num];
    }
    
    Lowa = LowAlpha;
    model.lowaMax = [model maxValue:LowAlpha valueArr:model.lowaArr];
    if (self.isMarryMusic == YES) {
        NSNumber *num = [NSNumber numberWithInt:delta];
        [self.LowaArr addObject:num];
    }
    
    Lowbeta = LowBeta;
    model.lowbMax = [model maxValue:LowBeta valueArr:model.lowbArr];
    if (self.isMarryMusic == YES) {
        NSNumber *num = [NSNumber numberWithInt:LowBeta];
        [self.LowbArr addObject:num];
    }
    
    Lowgama = LowGamma;
    model.lowgMax = [model maxValue:LowGamma valueArr:model.lowgArr];
    if (self.isMarryMusic == YES) {
        NSNumber *num = [NSNumber numberWithInt:LowGamma];
        [self.LowgArr addObject:num];
    }
    
    Highgama = MiddleGamma;
    model.highgMax = [model maxValue:MiddleGamma valueArr:model.highgArr];
    if (self.isMarryMusic == YES) {
        NSNumber *num = [NSNumber numberWithInt:MiddleGamma];
        [self.HighgArr addObject:num];
    }
    
    sita = Theta;
    model.theatMax = [model maxValue:Theta valueArr:model.theatArr];
    if (self.isMarryMusic == YES) {
        NSNumber *num = [NSNumber numberWithInt:Theta];
        [self.ThetaArr addObject:num];
    }
    
    Higha = highAlpha;
    model.highaMax = [model maxValue:highAlpha valueArr:model.highaArr];
    if (self.isMarryMusic == YES) {
        NSNumber *num = [NSNumber numberWithInt:highAlpha];
        [self.HighaArr addObject:num];
    }
    
    HighBeta = highBeta;
    model.highbMax = [model maxValue:highBeta valueArr:model.highbArr];
    if (self.isMarryMusic == YES) {
        NSNumber *num = [NSNumber numberWithInt:highBeta];
        [self.HighbArr addObject:num];
    }
    
    //存放的数组如果有了20个数据
    if (self.eegDataModel.singel.count == 20) {
        //数据编号索引+1
        self.eegDataModel.index++;
        //把数据转换成json格式的字符串
        NSString *jsonstring = [self getJsonDataWithEEGModel];
        BYHttpRequest *request = [[BYHttpRequest alloc] init];
        //传入uid和json格式的脑波数据上传给服务器
        [request uploadTweSecEegDataWithUid:[UserTool readTheUserModle].ID EegData:jsonstring];
    }
    
    self.xiangshi = Attention;
    self.pingjing = Meditation;
    
    [self.nozsy addObject:[NSNumber numberWithInt:singel]];
    if (singel != 0){
        //有噪音,排除错误数据
        [[BYEEGDataModel sharedEEGData] deletaWrongData];
    }else{
        if (self.xiangshi>self.pingjing) {
            //发送通知,改变训练界面的状态UI
            NSNotification *notification = [NSNotification notificationWithName:@"ZAIXIANGSHI" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        if (self.xiangshi<self.pingjing) {
            //发送通知,改变训练界面的状态UI
            NSNotification *notification = [NSNotification notificationWithName:@"PINGJINGZHONG" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
    //有噪音弹出提示框
    [self haveNozsy];
   
    if (model.dertaMax != nil && model.theatMax != nil && model.lowbMax != nil && model.highbMax != nil){
        //最高级
        if ((Lowgama>[model.lowgMax intValue] && sita >[model.theatMax intValue]) || (Highgama >[model.highgMax intValue] && sita >[model.theatMax intValue])) {
            //发送倒数第一的通知
            
            NSLog(@"特别差");
            //发送通知,改变训练界面的状态UI
            NSNotification *notification = [NSNotification notificationWithName:@"BUXIHUAN" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }else if((Lowbeta >[model.lowbMax intValue] && sita >[model.theatMax intValue]) || (HighBeta >[model.highbMax intValue] && sita >[model.theatMax intValue])){
            //倒数第二
            NSLog(@"一般差");
            //发送通知,改变训练界面的状态UI
            NSNotification *notification = [NSNotification notificationWithName:@"JIUJIEZHONG" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else if (delate >[model.dertaMax intValue] && sita >[model.theatMax intValue]){
            //倒数第三
            NSLog(@"差");
            //发送通知,改变训练界面的状态UI
            NSNotification *notification = [NSNotification notificationWithName:@"YIBAN" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }else if((Lowa >[model.lowaMax intValue] && Lowgama >[model.lowgMax intValue]) || (Higha >[model.highaMax intValue] && Highgama >[model.highgMax intValue]) || (Higha >[model.highaMax intValue] && Lowgama >[model.lowgMax intValue]) || (Lowa >[model.lowaMax intValue] && Highgama >[model.highgMax intValue])){
            //倒数第二
            NSLog(@"好点了");
            //发送通知,改变训练界面的状态UI
            NSNotification *notification = [NSNotification notificationWithName:@"YUNZHUANZHONG" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }else if (Lowa >[model.lowaMax intValue] || Higha >[model.highaMax intValue]){
            //等级最低
            NSLog(@"不错哦,看好你");
            //发送通知,改变训练界面的状态UI
            NSNotification *notification = [NSNotification notificationWithName:@"FANGSONGZHONG" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }

}
//持续五秒有噪音弹出提示框方法
-(void)haveNozsy{
    //连续三秒有噪音提示设备是否佩戴好
    NSNumber *sum = [self.nozsy valueForKeyPath:@"@sum.floatValue"];//存放噪音数组求出总和
    if (self.nozsy.count == 1 && [sum integerValue] == 0) {//如果有一个元素而且是0;移除
        [self.nozsy removeAllObjects];
    }else if (self.nozsy.count == 2 && [self.nozsy[1] integerValue] == 0){//如果有两个元素,最后一个是0;移除
        [self.nozsy removeAllObjects];
    }else if (self.nozsy.count == 3 && [self.nozsy[2] integerValue] == 0){//同上,最后一个元素是0;就移除
        [self.nozsy removeAllObjects];
    }else if (self.nozsy.count == 4 && [self.nozsy[3] integerValue] == 0){//同上,最后一个元素是0;就移除
        [self.nozsy removeAllObjects];
    }if (self.nozsy.count == 5 && [self.nozsy[4] integerValue] != 0) {//当有5个元素,且最后一个不为0;MBP遮罩提示检查头戴;并清空数组
        [MBProgressHUD showError:@"请检查头戴是否佩戴好"];
        [self.nozsy removeAllObjects];
    }else if(self.nozsy.count == 5 && [self.nozsy[4] integerValue] == 0){//同上,最后一个元素是0;就移除
        [self.nozsy removeAllObjects];
    }
}


/**
 *  连接
 */
- (void) setConnect{
    
    [self.sensor ReadFirmwareVersion];
    [self.sensor ConfigurationTime];
    [self.sensor read:self.sensor.activePeripheral];
    self.sensor.isConnect = YES;
    //通知过里啊,如果连接成功,更改大按钮的图片
    NSNotification *notification = [NSNotification notificationWithName:@"CONNECTBLUECHANGEBTNIMG" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

/**
 *  断开连接
 */
- (void) setDisconnect{
    
    self.sensor.isConnect = NO;
    NSNotification *notification = [NSNotification notificationWithName:@"DISCONNECTBLUECHANGEBTNIMG" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSLog(@"断开了");
}


//后续工作,匹配音乐开始后固定时间发送通知或者用代理也行,给一个bool类型的标记,表示已经开始匹配音乐,然后然数据进入到存放数据的数组中,
//然后再到下一个定点的时候,再来通知或代理,调用下面的一个帮助方法,清除这一段的数据并且保存起来,重复几次后,直到匹配结束后,再发送通知
//或者代理,把平均值数组最大和最小值取出来进行振幅比较,判断那个阶段敏感
#pragma mark - 帮助方法 -

//创建20秒脑波数据的json字符串
-(NSString *)getJsonDataWithEEGModel{
//    //数组包裹数据模型
//    NSArray *eegData = @[self.eegDataModel];
//    //用mjextention进行模型转字典,字典key值就是属性明明
//    NSArray *dictArray = [EEGDataModel mj_keyValuesArrayWithObjectArray:eegData];
//    NSError *error;
//    //系统方法把数组转换成json字符串
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictArray
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    [self.eegDataModel removeAllEEGData];
    NSString *jsonString;
    return jsonString;
}

//写文件
- (void)initLog {
    
    //获取主路径
    NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //主路径拼接命名
    fileName = [NSString stringWithFormat:@"%@/musicData/log%@.txt", pathDocuments,[[BYWorkTools sharedTools] getTimeNow]];
    //检查是否存在
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    //创建指定路径和文件名的文件
    logFile = [NSFileHandle fileHandleForWritingAtPath:fileName];
    [logFile seekToEndOfFile];
}

-(void)musicAvgData{

    //算出这一段脑波数据的平均值
    NSNumber *avgT1 = [self.ThetaArr valueForKeyPath:@"@avg.floatValue"];
    NSNumber *avgD1 = [self.DeltaArr valueForKeyPath:@"@avg.floatValue"];
    NSNumber *avgHA1 = [self.HighaArr valueForKeyPath:@"@avg.floatValue"];
    NSNumber *avgLA1 = [self.LowaArr valueForKeyPath:@"@avg.floatValue"];
    NSNumber *avgHB1 = [self.HighbArr valueForKeyPath:@"@avg.floatValue"];
    NSNumber *avgLB1 = [self.LowbArr valueForKeyPath:@"@avg.floatValue"];
    NSNumber *avgHG1 = [self.HighgArr valueForKeyPath:@"@avg.floatValue"];
    NSNumber *avgLG1 = [self.LowgArr valueForKeyPath:@"@avg.floatValue"];
    //把平均值加入到存放平均值用来比较的数组里
    NSString *avgT = [NSString stringWithFormat:@"%.1f",[avgT1 floatValue]];
    NSString *avgD = [NSString stringWithFormat:@"%.1f",[avgD1 floatValue]];
    NSString *avgHA = [NSString stringWithFormat:@"%.1f",[avgHA1 floatValue]];
    NSString *avgLA = [NSString stringWithFormat:@"%.1f",[avgLA1 floatValue]];
    NSString *avgHB = [NSString stringWithFormat:@"%.1f",[avgHB1 floatValue]];
    NSString *avgLB = [NSString stringWithFormat:@"%.1f",[avgLB1 floatValue]];
    NSString *avgHG = [NSString stringWithFormat:@"%.1f",[avgHG1 floatValue]];
    NSString *avgLG = [NSString stringWithFormat:@"%.1f",[avgLG1 floatValue]];
    [self.avgThetaArr addObject:avgT];
    [self.avgThetaArr addObject:avgD];
    [self.avgThetaArr addObject:avgHA];
    [self.avgThetaArr addObject:avgLA];
    [self.avgThetaArr addObject:avgHB];
    [self.avgThetaArr addObject:avgLB];
    [self.avgThetaArr addObject:avgHG];
    [self.avgThetaArr addObject:avgLG];
    
    [self removeAvgArrObject];

}
-(void)removeAvgArrObject{
    //清空脑波数据数组
    [self.ThetaArr removeAllObjects];
    [self.DeltaArr removeAllObjects];
    [self.HighaArr removeAllObjects];
    [self.LowaArr removeAllObjects];
    [self.HighbArr removeAllObjects];
    [self.LowbArr removeAllObjects];
    [self.HighgArr removeAllObjects];
    [self.LowgArr removeAllObjects];
}

#pragma mark ----- 我要睡觉界面匹配音乐代理方法 -----

-(void)starStage{
    self.isMarryMusic = YES;
    //创建一个统计匹配音乐的文件
    [self initLog];
    //清空上次匹配音乐的数据
    [self removeAvgArrObject];
    self.marryString = @"";
}
-(void)stopStage{
    self.isMarryMusic = NO;
    if (logFile) {
        //把数据固定格式写入到文件中
        [self.marryString writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
        self.marryString = @"";
    }
}
-(void)oneStage{
    //清空上次匹配音乐的数据
    [self musicAvgData];
    self.marryString = [NSString stringWithFormat:@"竖琴:  00:00-00:06{Theta:%@} {Delta:%@} {Higha:%@} {Lowa:%@} {Highb:%@} {Lowb:%@} {Highg:%@} {Lowg:%@}",self.avgThetaArr[0],self.avgThetaArr[1],self.avgThetaArr[2],self.avgThetaArr[3],self.avgThetaArr[4],self.avgThetaArr[5],self.avgThetaArr[6],self.avgThetaArr[7]];
    [self.avgThetaArr removeAllObjects];
}
-(void)twoStage{
    //清空上次匹配音乐的数据
    [self musicAvgData];
    self.marryString = [NSString stringWithFormat:@"%@\n铜钵:  00:07-00:18{Theta:%@} {Delta:%@} {Higha:%@} {Lowa:%@} {Highb:%@} {Lowb:%@} {Highg:%@} {Lowg:%@}",self.marryString,self.avgThetaArr[1],self.avgThetaArr[0],self.avgThetaArr[2],self.avgThetaArr[3],self.avgThetaArr[4],self.avgThetaArr[5],self.avgThetaArr[6],self.avgThetaArr[7]];
    [self.avgThetaArr removeAllObjects];
}
-(void)thrStage{
    //清空上次匹配音乐的数据
    [self musicAvgData];
    self.marryString = [NSString stringWithFormat:@"%@\n海洋鼓:00:19-01:00{Theta:%@} {Delta:%@} {Higha:%@} {Lowa:%@} {Highb:%@} {Lowb:%@} {Highg:%@} {Lowg:%@}",self.marryString,self.avgThetaArr[0],self.avgThetaArr[1],self.avgThetaArr[2],self.avgThetaArr[3],self.avgThetaArr[4],self.avgThetaArr[5],self.avgThetaArr[6],self.avgThetaArr[7]];
    [self.avgThetaArr removeAllObjects];
}
-(void)fouStage{
    //清空上次匹配音乐的数据
    [self musicAvgData];
    self.marryString = [NSString stringWithFormat:@"%@\n雨棍:  01:01-01:46{Theta:%@} {Delta:%@} {Higha:%@} {Lowa:%@} {Highb:%@} {Lowb:%@} {Highg:%@} {Lowg:%@}",self.marryString,self.avgThetaArr[0],self.avgThetaArr[1],self.avgThetaArr[2],self.avgThetaArr[3],self.avgThetaArr[4],self.avgThetaArr[5],self.avgThetaArr[6],self.avgThetaArr[7]];
    [self.avgThetaArr removeAllObjects];
}
-(void)fivStage{
    //清空上次匹配音乐的数据
    [self musicAvgData];
    self.marryString = [NSString stringWithFormat:@"%@\n风铃:  01:47-02:16{Theta:%@} {Delta:%@} {Higha:%@} {Lowa:%@} {Highb:%@} {Lowb:%@} {Highg:%@} {Lowg:%@}",self.marryString,self.avgThetaArr[0],self.avgThetaArr[1],self.avgThetaArr[2],self.avgThetaArr[3],self.avgThetaArr[4],self.avgThetaArr[5],self.avgThetaArr[6],self.avgThetaArr[7]];
    [self.avgThetaArr removeAllObjects];
}

#pragma mark - BlueToothDelegate
- (void)connetBlut:(CBPeripheral *)perI{
    if (self.sensor.activePeripheral && self.sensor.activePeripheral != perI) {
        [self.sensor disconnect:self.sensor.activePeripheral];
    }
    
    self.sensor.activePeripheral = perI;
    [self.sensor connect:self.sensor.activePeripheral];
}

#pragma mark ----- 懒加载初始化控件 -----


#pragma mark ----- popdelegate方法 -----
-(void)OkChangeView{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark ----- articaltableview代理数据源方法 -----

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.view.frame.size.height/5-20;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //使用自定的ArticleTableViewCell
    static NSString *identifier = @"Cell1";
    ArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ArticleTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.cellImage.image = [UIImage imageNamed:@"naoshengwufankui"];
        }else{
            cell.cellImage.image = [UIImage imageNamed:@"changqishuimianbuzu"];
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSelector:@selector(delectCellColor:) withObject:nil afterDelay:0.5];
}

//cell的选中颜色消失
- (void)delectCellColor:(id)sender{
    [self.articleTable deselectRowAtIndexPath:[self.articleTable indexPathForSelectedRow] animated:YES];
}

#pragma mark - 懒加载控件 -
//EEG脑波数据模型
-(BYEEGDataModel *)EEGDataModel{
    if (!_EEGDataModel) {
        _EEGDataModel = [BYEEGDataModel sharedEEGData];
        [_EEGDataModel initSleepDataModel];
    }
    return _EEGDataModel;
}

-(NSMutableArray *)ThetaArr{
    if (!_ThetaArr) {
        _ThetaArr = [[NSMutableArray alloc] init];
    }
    return _ThetaArr;
}
-(NSMutableArray *)DeltaArr{
    if (!_DeltaArr) {
        _DeltaArr = [[NSMutableArray alloc] init];
    }
    return _DeltaArr;
}
-(NSMutableArray *)HighaArr{
    if (!_HighaArr) {
        _HighaArr = [[NSMutableArray alloc] init];
    }
    return _HighaArr;
}
-(NSMutableArray *)LowaArr{
    if (!_LowaArr) {
        _LowaArr = [[NSMutableArray alloc] init];
    }
    return _LowaArr;
}
-(NSMutableArray *)HighbArr{
    if (!_HighbArr) {
        _HighbArr = [[NSMutableArray alloc] init];
    }
    return _HighbArr;
}
-(NSMutableArray *)LowbArr{
    if (!_LowbArr) {
        _LowbArr = [[NSMutableArray alloc] init];
    }
    return _LowbArr;
}
-(NSMutableArray *)HighgArr{
    if (!_HighgArr) {
        _HighgArr = [[NSMutableArray alloc] init];
    }
    return _HighgArr;
}
-(NSMutableArray *)LowgArr{
    if (!_LowgArr) {
        _LowgArr = [[NSMutableArray alloc] init];
    }
    return _LowgArr;
}
//初始化存放平均值的数组
-(NSMutableArray *)avgThetaArr{
    if (!_avgThetaArr) {
        _avgThetaArr = [[NSMutableArray alloc] init];
    }
    return _avgThetaArr;
}

@end
