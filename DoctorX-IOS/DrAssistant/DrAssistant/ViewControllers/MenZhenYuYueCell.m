//
//  MenZhenYuYueCell.m
//  DrAssistant
//
//  Created by hi on 15/9/8.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MenZhenYuYueCell.h"

@implementation MenZhenYuYueCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)rightNowYuYue:(id)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(goYuYueBtnAction:)]) {
        [_delegate goYuYueBtnAction:sender];
    }
}

@end
