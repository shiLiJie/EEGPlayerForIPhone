//
//  BYSheetPickerView.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/6.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width

#import "BYSheetPickerView.h"

@interface BYSheetPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak,nonatomic)UIView *bgView;    //屏幕下方看不到的view
@property (weak,nonatomic)UILabel *titleLabel; //中间显示的标题lab
@property (weak, nonatomic) UIPickerView *pickerView;
@property (weak,nonatomic)UIButton *cancelButton;
@property (weak,nonatomic)UIButton *doneButton;
@property (strong,nonatomic)NSArray *dataArray;   // 用来记录传递过来的数组数据
@property (strong,nonatomic)NSArray *dataArray1;   // 用来记录传递过来的数组数据
@property (strong,nonatomic)NSArray *dataArray2;   // 用来记录传递过来的数组数据
@property (strong,nonatomic)NSString *headTitle;  //传递过来的标题头字符串
@property (strong,nonatomic)NSString *backString; //回调的字符串
@property (strong,nonatomic)NSString *str1; //回调的字符串
@property (strong,nonatomic)NSString *str2; //回调的字符串
@property (strong,nonatomic)NSString *str3; //回调的字符串
@property (assign,nonatomic)NSInteger compent; //列数

@end
@implementation BYSheetPickerView

+(instancetype)BYSheetStringPickerWithTitle:(NSArray *)title andHeadTitle:(NSString *)headTitle Andcall:(BYSheetPickerViewBlock)callBack compent:(NSInteger)compent title1:(NSArray *)title1 title12:(NSArray *)title2 dismiss:(BYSheetPickerViewDismissBlock)dismiss
{
    BYSheetPickerView *pickerView = [[BYSheetPickerView alloc]initWithFrame:[UIScreen mainScreen].bounds  andTitle:title andHeadTitle:headTitle compent:compent title1:title1 title12:title2];
    pickerView.callBack = callBack;
    pickerView.dismissBack = dismiss;
    
    return pickerView;
}

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSArray*)title andHeadTitle:(NSString *)headTitle compent:(NSInteger)compent title1:(NSArray *)title1 title12:(NSArray *)title2
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = title;
        self.dataArray1 = title1;
        self.dataArray2 = title2;
        self.str1 = title[self.dataArray.count/2-1];
        self.str2 = title1[self.dataArray1.count/2-1];
        self.str3 = title2[self.dataArray2.count/2-1];
        _headTitle = headTitle;
        if (compent == 0) {
            _backString = self.dataArray[self.dataArray.count/2-1];
        }
        if (compent == 1) {
            _backString = [NSString stringWithFormat:@"%@-%@",self.dataArray[self.dataArray.count/2-1],self.dataArray1[self.dataArray1.count/2-1]];
        }
        if (compent == 2) {
            _backString = [NSString stringWithFormat:@"%@-%@-%@",self.dataArray[self.dataArray.count/2-1],self.dataArray1[self.dataArray1.count/2-1],self.dataArray2[self.dataArray2.count/2-1]];
        }
        _compent = compent;
        [self setupUI];
    }
    return self;
}

- (void)tap
{
    [self dismissPicker];
}
-(void)setupUI
{
    //首先创建一个位于屏幕下方看不到的view
    UIView* bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    bgView.alpha = 0.0f;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [bgView addGestureRecognizer:g];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:bgView];
    self.bgView = bgView;
    
    //  标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width/2-75, 5, 150, 30)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:_headTitle];
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(2, 5, KScreenWidth*0.2, 30);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"取消" attributes:
                                      @{ NSForegroundColorAttributeName: [UIColor grayColor],
                                         NSFontAttributeName :           [UIFont systemFontOfSize:14],
                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    //完成按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(KScreenWidth-KScreenWidth*0.2-2, 5, KScreenWidth*0.2, 30);
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"完成" attributes:
                                       @{ NSForegroundColorAttributeName: [UIColor grayColor],
                                          NSFontAttributeName :           [UIFont systemFontOfSize:14],
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [doneButton setAttributedTitle:attrString2 forState:UIControlStateNormal];
    doneButton.adjustsImageWhenHighlighted = NO;
    doneButton.backgroundColor = [UIColor clearColor];
    [doneButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
    self.doneButton = doneButton;
    
    //选择器
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(5,30, SCREEN_SIZE.width-10, 230)];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    if (_compent == 0) {
        [pickerView selectRow:self.dataArray.count/2-1 inComponent:0 animated:NO];
    }
    if (_compent == 2) {
        [pickerView selectRow:self.dataArray.count/2-1 inComponent:0 animated:NO];
        [pickerView selectRow:self.dataArray1.count/2-1 inComponent:1 animated:NO];
        [pickerView selectRow:self.dataArray2.count/2-1 inComponent:2 animated:NO];
    }

    
    //self
    self.backgroundColor = [UIColor whiteColor];
    [self setFrame:CGRectMake(0, SCREEN_SIZE.height-300, SCREEN_SIZE.width , 300)];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self setFrame: CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , 250)];
}



- (void)clicked:(UIButton *)sender
{
    if ([sender isEqual:self.cancelButton]) {
        self.dismissBack();
        [self dismissPicker];
    }else{
        if (self.callBack) {
            self.callBack(self,_backString);
        }
    }
}


#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return self.compent+1;
}

#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.dataArray.count;
    }
    if (component == 1) {
        return self.dataArray1.count;
    }
    return self.dataArray2.count;
}

#pragma mark - 该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return self.dataArray[row];
//}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //这个属性可以控制 标题栏。
    //    self.titleLabel.text =self.dataArray[row];
    
    if (_compent == 0) {
        _str1 = self.dataArray[row];
        _backString = [NSString stringWithFormat:@"%@",_str1];
    }
    
    if (_compent == 2) {
        if (component == 0) {
            _str1 = self.dataArray[row];
            _backString = [NSString stringWithFormat:@"%@-%@-%@",_str1,_str2,_str3];
        }
        if (component == 1) {
            _str2 = self.dataArray1[row];
            _backString = [NSString stringWithFormat:@"%@-%@-%@",_str1,_str2,_str3];
        }
        if (component == 2) {
            _str3 = self.dataArray2[row];
            _backString = [NSString stringWithFormat:@"%@-%@-%@",_str1,_str2,_str3];
        }
    }
    
    
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (component == 0) {
        UILabel* l = [[UILabel alloc] init];
        l.textColor = self.textColor;
        l.textAlignment = NSTextAlignmentCenter;
        l.text = self.dataArray[row];
        return l;
    }
    if (component == 1) {
        UILabel* l = [[UILabel alloc] init];
        l.textColor = self.textColor;
        l.textAlignment = NSTextAlignmentCenter;
        l.text = self.dataArray1[row];
        return l;
    }
    UILabel* l = [[UILabel alloc] init];
    l.textColor = self.textColor;
    l.textAlignment = NSTextAlignmentCenter;
    l.text = self.dataArray2[row];
    return l;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (void)show
{
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        self.bgView.alpha = 1.0;
        
        self.frame = CGRectMake(0, SCREEN_SIZE.height-250, SCREEN_SIZE.width, 250);
    } completion:NULL];
}

- (void)dismissPicker
{
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        self.bgView.alpha = 0.0;
        self.frame = CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , 250);
        
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    self.dismissBack();
}

@end
