//
//  MyPatientHeader.m
//  DrAssistant
//
//  Created by hi on 15/9/13.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyPatientHeader.h"

@implementation MyPatientHeader

+ (instancetype)patientHeader
{
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MyPatientHeader" owner:nil options:nil];
    return [arr lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.addPatient.tag = AdPatientTag;
    self.qunFaXiaoXi.tag = qunFaXiaoXiTag;
    self.myQunLiao.tag = myQunLiaoTag;
    self.yuYueButton.tag = yuYueTag;
    self.clubButton.tag = clubTag;
//    self.clubButton.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(myPatientHeaderBtnAction:)]) {
        [_delegate myPatientHeaderBtnAction: sender];
    }
}
- (IBAction)creatNewgroupAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(creatNewGroupForGroupList)]) {
        [_delegate creatNewGroupForGroupList];
    }
}

@end
