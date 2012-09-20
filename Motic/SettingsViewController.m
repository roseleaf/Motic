//
//  SettingsViewController.m
//  Motic
//
//  Created by Rose CW on 9/19/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsView.h"
@interface SettingsViewController (){

}
@property (strong)SettingsView* settingsView;

-(void)setAlarmOneButtonPressed;
-(void)cancelAlarmButtonOne;
-(void)setAlarmTwoButtonPressed;
@end


@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settingsView = [SettingsView new];
    self.view = self.settingsView;
    [self.settingsView.alarmOneSet addTarget:self action:@selector(setAlarmOneButtonPressed) forControlEvents:UIControlEventTouchDown];    
    [self.settingsView.alarmTwoSet addTarget:self action:@selector(setAlarmTwoButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.settingsView.alarmCancel addTarget:self action:@selector(cancelAlarmButtonOne) forControlEvents:UIControlEventTouchDown];
    
}

-(void)presentMessage:(NSString *)message{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Motic" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)scheduleNotificationWithDate:(NSDate*)fireFate {
    UILocalNotification* firstAlarm = [UILocalNotification new];
    firstAlarm.fireDate = fireFate;
    firstAlarm.alertBody = @"How's it going? Time to send in a Motic.";
    firstAlarm.soundName = UILocalNotificationDefaultSoundName;
    firstAlarm.repeatInterval = kCFCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:firstAlarm];
}

-(void)setAlarmOneButtonPressed{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
        
    [self scheduleNotificationWithDate:self.settingsView.timePickerOne.date];
    [self presentMessage:@"Reminder set"];
}

-(void)cancelAlarmButtonOne{
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [self presentMessage:@"Reminders cancelled. Reset them anytime."];
}
-(void)setAlarmTwoButtonPressed{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    [self scheduleNotificationWithDate:self.settingsView.timePickerTwo.date];
    [self presentMessage:@"Reminder set"];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
