//
//  SelectDateTimePicker.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SelectDateTimePicker.h"

@implementation SelectDateTimePicker


-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self renderView:frame];
    }
    return self;
}


-(void) renderView:(CGRect)frame
{
    [self setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.7]];
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.frame = CGRectMake(0, frame.size.height - 150, screen_width, 150);
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    
    self.datePicker.locale = locale;
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    self.datePicker.minimumDate = [NSDate date];
    [self addSubview:self.datePicker];
    
    self.controlView = [[UIView alloc] init];
    self.controlView.frame = CGRectMake(0, frame.size.height - 150-30 , screen_width, 30);
    [self.controlView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.controlView];
    
    self.confirmBtn  = [[UIButton alloc] init];
    self.confirmBtn.frame = CGRectMake(0, 0, 60, 30);
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.controlView addSubview:self.confirmBtn];
    
    [self.confirmBtn addTarget:self action:@selector(confirmEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.cancelBtn  = [[UIButton alloc] init];
    self.cancelBtn.frame = CGRectMake(screen_width-60, 0, 60, 30);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.controlView addSubview:self.cancelBtn];
    [self.cancelBtn addTarget:self action:@selector(cancelEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelf)];
    [self addGestureRecognizer:tapGestureRecognizer];
}


-(void) fillMinuteInterval:(int) minuteInterval;
{
    self.datePicker.minuteInterval = minuteInterval;
}


- (void) confirmEvent {
    
    NSDate *date =  self.datePicker.date;
    
    if([self.delegate respondsToSelector:@selector(selectedVal:)]){
        [self.delegate selectedVal:date];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, screen_height, screen_width, screen_height-64);
    }];
}

-(void) showSelf{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, 64, screen_width, screen_height-64);
    }];
}

-(void) hideSelf{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, screen_height, screen_width, screen_height-64);
    }];
}

-(void) cancelEvent {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, screen_height, screen_width, screen_height-64);
    }];
}



@end
