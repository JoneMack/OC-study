//
//  PatientDetailTableViewCell.m
//  DrAssistant_FBB
//
//  Created by Seiko on 15/9/30.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "PatientDetailTableViewCell.h"

@implementation PatientDetailTableViewCell

+ (instancetype)patientDetailTableViewCell
{
    return [[[NSBundle mainBundle] loadNibNamed: @"PatientDetailTableViewCell" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
