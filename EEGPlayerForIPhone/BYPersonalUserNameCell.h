//
//  BYPersonalUserNameCell.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/27.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYPersonalUserNameCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstrain;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end
