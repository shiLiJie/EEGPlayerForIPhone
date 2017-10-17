//
//  BYPhoneRegistController.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/11/21.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYPhoneRegistController.h"
#import "BYTextField.h"
#import "BYNomalRegistController.h"
#import "BYEmailRegistController.h"

@interface BYPhoneRegistController()

@property (nonatomic, strong) UIImageView *bgImage;//背景图
@property (nonatomic, strong) UIImageView *accountLine;//账号线
@property (nonatomic, strong) UIImageView *passWordLine;//密码线
@property (nonatomic, strong) UIImageView *verifiCodeLine;//验证码线
@property (nonatomic, strong) UIImageView *userIcon;//用户icon
@property (nonatomic, strong) UIImageView *lockIcon;//密码icon
@property (nonatomic, strong) UIButton *verifiCodeBtn;//获取验证码按钮
@property (nonatomic, strong) UIButton *registBtn;//注册按钮
@property (nonatomic, strong) UIButton *mailRegist;//邮箱注册
@property (nonatomic, strong) UIButton *phoneRegist;//手机注册
@property (nonatomic, strong) UITextField *accountTextField;//账号输入框
@property (nonatomic, strong) UITextField *passWordTextField;//密码输入框
@property (nonatomic, strong) UITextField *verifiCodeTextField;//验证码输入框
@end

@implementation BYPhoneRegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];//设置ui
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//设置UI
-(void)setUpUI{
    self.view.backgroundColor = [UIColor yellowColor];
    //textfield光标
    [[UITextField appearance] setTintColor:[UIColor hexColorWithString:@"71787b"]];
    // navibar标题
    self.title = @"手机注册";
    // navibar字体大小,颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //两个按钮的父类view
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //返回主页
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"fanhuidengluicon"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(backToLoginVc) forControlEvents:UIControlEventTouchUpInside];
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.leftBarButtonItem = leftCunstomButtonView;
    
    //加入控件元素
    [self addSubView];
}
//添加ui控件
-(void)addSubView{
    [self.view addSubview:self.bgImage];
    [self.view addSubview:self.accountLine];
    [self.view addSubview:self.verifiCodeLine];
    [self.view addSubview:self.verifiCodeTextField];
    [self.view addSubview:self.verifiCodeBtn];
    [self.view addSubview:self.passWordLine];
    [self.view addSubview:self.registBtn];
    [self.view addSubview:self.mailRegist];
    [self.view addSubview:self.phoneRegist];
    [self.view addSubview:self.userIcon];
    [self.view addSubview:self.lockIcon];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passWordTextField];
    
}

#pragma mark - 退键盘 -
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.passWordTextField resignFirstResponder];
    [self.accountTextField resignFirstResponder];
    [self.verifiCodeTextField resignFirstResponder];
}

#pragma mark - 按钮点击 -
//返回登陆界面
-(void)backToLoginVc{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)getVerifiBtnClick{
    //获取验证码按钮点击
    //获取验证码按钮点击
    NSString *token = [NSString md5WithString];
    NSDictionary *dict = @{
                           @"token":token,
                           @"phone":self.accountTextField.text,
                           @"type":@"register"
                           };
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_phone_verify"
                                                 parameters:dict
                                                    success:^(id obj) {
                                                        if ([SucceedCoder isEqualToString:[NSString stringWithFormat:@"%@",[obj valueForKey:@"code"]]]) {
                                                            [MBProgressHUD showSuccess:@"发送成功"];
                                                        }else{
                                                            [MBProgressHUD showError:@"获取验证码失败"];
                                                        }
                                                    }
                                                       fail:^(NSError *error) {
                                                           [MBProgressHUD showSuccess:@"发送失败"];
                                                       }];
}
//注册按钮点击方法
-(void)registerBtnClick{
    //判断是否传入空的账号或密码
    if ([self.accountTextField.text isEqualToString:@""] ||
        [self.passWordTextField.text isEqualToString:@""] ) {
        return;
    }

    if (self.passWordTextField.text.length > 20) {
        [MBProgressHUD showText:@"密码长度不要大于20位"];
        return;
    }
    //排除特殊字符
    NSString *acc=self.accountTextField.text;
    NSString *pwd=self.passWordTextField.text;
    
    //再判断格式是否正确
    if ([SLJJudgementString checkTelNumber:acc]) {
    }else{
        //没有
        [MBProgressHUD showText:@"手机号格式不正确"];
        return;
    }
    if ([SLJJudgementString checkPassword:pwd]) {
    }else{
        //没有
        [MBProgressHUD showText:@"密码格式不正确"];
        return;
    }
    NSString *token = [NSString md5WithString];
    NSDictionary *dict = @{
                           @"token":token,
                           @"register_name":self.accountTextField.text,
                           @"password":self.passWordTextField.text,
                           @"re_password":self.passWordTextField.text,
                           @"verify_code":self.verifiCodeTextField.text,
                           @"register_type":[NSString stringWithFormat:@"2"],
                           @"org_id":@"1",
                           @"register_form":@"app"
                           };
    //注册账号网络请求
    [[HttpRequest shardWebUtil] postNetworkRequestURLString:@"http://cloud.musiccare.cn/Api/NbApi/nb_register"
                                                 parameters:dict
                                                    success:^(id obj) {
                                                        NSLog(@"%@",obj);
                                                        NSString *msg = [NSString getResponseMsgWithObject:obj];
                                                        NSString *uid = [NSString getResponseUIDWithObject:obj];
                                                        if ([SucceedCoder isEqualToString:[NSString stringWithFormat:@"%@",[obj valueForKey:@"code"]]]) {
                                                            [MBProgressHUD showSuccess:@"注册成功"];
                                                            //存用户数据
                                                            UserObj *obj = [UserObj sharedUser];
                                                            obj.ID = uid;
                                                            obj.userID = self.accountTextField.text;
                                                            obj.password = self.passWordTextField.text;
                                                            [UserTool saveTheUserInfo:obj];
                                                            //注册成功回调
                                                            NSNotification *notification =[NSNotification notificationWithName:SUCCESSREGISTCHANGEROOT object:nil userInfo:nil];
                                                            //通过通知中心发送通知
                                                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                                                        }else{
                                                            [MBProgressHUD showError:msg];
                                                        }
                                                        
                                                    } fail:^(NSError *error) {
                                                        //失败,提示网络错误
                                                    }];
}
//账号注册按钮点击
-(void)mailRegistBtnClick{
    //账号注册按钮点击
    //账号注册按钮点击
    BYNomalRegistController *nomal = [[BYNomalRegistController alloc] init];
    [self.navigationController pushViewController:nomal animated:YES];
    
}
//邮箱注册按钮点击
-(void)phongRegistBtnClick{
    //邮箱注册按钮点击
    BYEmailRegistController *emal = [[BYEmailRegistController alloc] init];
    [self.navigationController pushViewController:emal animated:YES];
}

#pragma mark - 私有方法 -
//排除特殊字符
-(BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

#pragma mark - 懒加载控件 -
//账号线
-(UIImageView *)accountLine{
    if (!_accountLine) {
        _accountLine = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2-kScreen_Width*0.71/2, kScreen_Height*0.2, kScreen_Width*0.71, 1)];
        _accountLine.image = [UIImage imageNamed:@"xian"];
    }
    return _accountLine;
}
//用户图标icon
-(UIImageView *)userIcon{
    if (!_userIcon) {
        _userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2-kScreen_Width*0.71/2, _accountLine.frame.origin.y-23-10, 20, 23)];
        [_userIcon setImage:[UIImage imageNamed:@"9"]];
    }
    return _userIcon;
}
//账号textfield
-(UITextField *)accountTextField{
    if (!_accountTextField) {
        _accountTextField = [[BYTextField alloc] initWithFrame:CGRectMake(_userIcon.frame.origin.x+40, _accountLine.frame.origin.y-23-10, _accountLine.frame.size.width-40, 30)];
        _accountTextField.placeholder = @"请输入手机号";
        _accountTextField.textColor = [UIColor hexColorWithString:@"71787b"];
        _accountTextField.font = [UIFont systemFontOfSize:13.0f];
        _accountTextField.keyboardType = UIKeyboardTypeNumberPad;
        _accountTextField.keyboardAppearance = UIKeyboardAppearanceDark;
        _accountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return _accountTextField;
}
//验证码线
-(UIImageView *)verifiCodeLine{
    if (!_verifiCodeLine) {
        _verifiCodeLine = [[UIImageView alloc] initWithFrame:CGRectMake(_accountLine.frame.origin.x, _accountLine.frame.origin.y+kScreen_Height*0.091, _accountLine.frame.size.width/2, 1)];
        _verifiCodeLine.image = [UIImage imageNamed:@"xian"];
    }
    return _verifiCodeLine;
}
//验证码textfield
-(UITextField *)verifiCodeTextField{
    if (!_verifiCodeTextField) {
        _verifiCodeTextField = [[BYTextField alloc] initWithFrame:CGRectMake(_accountLine.frame.origin.x+_verifiCodeLine.frame.size.width/4, _verifiCodeLine.frame.origin.y-23-10, _verifiCodeLine.frame.size.width*0.75, 30)];
        _verifiCodeTextField.placeholder = @"输入验证码";
        _verifiCodeTextField.textColor = [UIColor hexColorWithString:@"71787b"];
        _verifiCodeTextField.font = [UIFont systemFontOfSize:13.0f];
        _verifiCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _verifiCodeTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
    return _verifiCodeTextField;
}
//获取验证码按钮
-(UIButton *)verifiCodeBtn{
    if (!_verifiCodeBtn) {
        _verifiCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_verifiCodeTextField.frame.origin.x+_verifiCodeTextField.frame.size.width+25, _verifiCodeLine.frame.origin.y-kScreen_Height*0.065, kScreen_Width*0.285, kScreen_Height*0.065)];
        [_verifiCodeBtn setImage:[UIImage imageNamed:@"huoquyanzhengma"] forState:UIControlStateNormal];
        [_verifiCodeBtn addTarget:self action:@selector(getVerifiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _verifiCodeBtn;
}
//密码线
-(UIImageView *)passWordLine{
    if (!_passWordLine) {
        _passWordLine = [[UIImageView alloc] initWithFrame:CGRectMake(_accountLine.frame.origin.x, _verifiCodeLine.frame.origin.y +kScreen_Height*0.091, _accountLine.frame.size.width, 1)];
        _passWordLine.image = [UIImage imageNamed:@"xian"];
    }
    return _passWordLine;
}
//密码图标icon
-(UIImageView *)lockIcon{
    if (!_lockIcon) {
        _lockIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_passWordLine.frame.origin.x, _passWordLine.frame.origin.y-23-10, 23, 23)];
        _lockIcon.image = [UIImage imageNamed:@"lock-1"];
    }
    return _lockIcon;
}
//密码textfield
-(UITextField *)passWordTextField{
    if (!_passWordTextField) {
        _passWordTextField = [[BYTextField alloc] initWithFrame:CGRectMake(_accountTextField.frame.origin.x, _passWordLine.frame.origin.y-23-10, _accountLine.frame.size.width-40, 30)];
        _passWordTextField.placeholder = @"请输入您要设置的密码";
        _passWordTextField.textColor = [UIColor hexColorWithString:@"71787b"];
        _passWordTextField.font = [UIFont systemFontOfSize:13.0f];
        _passWordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passWordTextField.keyboardAppearance = UIKeyboardAppearanceDark;
        _passWordTextField.secureTextEntry = YES;
    }
    return _passWordTextField;
}
//注册按钮
-(UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn = [[UIButton alloc] initWithFrame:CGRectMake(_accountLine.frame.origin.x, _passWordLine.frame.origin.y+kScreen_Height*0.065, _accountLine.frame.size.width, kScreen_Height*0.076)];
        [_registBtn setBackgroundImage:[UIImage imageNamed:@"zhuce"] forState:UIControlStateNormal];
        [_registBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}
//邮箱注册按钮
-(UIButton *)mailRegist{
    if (!_mailRegist) {
        _mailRegist = [[UIButton alloc] initWithFrame:CGRectMake(_registBtn.frame.origin.x, _registBtn.frame.origin.y+_registBtn.frame.size.height+kScreen_Height*0.05, _registBtn.frame.size.width/2, kScreen_Height*0.02)];
        [_mailRegist setTintColor:[UIColor hexColorWithString:@"e5e6e4"]];
        [_mailRegist setTitle:@"账号密码注册" forState:UIControlStateNormal];
        _mailRegist.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _mailRegist.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _mailRegist.titleLabel.font = [UIFont systemFontOfSize:14];
        [_mailRegist addTarget:self action:@selector(mailRegistBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mailRegist;
}
//手机注册按钮
-(UIButton *)phoneRegist{
    if (!_phoneRegist) {
        _phoneRegist = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width-(kScreen_Width/2-kScreen_Width*0.71/2)-kScreen_Width*0.2, _mailRegist.frame.origin.y, kScreen_Width*0.2, kScreen_Height*0.02)];
        [_phoneRegist setTintColor:[UIColor hexColorWithString:@"e5e6e4"]];
        [_phoneRegist setTitle:@"邮箱注册" forState:UIControlStateNormal];
        _phoneRegist.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _phoneRegist.titleLabel.font = [UIFont systemFontOfSize:14];
        [_phoneRegist addTarget:self action:@selector(phongRegistBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneRegist;
}
//背景图
-(UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]initWithFrame:self.view.frame];
        _bgImage.image = [UIImage imageNamed:@"denglubg"];
    }
    return _bgImage;
}

@end
