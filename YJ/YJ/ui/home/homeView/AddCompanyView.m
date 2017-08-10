//
//  AddCompanyView.m
//  YJ
//
//  Created by xubojoy on 2017/7/4.
//  Copyright © 2017年 xubojoy. All rights reserved.
//

#import "AddCompanyView.h"

@implementation AddCompanyView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"AddCompanyView" owner:self options:nil][0];
        self.frame = frame;
        [self initUI];
    }
    return self;
    
}

- (void)initUI{
    self.companyNameField = [[UITextField alloc] initWithFrame:CGRectMake(84, 20, screen_width-84-general_margin, 40)];
    self.companyNameField.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.companyNameField];
    
    self.companyCodeField = [[UITextField alloc] initWithFrame:CGRectMake(84, 80, screen_width-84-general_margin, 40)];
    self.companyCodeField.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.companyCodeField];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
