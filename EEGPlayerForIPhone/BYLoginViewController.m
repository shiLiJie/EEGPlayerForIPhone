//
//  BYLoginViewController.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/7/5.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYLoginViewController.h"
#import "BYNomalRegistController.h"
#import<CommonCrypto/CommonDigest.h>

//返回码的枚举,避免魔法数字
typedef enum
{
    //以下是枚举成员
    failRequset = 0,
    successRequest = 1,
    
}returnCode;//枚举名称

@interface BYLoginViewController (){
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UITextField *UserTextfield;//用户名field
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextfield;//密码field
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;//登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *RegistBtn;//去注册按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnSpace;//登陆按钮约束(适配用)

@end

@implementation BYLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置按钮距离适配
    self.loginBtnSpace.constant = kScreen_Height*0.062;
    
    BYHttpRequest *re = [[BYHttpRequest alloc] init];
    
    

    
    
    
    
    
    
    
    
    
    

//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"log2016-11-25-14-08-11" ofType:@".txt"]];
//    
//    float a = [self fileSizeAtPath:[[NSBundle mainBundle] pathForResource:@"log2016-11-25-14-08-11" ofType:@".txt"]];
//    NSLog(@"%.1fM",a);
//    [re uploadEegFileWithUid:[UserTool readTheUserModle].ID EEGData:data fileName:@"log2016-11-25-14-08-11.txt"];

   
//    [re queryEEGDataListWithUid:@"55"];
//    
//
//    NSURL *URL = [NSURL URLWithString:@"http://cloud.musiccare.cn/Uploads/Nb_data/2016-11-23/58350c912c31d.txt"];
//    //默认配置
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    //AFN3.0+基于封住URLSession的句柄
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    //请求
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    //下载Task操作
//    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//        // @property int64_t totalUnitCount;     需要下载文件的总大小
//        // @property int64_t completedUnitCount; 当前已经下载的大小
//        
//        // 给Progress添加监听 KVO
//        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
//        // 回到主队列刷新UI
//        dispatch_async(dispatch_get_main_queue(), ^{
//            // 设置进度条的百分比
//        });
//        
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        
//        //获取主路径
//        NSString *pathDocuments=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *createPath=[NSString stringWithFormat:@"%@/user/%@",pathDocuments,[UserTool readTheUserModle].ID];
//        
//        //检查是否存在
//        if(![[NSFileManager defaultManager] fileExistsAtPath:createPath]){
//            [[NSFileManager defaultManager] createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
//        };
//        NSString *path = [createPath stringByAppendingPathComponent:response.suggestedFilename];
//        return [NSURL fileURLWithPath:path];
//        
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        //设置下载完成操作
//        NSString *imgFilePath = [filePath path];// 将NSURL转成NSString
//        NSLog(@"%@",[NSString fileMD5:imgFilePath]);
//        NSLog(@"%@",[NSString fileSHA1:imgFilePath]);
//
//    }];
//    
//    [_downloadTask resume];
}




#pragma mark - 推键盘 -
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.UserTextfield resignFirstResponder];
    [self.PasswordTextfield resignFirstResponder];
}

#pragma mark - UibuttonClick -
- (IBAction)loginBtnClick:(UIButton *)sender {
    //加密token
    NSString *token = [NSString md5WithString];
    //参数字典
    NSDictionary *dict = @{
                           @"token":token,
                           @"login_name":self.UserTextfield.text,
                           @"password":self.PasswordTextfield.text
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_login"
                                                 parameters:dict
                                                    success:^(id obj) {
                                                        NSString *msg = [NSString getResponseMsgWithObject:obj];
                                                        NSLog(@"%@",obj);
                                                        int code;
                                                        if ([[obj valueForKey:@"code"] isKindOfClass:[NSNumber class]]) {
                                                            code = [[obj valueForKey:@"code"] intValue];
                                                        }
                                                        //状态码1成功
                                                        if (code == successRequest) {
                                                            //存一下成功的账号信息
                                                            NSString *uid = [NSString getResponseUIDWithObject:obj];
                                                            UserObj *obj = [UserObj sharedUser];
                                                            obj.ID = uid;
                                                            obj.userID = self.UserTextfield.text;
                                                            obj.password = self.PasswordTextfield.text;
                                                            [UserTool saveTheUserInfo:obj];
                                                            //block成功
                                                            self.loginBlock(YES,msg);
                                                        }
                                                        //状态码0失败
                                                        if (code == failRequset) {
                                                            //block失败
                                                            self.loginBlock(NO,msg);
                                                        }
                                                        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                                                    }
                                                       fail:^(NSError *error) {
                                                           self.loginBlock(NO,@"请检查网络");
                                                        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
                                                       }];
}


- (IBAction)toRegistBtnClick:(UIButton *)sender {
    BYNomalRegistController *regist = [[BYNomalRegistController alloc] init];
    //推出注册控制器
    [self.navigationController pushViewController:regist animated:YES];
}

#pragma mark -
#pragma mark - Public Methods
+ (instancetype)loginControllerWithBlock:(BYLoginHandler)loginBlock {
    BYLoginViewController *loginVC = [[BYLoginViewController alloc] init];
    loginVC.loginBlock = loginBlock;
    return loginVC;
}

#pragma mark -
#pragma mark - Method Methods
//单个文件的大小
-(float)fileSizeAtPath:(NSString *)filePath{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024);
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
