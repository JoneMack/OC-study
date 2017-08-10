//
//  AddHealthDataCell.m
//  DrAssistant
//
//  Created by hi on 15/9/7.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "AddHealthDataCell.h"

@implementation AddHealthDataCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.textFD.leftView = leftView;
    self.textFD.leftViewMode = UITextFieldViewModeAlways;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
