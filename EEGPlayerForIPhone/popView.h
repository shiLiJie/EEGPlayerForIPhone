//
//  popView.h
//  EEGPlayerForIPhone
//
//  Created by 凤凰八音 on 16/6/30.
//  Copyright © 2016年 fenghuangbayin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
typedef void(^SelectPeri)(CBPeripheral *peripheral);
@protocol PopDriverDelegate

-(void)OkChangeView;

@end

@interface popView : UIView
@property (nonatomic, copy) SelectPeri perI;
//@property (strong, nonatomic) SerialGATT *sensor;


@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;
@property (nonatomic, weak) id<PopDriverDelegate>degegate;
@end
