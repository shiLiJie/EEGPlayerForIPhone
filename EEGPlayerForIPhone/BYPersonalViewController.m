//
//  BYPersonalViewController.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/18.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYPersonalViewController.h"
#import "ImagePicker.h"
#import "BYSheetPickerView.h"
#import "UserObj.h"
#import "UserTool.h"
#import "BYPersonalUserNameCell.h"
#import "BYPersonalTable.h"

@interface BYPersonalViewController (){
    NSArray *dataSource;
    ImagePicker *imagePicker;
}

@property (nonatomic, strong) BYPersonalTable *personalTable;//个人资料tableview
@property (nonatomic, strong) UIImage *pickerImagePic;//选择的图片
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) BYPersonalUserNameCell *nameCell;//第二组第一行姓名cell

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birth;
@property (nonatomic, copy) NSString *high;
@property (nonatomic, copy) NSString *weith;

@end

@implementation BYPersonalViewController
-(void)viewWillAppear:(BOOL)animated{
    // navibar设置透明
    self.navigationController.navigationBar.translucent = YES;
    UIColor *color = [UIColor blackColor];
    CGRect rect = CGRectMake(0, 0, kScreen_Width, 64);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.clipsToBounds = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    [self setUpUI];
    
    self.isEdit = NO;
}

//设置UI
-(void)setUpUI{
    
    // navibar标题
    self.title = @"个人资料";
    // navibar字体大小,颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    
    //左侧返回个人中心按钮
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(-15, 5, 40, 40)];
    [leftButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"fanhuiicon"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(bacaPresonalCenter) forControlEvents:UIControlEventTouchUpInside];
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
    self.navigationItem.leftBarButtonItem = leftCunstomButtonView;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    //修改头像后右上角按钮出现
    //右侧保存个人资料按钮
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 40)];
    [rightButtonView addSubview:self.saveBtn];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(savePresonalData) forControlEvents:UIControlEventTouchUpInside];
    [self.saveBtn setHidden:YES];
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    [self.view addSubview:self.personalTable];//添加个人资料tabview
    self.personalTable.delegate = self;//设置代理
    self.personalTable.dataSource = self;//设置数据源
    self.personalTable.showsVerticalScrollIndicator = NO;//不显示右侧滑块
    self.personalTable.separatorStyle=UITableViewCellSeparatorStyleSingleLine;//分割线
    dataSource=@[@"昵称",@"性别",@"出生日期",@"身高",@"体重"];//设置数据
    self.personalTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//隐藏多余的cell
    
    //初始化
    imagePicker = [ImagePicker sharedManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadImage) name:@"PICKHEADIMAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeIsEdit) name:@"ISEDIT" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getusername:) name:@"POSTUSERNAME" object:nil];
    
}



//左上角返回个人中心按钮
-(void)bacaPresonalCenter{
    [[self navigationController] popViewControllerAnimated:YES];
    
}

//右上角保存个人资料按钮
-(void)savePresonalData{
    
    //本地持久化
    NSData *imagedata=UIImagePNGRepresentation(self.pickerImagePic);
    //JEPG格式
    //NSData *imagedata=UIImageJEPGRepresentation(image);
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:@"saveFore.png"];
    [imagedata writeToFile:savedImagePath atomically:YES];//先注释掉避免占内存
    
    NSLog(@"%@",savedImagePath);
    
    UserObj *obj = [UserObj sharedUser];
    if (self.sex!=nil) {
        obj.sex = self.sex;
    }
    if (self.birth!=nil) {
        obj.birthDate = self.birth;
    }
//    if (self.high!=nil) {
//        obj.userHigh = self.high;
//    }
//    if (self.weith!=nil) {
//        obj.userWeith = self.weith;
//    }
    if (self.name!=nil) {
        obj.name = self.name;
    }
//    [UserTool saveTheUserInfo:obj];
    
    [[self navigationController] popViewControllerAnimated:YES];
//    [self.personalTable reloadData];
    self.saveBtn.hidden = YES;
    

}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    return 2;
}

//设置每个分组下tableview的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{

        return dataSource.count;
    }
}

//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}

//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }else{
        return 4;
    }
}

//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 102;
    }
    return 50;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifer=@"cell";
    BYHeadCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    
    static NSString *identifier = @"Cell1";
    BYPersonalCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    static NSString *identifier2 = @"Cell2";
    self.nameCell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    
    
    if (indexPath.section==0) {// 第一组带头像
        if (cell == nil) {
            cell=[[BYHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"BYHeadCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        //设置用户名
        cell.userNameLab.text=@"头像";
        UIImage *ima = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserTool readTheUserModle].headImg]]];
        [cell.headImageBtn setBackgroundImage:ima forState:UIControlStateNormal];
        //如果是编辑模式,有保存按钮
//        if (self.saveBtn.hidden == NO) {
//            if (self.pickerImagePic != nil) {
//                [cell.headImageBtn setBackgroundImage:self.pickerImagePic forState:UIControlStateNormal];
//            }else{
//                //获取沙盒图片
//                NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/saveFore.png"];
//                UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
//                self.pickerImagePic = savedImage;
//                //设置用户头像
//                if (self.pickerImagePic != nil) {
//                    [cell.headImageBtn setBackgroundImage:self.pickerImagePic forState:UIControlStateNormal];
//                }
//            }
//        }else{
//            //获取沙盒图片
//            NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/saveFore.png"];
//            UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
//            self.pickerImagePic = savedImage;
//            //设置用户头像
//            if (self.pickerImagePic != nil) {
//                [cell.headImageBtn setBackgroundImage:self.pickerImagePic forState:UIControlStateNormal];
//            }
//        }
        return cell;
        
    }else{
        if (indexPath.row==0){
            if (self.nameCell==nil) {// 第二组基本信息
                self.nameCell=[[BYPersonalUserNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"BYPersonalUserNameCell" owner:nil options:nil];
                self.nameCell = [nibs lastObject];
                tableView.separatorStyle = UITableViewCellSelectionStyleNone;// 取消系统分割线

                if (self.saveBtn.hidden == NO) {
                    if (self.name != nil) {
                        self.nameCell.nameField.text  = self.name;
                    }else{
                        self.nameCell.nameField.text  = [UserObj sharedUser].name;
                    }
                }else{
                    self.nameCell.nameField.text  = [UserObj sharedUser].name;
                }
            }
            
            //如果是第一响应者
            if ([self.nameCell isFirstResponder]) {
                //放弃第一响应者
                [self.nameCell resignFirstResponder];
                self.isEdit = NO;
                //更改距离左边的约束
                self.nameCell.leftConstrain.constant = 0;
            }else{
                self.isEdit = NO;
                //更改距离左边的约束
                self.nameCell.leftConstrain.constant = 0;
            }
            
            
            return self.nameCell;
        }else{
            if (cell1==nil) {// 第二组基本信息
                cell1=[[BYPersonalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"BYPersonalCell" owner:nil options:nil];
                cell1 = [nibs lastObject];
                tableView.separatorStyle = UITableViewCellSelectionStyleNone;// 取消系统分割线
            }
            //给cell左侧Lab标题赋值
            cell1.leftLab.text = [dataSource objectAtIndex:indexPath.row];
            //给右侧用户信息赋值
            if (indexPath.row == 1) {
                //如果是编辑模式,有保存按钮
                if (self.saveBtn.hidden == NO) {
                    if (self.sex != nil) {
                        cell1.rightLab.text = self.sex;
                    }else{
                        cell1.rightLab.text = [UserObj sharedUser].sex;
                    }
                }else{
                    cell1.rightLab.text = [UserObj sharedUser].sex;
                }
            }
            if (indexPath.row == 2) {
                
                //如果是编辑模式,有保存按钮
                if (self.saveBtn.hidden == NO) {
                    if (self.birth != nil) {
                        cell1.rightLab.text = self.birth;
                    }else{
                        cell1.rightLab.text = [UserObj sharedUser].birthDate;
                    }
                }else{
                    cell1.rightLab.text = [UserObj sharedUser].birthDate;
                }
            }
            if (indexPath.row == 3) {
                
                //如果是编辑模式,有保存按钮
                if (self.saveBtn.hidden == NO) {
                    if (self.high != nil) {
                        cell1.rightLab.text = self.high;
                    }else{
//                        cell1.rightLab.text = [UserObj sharedUser].userHigh;
                    }
                }else{
//                    cell1.rightLab.text = [UserObj sharedUser].userHigh;
                }
            }
            if (indexPath.row == 4) {
                
                //如果是编辑模式,有保存按钮
                if (self.saveBtn.hidden == NO) {
                    if (self.weith != nil) {
                        cell1.rightLab.text = self.weith;
                    }else{
//                        cell1.rightLab.text = [UserObj sharedUser].userWeith;
                    }
                }else{
//                    cell1.rightLab.text = [UserObj sharedUser].userWeith;
                }
            }
            
            
            return cell1;
        }        
    }
}
//滑动tableview退出键盘,发送通知给cell拿到当前的名字
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isEdit) {
        NSNotification *notification = [NSNotification notificationWithName:@"GETUSERNAME" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

//设置tableview的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.isEdit == YES) {
        NSNotification *notification = [NSNotification notificationWithName:@"GETUSERNAME" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self.personalTable reloadData];
        return;
    }
    
    
    
    if ([indexPath section] == 0) {
        //选取头像
        [self changeHeadImage];
        [self delectCellColor:nil];

    }else{
        
        //性别
        if ([indexPath row] == 1) {
            //sheetPicker
            [self setUserInfoFromSheetPickerData:@[@"男",@"女"] pickerTitle:@"性别" arr1:nil arr2:nil compent:0];
        }
        //出生日期
        if ([indexPath row] == 2){
            NSMutableArray *yearArr = [[NSMutableArray alloc] init];
            //自定义的pickview,给出三个时间选项
            for (int i = 1960; i <= 2016; i ++) {
                [yearArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
            NSMutableArray *monArr = [[NSMutableArray alloc] init];
            //自定义的pickview,给出三个时间选项
            for (int i = 1; i <= 12; i ++) {
                [monArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
            NSMutableArray *dayArr = [[NSMutableArray alloc] init];
            //自定义的pickview,给出三个时间选项
            for (int i = 1; i <= 31; i ++) {
                [dayArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
            [self setUserInfoFromSheetPickerData:yearArr pickerTitle:@"出生日期" arr1:monArr arr2:dayArr compent:2];
        }
        //身高
        if ([indexPath row] == 3) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            //自定义的pickview,给出三个时间选项
            for (int i = 140; i <= 200; i ++) {
                [arr addObject:[NSString stringWithFormat:@"%d",i]];
            }
            [self setUserInfoFromSheetPickerData:arr pickerTitle:@"身高(cm)" arr1:nil arr2:nil compent:0];
        }
        //体重
        if ([indexPath row] == 4) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            //自定义的pickview,给出三个时间选项
            for (int i = 40; i <= 100; i ++) {
                [arr addObject:[NSString stringWithFormat:@"%d",i]];
            }
            //sheetPicker
            [self setUserInfoFromSheetPickerData:arr pickerTitle:@"体重(kg)" arr1:nil arr2:nil compent:0];
        }
    }
}
//cell的选中颜色消失
- (void)delectCellColor:(id)sender{
    [self.personalTable deselectRowAtIndexPath:[self.personalTable indexPathForSelectedRow] animated:YES];
}


-(void)setUserInfoFromSheetPickerData:(NSArray *)dataArr pickerTitle:(NSString *)pickerTitle arr1:(NSArray *)arr1 arr2:(NSArray *)arr2 compent:(NSInteger)compent{
    //自定义的pickview,给出三个时间选项
    NSArray * str  = dataArr;
    BYSheetPickerView *pickerView = [BYSheetPickerView BYSheetStringPickerWithTitle:str andHeadTitle:pickerTitle Andcall:^(BYSheetPickerView *pickerView, NSString *choiceString) {
        //在回调里修改cell右侧内容
        [self btnActionForUserSetting:choiceString];
        //dismiss
        [pickerView dismissPicker];
    } compent:compent title1:arr1 title12:arr2 dismiss:^{
        //点击后cell的选中颜色消失
        [self performSelector:@selector(delectCellColor:) withObject:nil afterDelay:0.5];
    }];
    
    [pickerView show];
}


//通过tableview的点击来获取到当前点击的cell,并且改变cell的内容
- (void)btnActionForUserSetting:(NSString *) userInfo {
    //当前点击的行数
    NSIndexPath *indexPath = [self.personalTable indexPathForSelectedRow];
    //拿到cell
    BYPersonalCell *cell = [self.personalTable cellForRowAtIndexPath:indexPath];
    //修改cell内容
    cell.rightLab.text= userInfo;

    if (indexPath.row == 1) {
        self.sex = userInfo;
    }
    if (indexPath.row == 2) {
        self.birth = userInfo;
    }
    if (indexPath.row == 3) {
        self.high = userInfo;
    }
    if (indexPath.row == 4) {
        self.weith = userInfo;
    }
    
    [self.saveBtn setHidden:NO];
    
    //点击后cell的选中颜色消失
    [self performSelector:@selector(delectCellColor:) withObject:nil afterDelay:0.5];
}



#pragma mark - 通知方法
-(void)changeHeadImage{
    //设置主要参数
    [imagePicker dwSetPresentDelegateVC:self SheetShowInView:self.view InfoDictionaryKeys:(long)nil];
    
    //回调
    [imagePicker dwGetpickerTypeStr:^(NSString *pickerTypeStr) {
        
        NSLog(@"%@",pickerTypeStr);
        
    } pickerImagePic:^(UIImage *pickerImagePic) {
        
        self.pickerImagePic = pickerImagePic;
        [self.personalTable reloadData];
        NSLog(@"%@",pickerImagePic);
        
        self.saveBtn.hidden = NO;
    }];
}
//从cell里拿出当前输入的text
- (void)getusername:(NSNotification *)text{
    self.name = text.userInfo[@"name"];
    
    if (![self.name isEqualToString:[UserObj sharedUser].name]) {
        self.saveBtn.hidden = NO;
    }
}

//正在编辑 == yes
-(void)changeIsEdit{
    
    self.isEdit = YES;
}

#pragma mark - 懒加载控件
-(UITableView *)personalTable{
    if (!_personalTable) {
        _personalTable = [[BYPersonalTable alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 49 - 44 - 20)];
        _personalTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
    }
    return _personalTable;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
