//
//  ZhuanjiaCell.m
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ZhuanjiaCell.h"

@implementation ZhuanjiaCell
- (void)awakeFromNib {
    // Initialization code
    self.avtarImageView.layer.cornerRadius = self.avtarImageView.frame.size.width/2;
    self.avtarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(addFriedAction:)]) {
        [_delegate addFriedAction:self];
    }
}

- (IBAction)addDoctor:(id)sender {
}
@end
