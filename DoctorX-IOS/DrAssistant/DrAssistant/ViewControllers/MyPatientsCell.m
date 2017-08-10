//
//  MyPatientsCellTableViewCell.m
//  DrAssistant
//
//  Created by hi on 15/9/2.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyPatientsCell.h"

@implementation MyPatientsCell

+ (instancetype)patientCell
{
    return [[[NSBundle mainBundle] loadNibNamed: @"MyPatientsCell" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    // Initialization code
    self.avtarImageView.layer.cornerRadius = self.avtarImageView.frame.size.width/2;
    self.avtarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
