//
//  popView.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/6/30.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "popView.h"
#import "SearchCell.h"
#import "BYBluetoothManager.h"
@interface popView()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *datatable;//设备tabview

@end

@implementation popView

//视图布局
-(void)layoutSubviews
{
    CGRect frame = self.frame;
    frame = kScreen_Frame;
    [self setFrame:frame];
    
    _datatable.layer.cornerRadius = 10;//设置那个圆角的有多圆
    _datatable.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
    _datatable.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
    _datatable.layer.masksToBounds = YES;
    _datatable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//设置UITableView不显示多余的空Cell
    //监听连接的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBlue:) name:@"CONECTBLUE" object:nil];
}

//重写初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"popView" owner:nil options:nil];
    self =[nibView objectAtIndex:0];
    
    UIView *view = nil;
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"popView" owner:self options:nil];
    for (id objdec in arr) {
        if ([objdec isKindOfClass:[UIView class]]) {
            view = objdec;
        }
    }
    //设置代理
    self.datatable.delegate = self;
    self.datatable.dataSource = self;
    
    //添加触摸手势, 消失
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [self addGestureRecognizer:tap];
    //设置代理
    tap.delegate = self;
    
    return self;
}
//手势方法
-(void)removeView
{   //从父视图中移除
    [self removeFromSuperview];
    [self.degegate OkChangeView];
}

//手势代理方法, 在方法里可以判断点击的类型 cell 还是 view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //Tip:我们可以通过打印touch.view来看看具体点击的view是具体是什么名称,像点击UITableViewCell时响应的View则是UITableViewCellContentView.
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;
}

//存放设备的可变数组初始化, 刷新tab
- (void)setPeripheralViewControllerArray:(NSMutableArray *)peripheralViewControllerArray
{
    _peripheralViewControllerArray = peripheralViewControllerArray;
    [self.datatable reloadData];
}

#pragma mark ----- tableview datasouce delegate -----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    //这里先写成 @"1" 测试用, 后来还得改回来, 不然不好使
//    return [self.peripheralViewControllerArray count];
    return self.peripheralViewControllerArray.count;
//        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //使用自定的searchCell
    static NSString *identifier = @"Cell1";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:KCellSearchCell owner:nil options:nil];
        cell = [nibs lastObject];
    }
    NSUInteger row = [indexPath row];
    
    CBPeripheral *peripheral  = [self.peripheralViewControllerArray  objectAtIndex:row];
    //给cell的textlabel赋值
    cell.ShebeiLabel.text = peripheral.name;
    //    cell.ShebeiLabel.text = @"1";
    
    //cell左侧边线不到顶端, 这个方法让线到最左边
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger row = [indexPath row];
    
    CBPeripheral *peripheral  = [self.peripheralViewControllerArray objectAtIndex:row];
    
    [BYBluetoothManager sharedManager].activePeripheral = peripheral;
    
    //选择之后给检测界面发送通知, view不能弹出 只能通知控制器弹出是否确认连接alterview,
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexPath.row],@"indexPath", nil];//需要把选择的indexpath一起传过去,以后要回传用
    NSNotification *notification = [NSNotification notificationWithName:@"NOTIFICATIONLIANJIE" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
@end
