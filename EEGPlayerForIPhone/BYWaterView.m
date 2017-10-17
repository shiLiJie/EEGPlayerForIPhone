//
//  BYWaterView.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/5.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYWaterView.h"

@implementation BYWaterView

//重写drawrect方法
- (void)drawRect:(CGRect)rect {
    
    // 半径
    CGFloat rabius = 60;
    // 开始角
    CGFloat startAngle = 0;
    // 中心点
    CGPoint point = CGPointMake(100, 100);  // 中心店我手动写的,你看看怎么弄合适 自己在搞一下
    // 结束角
    CGFloat endAngle = 2*M_PI;
    //路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:rabius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    //添加路径 下面三个同理
    layer.path = path.CGPath;
    //描边色
    layer.strokeColor = [UIColor redColor].CGColor;
    //填充色
    layer.fillColor = [UIColor clearColor].CGColor;
    
    layer.masksToBounds = YES;
    layer.cornerRadius = 6.0;
    layer.borderWidth = 1.0;
    layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [self.layer addSublayer:layer];
    
}

@end
