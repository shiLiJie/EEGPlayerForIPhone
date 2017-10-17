//
//  BYLogCell.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/20.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

@end
