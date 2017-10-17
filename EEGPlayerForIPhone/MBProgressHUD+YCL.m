//
//  MBProgressHUD+YCL.m
//  HUD
//
//  Created by Chenglin Yu on 3/15/15.
//  Copyright (c) 2015 yclzone. All rights reserved.
//

#import "MBProgressHUD+YCL.h"

@implementation MBProgressHUD (YCL)
+ (MBProgressHUD *)showMessage:(NSString *)message
                          icon:(NSString *)iconName
                        toView:(UIView *)view
                 dimBackground:(BOOL)dim
                hideAfterDelay:(NSTimeInterval)time {
    
    if (!view) {
        // 如果未指定视图，默认显示到主窗口上
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [self showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    if (iconName) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", iconName]]];
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = dim;
    [hud hide:YES afterDelay:time];
    return hud;
}

+ (void)showText:(NSString *)text {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:text icon:nil toView:nil dimBackground:NO hideAfterDelay:1.0];
    });
}

+ (void)showText:(NSString *)text hideAfterDelay:(NSTimeInterval)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:text icon:nil toView:nil dimBackground:NO hideAfterDelay:time];
    });
}

+ (void)showSuccess:(NSString *)successString {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:successString icon:@"success" toView:nil dimBackground:NO hideAfterDelay:1.0];
    });
}

+ (void)showSuccess:(NSString *)successString hideAfterDelay:(NSTimeInterval)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:successString icon:@"success" toView:nil dimBackground:NO hideAfterDelay:time];
    });
}

+ (void)showError:(NSString *)errorString {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:errorString icon:@"error" toView:nil dimBackground:NO hideAfterDelay:1.0];
    });

}

+ (void)showError:(NSString *)errorString hideAfterDelay:(NSTimeInterval)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:errorString icon:@"error" toView:nil dimBackground:NO hideAfterDelay:time];
    });
}

+ (instancetype)showWhileExecuting:(NSString *)message {
    MBProgressHUD *hud = [self showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = message;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    return hud;
}

@end
