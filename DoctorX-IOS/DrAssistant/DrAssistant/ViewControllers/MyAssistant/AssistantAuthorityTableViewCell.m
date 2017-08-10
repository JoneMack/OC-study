//
//  AssistantAuthorityTableViewCell.m
//  DrAssistant
//
//  Created by 刘湘 on 15/9/15.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "AssistantAuthorityTableViewCell.h"

@implementation AssistantAuthorityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)onSwitch:(UISwitch *)sender {
    if ([sender isOn]) {
        sender.on ;
    }
}

@end
