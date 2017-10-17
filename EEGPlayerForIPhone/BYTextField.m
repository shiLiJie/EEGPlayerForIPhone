//
//  BYTextField.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/7/5.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYTextField.h"
#import "UIColor+Extend.h"

@implementation BYTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
    UIColor *colour = [UIColor hexColorWithString:@"71787b"];
    if ([self.placeholder respondsToSelector:@selector(drawInRect:withAttributes:)])
    { // iOS7 and later
        NSDictionary *attributes = @{NSForegroundColorAttributeName: colour, NSFontAttributeName: self.font};
        CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
        [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height/2)-boundingRect.size.height/2) withAttributes:attributes]; }
    else { // iOS 6
        [colour setFill];
        [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
    }
}

@end
