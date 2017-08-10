//
//  ZhuanJiaDetailHeader.m
//  DrAssistant
//
//  Created by hi on 15/9/7.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ZhuanJiaDetailHeader.h"

@implementation ZhuanJiaDetailHeader

+ (instancetype)initWithNib
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ZhuanJiaDetailHeader" owner:nil options:nil];
    
    return [arr firstObject];
}

- (void)awakeFromNib
{
    self.zaixianlianxi.tag = ZaiXianLianXiTag;
    self.menZhenYuYue.tag = menZhenYuYueTag;
//    self.menZhenYuYue.hidden = YES;
}

- (IBAction)btnAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector: @selector(ZhuanJiaDetailHeaderAction:)]) {
        [_delegate ZhuanJiaDetailHeaderAction: sender];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
