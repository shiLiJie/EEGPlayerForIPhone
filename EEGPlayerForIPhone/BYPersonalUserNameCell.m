//
//  BYPersonalUserNameCell.m
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/9/27.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import "BYPersonalUserNameCell.h"
#import "UserObj.h"
#import "UserTool.h"

@implementation BYPersonalUserNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameField.delegate = self;
    
    self.nameField.tintColor = [UIColor blackColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserName) name:@"GETUSERNAME" object:nil];
}

-(void)getUserName{
//    UserObj *obj = [UserObj sharedUser];
//    obj.name = self.nameField.text;
//    [UserTool saveTheUserInfo:obj];
//    NSLog(@"%@",self.nameField.text);
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.nameField.text,@"name", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"POSTUSERNAME" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSInteger lenth = [textField.text length];
    if (lenth == 0) {
        self.leftConstrain.constant = 0;
    }else{
        self.leftConstrain.constant = kScreen_Width-15 -20 - lenth * 16;
    }
//    UserObj *obj = [UserObj sharedUser];
//    obj.name = textField.text;
//    [UserTool saveTheUserInfo:obj];
    
    
    NSNotification *notification = [NSNotification notificationWithName:@"ISEDIT" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self.nameField resignFirstResponder];
    self.leftConstrain.constant  = 0;
    
//    UserObj *obj = [UserObj sharedUser];
//    obj.name = textField.text;
//    [UserTool saveTheUserInfo:obj];
    
    return YES;
}

//textfield代理
-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    //取出输入进的字符长度
    NSInteger lenth = [textField.text length];
    //更改距离左边的约束
    self.leftConstrain.constant = kScreen_Width-15 -20- (lenth +1) * 16;
    
    return YES;
}

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    id view = [super hitTest:point withEvent:event];
//    if (![view isKindOfClass:[UITextField class]]) {
//        [self endEditing:YES];
//        self.leftConstrain.constant  = 0;
//        return self;
//    }else{
//        return view;
//    }
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
