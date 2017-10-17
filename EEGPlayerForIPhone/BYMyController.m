//
//  BYMyController.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/18.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYMyController.h"
#import "BYPersonalViewController.h"
#import "DIDatepicker.h"
#import "MLMCircleView.h"
#import "BYLogCell.h"
#import "UserObj.h"
#import "CalenderView.h"

@interface BYMyController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *headButton;     // 中间头像按钮
@property (nonatomic, strong) UIImageView *bgImg;       // 背景图片
@property (nonatomic, strong) DIDatepicker *datepicker; // 日历控件
@property (nonatomic, strong) UIView *clanderView;      // 日期月份背景view
@property (nonatomic, strong) UILabel *dayLab;          // 日期Lab
@property (nonatomic, strong) UILabel *monLab;          // 月份Lab
@property (nonatomic, strong) UIImageView *clanderImaBg;// 日历背景
@property (nonatomic, strong) MLMCircleView *circleView;// 半圆进度条
@property (nonatomic, strong) UIButton *todayPingguBtn; // 中间头像按钮
@property (nonatomic, strong) UITableView *logTableView;// 日志tableview
@property (nonatomic, strong) UIView *clanderCutView;   // 日历中间竖着的黑线
@property (nonatomic, strong) NSMutableArray *textTimeArr;//存放检测时间的数组
@property (nonatomic, strong) NSMutableArray *textStateArr;//存放检测状态的数组
@property (nonatomic, strong) UILabel *stateLab;        //状态评分Lab
@property (nonatomic, strong) UILabel *userNameLab;     //用户昵称Lab'

@property (nonatomic, assign) float bestCount;//当天检测三种状态出现的次数
@property (nonatomic, assign) float betterCount;
@property (nonatomic, assign) float goodCount;

@end

@implementation BYMyController


-(void)viewWillAppear:(BOOL)animated{
    
    self.bestCount = 0;
    self.betterCount = 0;
    self.goodCount = 0;
    
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
    
//    获取沙盒图片
//    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/saveFore.png"];
//    UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
    UserObj *obj = [UserTool readTheUserModle];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj.headImg]];
    UIImage *headImage = [UIImage imageWithData:data];
    //昵称Lab赋值
    self.userNameLab.text = [obj.name isKindOfClass:NULL]?obj.name:@"";
//    self.userNameLab.text=@"";
//    头像图片赋值
    [self.headButton setImage:headImage forState:UIControlStateNormal];
    
    //添加属性控件
    [self.view addSubview:self.clanderView];
    [self.clanderView addSubview:self.clanderImaBg];
    [self.clanderView addSubview:self.datepicker];
    [self.clanderView addSubview:self.monLab];
    [self.clanderView addSubview:self.dayLab];
    [self.clanderView addSubview:self.clanderCutView];
    [self.circleView addSubview:self.stateLab];
    
//    每次进来都选择一下当天日期,避免当时检测过后看不到这一次的数据
    [self updateSelectedDate];
}

//更改进度条和描述状态
-(void)changeProStateLab{
    if (self.bestCount > self.betterCount && self.bestCount > self.goodCount) {
        //很好
        self.stateLab.text = @"良好";
        [self.circleView setProgress:.8];
    }
    if (self.betterCount > self.bestCount && self.betterCount > self.goodCount) {
        //一般
        self.stateLab.text = @"一般";
        [self.circleView setProgress:.6];
    }
    if (self.goodCount > self.betterCount && self.goodCount > self.bestCount) {
        //差
        self.stateLab.text = @"差";
        [self.circleView setProgress:.3];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    //更改进度条和描述状态
    [self changeProStateLab];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化给进度条一个进度
    [self.circleView setProgress:0.6];
    
    //设置UI
    [self setUpUI];
    
}

//设置UI
-(void)setUpUI{
    self.view.backgroundColor = [UIColor yellowColor];
    
    // navibar标题
    self.title = @"个人中心";
    // navibar字体大小,颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //两个按钮的父类view
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    //返回主页
    UIButton *mainAndSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    [rightButtonView addSubview:mainAndSearchBtn];
    [mainAndSearchBtn setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [mainAndSearchBtn addTarget:self action:@selector(musicCatigray) forControlEvents:UIControlEventTouchUpInside];
    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = leftCunstomButtonView;
    
    //加入控件元素
    [self addSubView];
}

//控件添加到视图上
-(void)addSubView{
    //获取沙盒图片
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/saveFore.png"];
    UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
    
    [self.headButton setImage:savedImage forState:UIControlStateNormal];
    [self.view addSubview:self.bgImg];
    [self.view addSubview:self.headButton];
    [self.view addSubview:self.circleView];
    [self.view addSubview:self.todayPingguBtn];
    [self.view addSubview:self.logTableView];
    [self.view addSubview:self.userNameLab];
    
    //灰色小线条
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(self.circleView.frame.size.width/2-17, self.circleView.frame.size.height-40, 34, 3)];
    grayView.backgroundColor = RGB(169, 173, 174);
    grayView.layer.cornerRadius = 1;//设置那个圆角的有多圆
    grayView.layer.borderWidth = 0;//设置边框的宽度，当然可以不要
    [self.circleView addSubview:grayView];
    
    //健康状况Lab
    UILabel *bigScore = [[UILabel alloc] initWithFrame:CGRectMake(self.circleView.frame.size.width/2-30, self.circleView.frame.size.height/2-40, 60, 20)];
    bigScore.text = @"健康状况";
    bigScore.textColor = RGB(212, 216, 220);
    bigScore.font = [UIFont systemFontOfSize:11];
    bigScore.textAlignment = NSTextAlignmentCenter;
    [self.circleView addSubview:bigScore];
}


-(void)musicCatigray{
    
}

//点击月份和星期弹出月日历方法
-(void)presentZheCalander{
    //封装好的方法,一行创建月份日历
//    CalenderView *calender = [[CalenderView alloc]initWithFrame:
//                              CGRectMake(10, 75, self.view.bounds.size.width - 20,
//                                         ((self.view.bounds.size.width - 20) / 7) * 5 + 50)];
//    [self.view addSubview:calender];
}


// 头像按钮方法
-(void)pushPersonalView{
    //如果在push跳转时需要隐藏tabBar，设置self.hidesBottomBarWhenPushed=YES;
    self.hidesBottomBarWhenPushed=YES;
    //推出个人详情控制器
    BYPersonalViewController *vc = [[BYPersonalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    //并在push后设置self.hidesBottomBarWhenPushed=NO;
    //这样back回来的时候，tabBar会恢复正常显示。
    self.hidesBottomBarWhenPushed=NO;
    
}

// 日历点击输出方法
- (void)updateSelectedDate
{
    self.bestCount = 0;
    self.betterCount = 0;
    self.goodCount = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEEEddMMMM" options:0 locale:nil];
    
    self.datepicker.selectedDateBottomLineColor = RGB(247, 223, 147);
    self.datepicker.bottomLineColor = [UIColor clearColor];
    // 设置日期Lab
    [formatter setDateFormat:@"MMMM"];
    self.dayLab.text = [formatter stringFromDate:self.datepicker.selectedDate];
    // 设置月份Lab
    [formatter setDateFormat:@"EEEE"];
    self.monLab.text = [formatter stringFromDate:self.datepicker.selectedDate];
    
//    NSLog(@"%@",[formatter stringFromDate:self.datepicker.selectedDate]);
    
    [self getLogData];
    
//    //更改进度条和描述状态
//    [self changeProStateLab];
}

//获取到日志数据
-(void)getLogData{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString *createPath=[NSString stringWithFormat:@"%@/user/%@",kDocuments,[UserObj sharedUser].ID];
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:createPath error:nil]];
    
    self.textTimeArr = [[NSMutableArray alloc] init];
    self.textStateArr = [[NSMutableArray alloc] init];
    
    for (NSString *text in arr) {
        
        //判断roadTitleLab.text 是否含有qingjoin
        if([text rangeOfString:@".txt1"].location !=NSNotFound)
        {
            //有
            
            NSArray *getFilename = [text componentsSeparatedByString:@"-"];
            if (getFilename.count == 9) {
                //                    log2016,
                //                    09,
                //                    26,
                //                    00,
                //                    31,
                //                    58,
                //                    "00:31",
                //                    "00:31",
                //                    "1.txt1"
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *dayFormattedString = [dateFormatter stringFromDate:self.datepicker.selectedDate];
                NSArray *getFilename1 = [dayFormattedString componentsSeparatedByString:@"-"];
                //                    2016,
                //                    09,
                //                    25
                if ([getFilename[0] isEqual:getFilename1[0]] &&
                    [getFilename[1] isEqual:getFilename1[1]] &&
                    [getFilename[2] isEqual:getFilename1[2]]) {
                   
//                    NSLog(@"%@",text);
                    NSArray *getFilename2 = [text componentsSeparatedByString:@"-"];
//                    NSLog(@"%@",getFilename2[6]);
//                    NSLog(@"%@",getFilename2[7]);
                    
                    //符合当前日期检测的条件,加入到时间段数组
                    [self.textTimeArr addObject:[NSString stringWithFormat:@"%@ - %@",getFilename2[6],getFilename2[7]]];
                    [self.textStateArr addObject:getFilename2[8]];
                    
                }                
            }
        }
        else
        {
            //没有数据
//            [self.logTableView reloadData];
        }
    }
    
    [self.logTableView reloadData];
    //更改进度条和描述状态
    [self changeProStateLab];
}



#pragma mark - tableview代理
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 39;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.textTimeArr.count != 0) {
        return self.textTimeArr.count;
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //使用自定的ArticleTableViewCell
    static NSString *identifier = @"Cell1";
    BYLogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"BYLogCell" owner:nil options:nil];
        cell = [nibs lastObject];//加载xib的cell
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;//无分割线
        tableView.backgroundColor = [UIColor clearColor];//背景透明
        cell.backgroundColor = [UIColor clearColor];//背景透明
        cell.contentView.backgroundColor = [UIColor clearColor];//背景透明
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//点击状态不变色
        
        //判断是否有数据
        if (self.textTimeArr.count != 0) {
            //有数据,左侧时间从 textTimeArr 取出
            cell.textTimeLab.text = self.textTimeArr[indexPath.row];
            //右侧状态image通过 textStateArr 的 0,1,2判断,储存的时候 0是好,1是一般,2是差
            if ([self.textStateArr[indexPath.row] isEqualToString:@"0.txt1"]) {
                cell.stateImage.image = [UIImage imageNamed:@"zhuangtaijiankang"];
                self.bestCount++;
            }
            if ([self.textStateArr[indexPath.row] isEqualToString:@"1.txt1"]) {
                cell.stateImage.image = [UIImage imageNamed:@"zhuangtaiyiban"];
                self.betterCount++;
            }
            if ([self.textStateArr[indexPath.row] isEqualToString:@"2.txt1"]) {
                cell.stateImage.image = [UIImage imageNamed:@"zhuangtaicha"];
                cell.imageConstraint.constant = 32;
                cell.imageWidth.constant = 62;
                self.goodCount++;
            }
            
            
            
        }else{
            //没有数据展示没有记录
            cell.textTimeLab.text = @"今天没有记录";
            self.stateLab.text = @"无";
            [self.circleView setProgress:0];
        }
        
    }
    //更改进度条和描述状态
    [self changeProStateLab];
    return cell;
}

#pragma mark - 懒加载控件
// 头像按钮
-(UIButton *)headButton{
    if (_headButton == nil) {
        _headButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_CenterX - self.view.frame.size.height * 0.15/2, 75, self.view.frame.size.height * 0.15, self.view.frame.size.height * 0.15)];
        [_headButton setImage:[UIImage imageNamed:@"fenlei"] forState:UIControlStateNormal];
        [_headButton addTarget:self action:@selector(pushPersonalView) forControlEvents:UIControlEventTouchUpInside];
        _headButton.layer.cornerRadius = self.view.frame.size.height * 0.15 / 2;
        _headButton.layer.masksToBounds = YES;
        [_headButton.layer setBorderWidth:2];
        [_headButton.layer setBorderColor:[UIColor blackColor].CGColor];  //设置边框为蓝色
        
    }
    return _headButton;
}

//用户昵称Lab
-(UILabel *)userNameLab{
    if (!_userNameLab) {
        _userNameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 75+self.view.frame.size.height * 0.15+5, kScreen_Width, 20)];
        _userNameLab.font = [UIFont systemFontOfSize:15];
        _userNameLab.textColor = [UIColor whiteColor];
        _userNameLab.textAlignment = NSTextAlignmentCenter;
        _userNameLab.text = [UserObj sharedUser].name;
    }
    return _userNameLab;
}

// 今日评估按钮
-(UIButton *)todayPingguBtn{
    if (_todayPingguBtn == nil) {
        _todayPingguBtn = [[UIButton alloc] initWithFrame:CGRectMake(13, 200 + self.view.frame.size.height * 0.07 + kScreen_Height * 0.2, self.view.frame.size.height * 0.139, self.view.frame.size.height * 0.139 * 0.416)];
        [_todayPingguBtn setImage:[UIImage imageNamed:@"jinrpinggu"] forState:UIControlStateNormal];
//        [_todayPingguBtn addTarget:self action:@selector(pushPersonalView) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _todayPingguBtn;
}

// 日志tableview
-(UITableView *)logTableView{
    if (!_logTableView) {
        _logTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200 + self.view.frame.size.height * 0.07 + kScreen_Height * 0.2 + self.view.frame.size.height * 0.139 * 0.416, kScreen_Width, kScreen_Height - 200 - kScreen_Height * 0.07 - kScreen_Height * 0.2 - kScreen_Height * 0.139 * 0.416 - 49)];
        _logTableView.delegate = self;
        _logTableView.dataSource = self;
    }
    return _logTableView;
}

//背景图片
-(UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        _bgImg.image = [UIImage imageNamed:@"wodebg"];
    }
    return _bgImg;
}


//日历背景view
-(UIView *)clanderView{
    if (!_clanderView) {

        _clanderView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height * 0.07)];
        _clanderView.backgroundColor = [UIColor clearColor];
    }
    return _clanderView;
}

//创建日历控件
-(DIDatepicker *)datepicker{
    if (!_datepicker) {
        
        _datepicker = [[DIDatepicker alloc] initWithFrame:CGRectMake(70, 0, self.clanderView.frame.size.width-70, self.clanderView.frame.size.height)];
        //给每一个日历块添加点击方法
        [_datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
        //当前日期
        NSDate *currentDate = [NSDate date];
        //前200天
        NSDate *sinceDate = [currentDate initWithTimeIntervalSinceNow:-86400*200];
        //总共400天
        [_datepicker fillDatesFromDate:sinceDate numberOfDays:400];
//        [_datepicker fillCurrentMonth];
        //显示第200天
        [_datepicker selectDateAtIndex:200];
    }
    return _datepicker;
}

//日历背景透明图
-(UIImageView *)clanderImaBg{
    if (!_clanderImaBg) {

        _clanderImaBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.clanderView.frame.size.width, self.clanderView.frame.size.height)];
        _clanderImaBg.image = [UIImage imageNamed:@"rlibg"];
        
    }
    return _clanderImaBg;
}

//日历中间竖着的黑线
-(UIView *)clanderCutView{
    if (!_clanderCutView) {
        
        _clanderCutView = [[UIView alloc] initWithFrame:CGRectMake(70, 5, 1, self.clanderView.frame.size.height-10)];
        _clanderCutView.backgroundColor = RGB(52, 52, 52);
        
    }
    return _clanderCutView;
}

//日期Lab
-(UILabel *)dayLab{
    if (!_dayLab) {
        _dayLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, self.view.frame.size.height * 0.07/2)];
        _dayLab.textAlignment = NSTextAlignmentCenter;
        _dayLab.font = [UIFont systemFontOfSize:13];
        _dayLab.textColor = RGB(52, 52, 52);
        UITapGestureRecognizer *tapRecognizerWeibo=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentZheCalander)];
        
        _dayLab.userInteractionEnabled=YES;
        [_dayLab addGestureRecognizer:tapRecognizerWeibo];
    }
    return _dayLab;
}

//月份Lab
-(UILabel *)monLab{
    if (!_monLab) {
        _monLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.07/2, 70, self.view.frame.size.height * 0.07/2)];
        _monLab.textAlignment = NSTextAlignmentCenter;
        _monLab.font = [UIFont systemFontOfSize:13];
        _monLab.textColor = RGB(52, 52, 52);
//        //给Lab添加手势
        UITapGestureRecognizer *tapRecognizerWeibo=[[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(presentZheCalander)];
        //让Lab可以和用户交互
        _monLab.userInteractionEnabled=YES;
        //给Lab添加手势
        [_monLab addGestureRecognizer:tapRecognizerWeibo];
        
    }
    return _monLab;
}

//半圆进度条
-(MLMCircleView *)circleView{
    if (!_circleView) {
        //创建一个半圆进度条表示得分情况
        _circleView = [[MLMCircleView alloc] initWithFrame:CGRectMake(kScreen_Width/2 - kScreen_Height * 0.2 / 2,210 + self.view.frame.size.height * 0.07,kScreen_Height * 0.2,kScreen_Height * 0.2) startAngle:140 endAngle:400];
        _circleView.bottomWidth = 5;
        _circleView.progressWidth = 5;
        _circleView.fillColor = RGB(208, 187, 129);
        _circleView.bgColor = RGB(212, 217, 222);
        _circleView.dotDiameter = 20;
        _circleView.edgespace = 5;
        [_circleView drawProgress];
        
    }
    return _circleView;
}
//状态评分Lab
-(UILabel *)stateLab{
    if (!_stateLab) {
        //状态评分Lab
        _stateLab = [[UILabel alloc] initWithFrame:CGRectMake(self.circleView.frame.size.width/2-30, self.circleView.frame.size.height/2-25, 60, 40)];
        _stateLab.text = @"良好";
        _stateLab.textColor = RGB(246, 219, 140);
        _stateLab.font = [UIFont systemFontOfSize:28];
        _stateLab.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLab;
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
