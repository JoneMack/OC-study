//
//  SelectDateTimePicker.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectDateTimePickerDelegate <NSObject>

-(void) selectedVal:(NSDate *)time;

@end


@interface SelectDateTimePicker : UIView 

@property (nonatomic , strong) UIView *controlView;
@property (nonatomic , strong) UIButton *confirmBtn;
@property (nonatomic , strong) UIButton *cancelBtn;

@property (nonatomic , strong) UIDatePicker *datePicker;

@property (nonatomic , weak) id<SelectDateTimePickerDelegate> delegate;


-(void) showSelf; // 在屏幕上显示自身view

-(void) fillMinuteInterval:(int) minuteInterval; // 设置最小间隔时间，该间隔要能够让60整除。默认间隔是一分钟


@end
