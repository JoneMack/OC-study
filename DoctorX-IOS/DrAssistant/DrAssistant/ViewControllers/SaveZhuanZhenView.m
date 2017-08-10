//
//  SaveZhuanZhenView.m
//  DrAssistant
//
//  Created by Seiko on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "SaveZhuanZhenView.h"

@implementation SaveZhuanZhenView
+ (instancetype)saveZhuanZhenView
{
    NSArray *ayy = [[NSBundle mainBundle] loadNibNamed:@"SaveZhuanZhenView" owner:nil options:nil];
    return [ayy lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.searchHospital_Btn.tag = SearchHospitalBtnTag;
    self.searchDoctor_Btn.tag = SearchDoctorBtnTag;
    
}
- (IBAction)selectAeraAndDoc:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(recordZhuanZhenInfoAction:)]) {
        [_delegate recordZhuanZhenInfoAction:sender];
    }
}

@end
