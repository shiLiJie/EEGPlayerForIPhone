//
//  UILabel+LabelHeightAndWidth.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/12.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LabelHeightAndWidth)

/**
 *  Lab自适应高度
 *
 *  @param width 填lab.frame.size.width
 *  @param title 标题
 *  @param font  字体大小
 *
 *  @return 得到自适应之后的实际高度height
 */
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;


/**
 *  Lab自适应宽度
 *
 *  @param title 标题
 *  @param font  字体
 *
 *  @return 得到自适应之后的实际宽度width
 */
+ (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font;

@end
