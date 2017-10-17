//
//  BYSheetPickerView.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/6.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYSheetPickerView;
//回调  pickerView 回传类本身 用来做调用 销毁动作
//     choiceString  回传选择器 选择的单个条目字符串
typedef void(^BYSheetPickerViewBlock)(BYSheetPickerView *pickerView,NSString *choiceString);
typedef void(^BYSheetPickerViewDismissBlock)();

@interface BYSheetPickerView : UIView

@property (nonatomic,copy)BYSheetPickerViewBlock callBack;
@property (nonatomic,copy)BYSheetPickerViewDismissBlock dismissBack;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;


//单条选择器
//废弃
//+(instancetype)BYSheetStringPickerWithTitle:(NSArray *)title andHeadTitle:(NSString *)headTitle Andcall:(BYSheetPickerViewBlock)callBack;

//支持一列或多列
//compent = 列数 - 1
//+(instancetype)BYSheetStringPickerWithTitle:(NSArray *)title andHeadTitle:(NSString *)headTitle Andcall:(BYSheetPickerViewBlock)callBack compent:(NSInteger)compent title1:(NSArray *)title1 title12:(NSArray *)title2;

+(instancetype)BYSheetStringPickerWithTitle:(NSArray *)title andHeadTitle:(NSString *)headTitle Andcall:(BYSheetPickerViewBlock)callBack compent:(NSInteger)compent title1:(NSArray *)title1 title12:(NSArray *)title2 dismiss:(BYSheetPickerViewDismissBlock)dismiss;


//显示
-(void)show;
//销毁类
-(void)dismissPicker;
@end
