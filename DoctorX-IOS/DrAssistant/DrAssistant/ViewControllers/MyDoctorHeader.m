//
//  MyDoctorHeader.m
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyDoctorHeader.h"

@implementation MyDoctorHeader

+ (instancetype)shareInstance
{
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyDoctorHeader" owner:nil options:nil];
    return [nibs lastObject];
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.MyYuYue.tag = MyYuYueTag;
    self.addDoctorBtn.tag = AddDoctorTag;
    self.FreeZiXun.tag = FreeZiXunTag;
}

- (IBAction)btnAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(MyDoctorHeaderAction:)]) {
        [_delegate MyDoctorHeaderAction:sender];
    }
    
    BLOCK_SAFE_RUN(self.block, sender);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
