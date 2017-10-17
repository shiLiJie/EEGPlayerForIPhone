//
//  MLMCircleView.h
//  MLMProgressView
//
//  Created by my on 16/8/4.
//  Copyright © 2016年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MLMCircleView : UIView{
    CGFloat circleRadius;//bottom半径
    CGFloat progressRadius;//进度半径
    
    CGFloat _progress;//进度
    
    ///起点
    CGFloat _startAngle;
    ///终点
    CGFloat _endAngle;
}

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;

///弧度背景色
@property (nonatomic, strong) UIColor *bgColor;
///弧度填充色
@property (nonatomic, strong) UIColor *fillColor;

///弧度线宽
@property (nonatomic, assign) CGFloat bottomWidth;
@property (nonatomic, assign) CGFloat progressWidth;

///光标的背景图片
@property (nonatomic, strong) UIImage *dotImage;

///光标直径
@property (nonatomic, assign) CGFloat dotDiameter;

///边缘间隔
@property (nonatomic, assign) CGFloat edgespace;

///bottom和progress间隔,相对于bottom
@property (nonatomic, assign) CGFloat progressSpace;

///freeWidth
@property (nonatomic, assign, readonly) CGFloat freeWidth;

///是否圆角,默认YES
@property (nonatomic, assign) BOOL capRound;

- (instancetype)initWithFrame:(CGRect)frame
                   startAngle:(CGFloat)start
                     endAngle:(CGFloat)end;
///设置进度
- (void)setProgress:(CGFloat)progress;

///图片隐藏
- (void)dotHidden:(BOOL)hidden;

///内外线紧邻(默认是覆盖),YES外接
- (void)bottomNearProgress:(BOOL)outOrIn;

///请务必使用绘制
- (void)drawProgress;



@end
