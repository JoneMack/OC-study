//
//  SelectPickerView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/4.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "SelectPickerView.h"

@implementation SelectPickerView


-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self renderView:frame];
    }
    return self;
}

-(void) renderView:(CGRect)frame
{
    [self setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.7]];
    self.pickView = [[UIPickerView alloc] init];
    self.pickView.frame = CGRectMake(0, frame.size.height - 150, screen_width, 150);
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    
    [self.pickView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.pickView];
    
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

-(void) renderParams:(NSArray *)params type:(NSString *)type
{
    self.params = params;
    self.type = type;
    [self.pickView selectRow:0 inComponent:0 animated:NO];
    [self.pickView reloadAllComponents];
    [self showSelf];
}





//=============================  UIPickview ==========================================

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.params.count;
    
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.params[row];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (void) confirmEvent {
    NSInteger chengquRow = [self.pickView selectedRowInComponent:0];
    NSString *val = self.params[chengquRow];
    
    if([self.delegate respondsToSelector:@selector(selectedVal: type:)]){
        [self.delegate selectedVal:val type:self.type];
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
