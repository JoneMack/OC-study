//
//  PatientDetialHeader.m
//  DrAssistant_FBB
//
//  Created by Seiko on 15/9/30.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "PatientDetialHeader.h"

@implementation PatientDetialHeader

+ (instancetype)patientDetialHeader
{
    return  [[[NSBundle mainBundle] loadNibNamed:@"PatientDetailHeader" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.phoneLianXiBtn.tag = PhoneTag;
    self.OnLineBtn.tag = OnLineTag;
    
}
- (IBAction)contectWithFriend:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(patientDetialHeaderclickAtbtn:)]) {
        [_delegate patientDetialHeaderclickAtbtn:sender];
    }
}

@end
