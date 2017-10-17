//
//  BYHeadCell.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/18.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYHeadCell.h"
#import "ImagePicker.h"
#import "SJAvatarBrowser.h"

@interface BYHeadCell()


@end

@implementation BYHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImageBtn.layer.cornerRadius = 40;
    
    self.headImageBtn.layer.masksToBounds = YES;
    
    [self.headImageBtn.layer setBorderWidth:2];
    
    [self.headImageBtn.layer setBorderColor:[UIColor blackColor].CGColor];  //设置边框为蓝色
}

- (IBAction)changeHeadImage:(UIButton *)sender {
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:sender.frame];
//    image.backgroundColor = [UIColor blueColor];
    image.image = sender.imageView.image;
    [self addSubview:image];
    
    NSNotification *notification = [NSNotification notificationWithName:@"PICKHEADIMAGE" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [SJAvatarBrowser showImage:image];//调用方法
    image.image = sender.imageView.image;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
