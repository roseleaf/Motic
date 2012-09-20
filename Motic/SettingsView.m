//
//  SettingsView.m
//  Motic
//
//  Created by Rose CW on 9/19/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*1.6);
        self.scrollEnabled = YES;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homebg.png"]];
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.text = @"When should we ask how you are?";
        titleLabel.backgroundColor = [UIColor clearColor];
        
        
        self.timePickerOne = [UIDatePicker new];
        self.timePickerOne.datePickerMode = UIDatePickerModeTime;
        self.timePickerOne.frame = CGRectMake(0, 55, [UIScreen mainScreen].bounds.size.width, 200);
        self.timePickerTwo = [UIDatePicker new];
        self.timePickerTwo.datePickerMode = UIDatePickerModeTime;
        self.timePickerTwo.frame = CGRectMake(0, 310, [UIScreen mainScreen].bounds.size.width, 200);
        
        self.alarmOneSet = [UIButton buttonWithType:UIButtonTypeCustom];
        self.alarmOneSet.frame = CGRectMake(90, 260, 140, 40);
        self.alarmOneSet.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"longbutton.png"]];
        [self.alarmOneSet setTitle:@"Set Reminder" forState:UIControlStateNormal];
        self.alarmOneSet.titleLabel.textColor = [UIColor whiteColor];
        
        
        self.alarmTwoSet = [UIButton buttonWithType:UIButtonTypeCustom];
        self.alarmTwoSet.frame = CGRectMake(90, 515, 140, 40);
        self.alarmTwoSet.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"longbutton.png"]];
        [self.alarmTwoSet setTitle:@"Set Reminder" forState:UIControlStateNormal];
        self.alarmTwoSet.titleLabel.textColor = [UIColor whiteColor];
        

        UILabel* detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 555, 300, 100)];
        detailLabel.lineBreakMode = UILineBreakModeWordWrap;
        detailLabel.text = @"If you want, we'll remind you to send a motic twice a day to keep track of how you're doing at your current locations.";
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.numberOfLines = 0;
        
        self.alarmCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        self.alarmCancel.frame = CGRectMake(75, 665, 170, 40);
        self.alarmCancel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"longerbutton.png"]];
        [self.alarmCancel setTitle:@"Turn Off Reminders" forState:UIControlStateNormal];
        self.alarmCancel.titleLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:titleLabel];
        [self addSubview:detailLabel];
        [self addSubview:self.timePickerOne];
        [self addSubview:self.timePickerTwo];
        [self addSubview:self.alarmOneSet];
        [self addSubview:self.alarmTwoSet];
        [self addSubview:self.alarmCancel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
