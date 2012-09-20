//
//  SettingsView.h
//  Motic
//
//  Created by Rose CW on 9/19/12.
//  Copyright (c) 2012 Rose Trujillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsView : UIScrollView
@property IBOutlet UIDatePicker* timePickerOne;
@property IBOutlet UIDatePicker* timePickerTwo;
@property UIButton* alarmOneSet;
@property UIButton* alarmTwoSet;
@property UIButton* alarmCancel;
@end
