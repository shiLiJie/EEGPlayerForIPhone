//
//  Created by Dmitry Ivanenko on 15.04.14.
//  Copyright (c) 2014 Dmitry Ivanenko. All rights reserved.
//

#import "DIDatepickerDateView.h"


const CGFloat kDIDatepickerItemWidth = 46.;
const CGFloat kDIDatepickerSelectionLineWidth = 51.;


@interface DIDatepickerDateView ()


@property (nonatomic, strong) UIView *selectionView;



@end


@implementation DIDatepickerDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setupViews];

    return self;
}

- (void)setupViews
{
    [self addTarget:self action:@selector(dateWasSelected) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setDate:(NSDate *)date
{
    _date = date;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [dateFormatter stringFromDate:date];

//    [dateFormatter setDateFormat:@"EEE"];
//    NSString *dayInWeekFormattedString = [dateFormatter stringFromDate:date];

//    [dateFormatter setDateFormat:@"MMMM"];
//    NSString *monthFormattedString = [[dateFormatter stringFromDate:date] uppercaseString];

//    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@\n%@", dayFormattedString, [dayInWeekFormattedString uppercaseString], monthFormattedString]];
    
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", dayFormattedString]];

    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:13],
                                NSForegroundColorAttributeName: [UIColor blackColor]
                                }
                        range:NSMakeRange(0, dayFormattedString.length)];

//    [dateString addAttributes:@{
//                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:8],
//                                NSForegroundColorAttributeName: [UIColor blackColor]
//                                }
//                        range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];
//
//    [dateString addAttributes:@{
//                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:8],
//                                NSForegroundColorAttributeName: [UIColor colorWithRed:153./255. green:153./255. blue:153./255. alpha:1.]
//                                }
//                        range:NSMakeRange(dateString.string.length - monthFormattedString.length, monthFormattedString.length)];
//
//    if ([self isWeekday:date]) {
//        [dateString addAttribute:NSFontAttributeName
//                           value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:8]
//                           range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@",dayFormattedString];
    self.dateLabel.font = [UIFont systemFontOfSize:13];
    
    

    

}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;

    self.selectionView.alpha = (int)_isSelected;
    if (self.selectionView.alpha == 1) {
        //选中
        self.dateLabel.textColor = RGB(247, 223, 147);
        
        
    }else{
        //没选中
        self.dateLabel.textColor = RGB(52, 52, 52);
        //没选中的里面标记出来当前日期
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSString *currentTime = [dateFormatter1 stringFromDate:[NSDate date]];
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        
        [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
        NSString *current1 = [dateFormatter2 stringFromDate:_date];
        
        
        if ([currentTime isEqualToString:current1]) {
            _dateLabel.textColor = RGB(247, 223, 147);
            NSLog(@"===============");
        }
    }
    
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.numberOfLines = 1;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
    }

    return _dateLabel;
}

- (UIView *)selectionView
{
    if (!_selectionView) {
        _selectionView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 25) / 2, self.frame.size.height - 7, 25, 3)];
        _selectionView.alpha = 0;
        _selectionView.backgroundColor = [UIColor colorWithRed:242./255. green:93./255. blue:28./255. alpha:1.];
        [self addSubview:_selectionView];
    }

    return _selectionView;
}

- (void)setItemSelectionColor:(UIColor *)itemSelectionColor
{
    self.selectionView.backgroundColor = itemSelectionColor;
    
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
//        self.selectionView.alpha = self.isSelected ? 1 : .5;
        
    } else {
//        self.selectionView.alpha = self.isSelected ? 1 : 0;
        self.dateLabel.textColor = RGB(247, 223, 147);
    }
}


#pragma mark Other methods

- (BOOL)isWeekday:(NSDate *)date
{
    NSInteger day = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:date] weekday];

    const NSInteger kSunday = 1;
    const NSInteger kSaturday = 7;

    BOOL isWeekdayResult = day == kSunday || day == kSaturday;

    return isWeekdayResult;
}

- (void)dateWasSelected
{
    self.isSelected = YES;

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
