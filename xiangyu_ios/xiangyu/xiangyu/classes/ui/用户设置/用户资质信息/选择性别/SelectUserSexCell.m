//
//  SelectUserSexCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/15.
//  Copyright © 2016年 相寓. All rights reserved.
//

#define btn_selected  1001
#define btn_unselect  1000

#import "SelectUserSexCell.h"

@implementation SelectUserSexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.manBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7)];
    [self.womanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7)];
    [self.lineView setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    [self.manBtn setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
    [self.womanBtn setImage:[UIImage imageNamed:@"unselect_yuan"] forState:UIControlStateNormal];
    self.manBtn.tag = btn_selected;
    self.womanBtn.tag = btn_unselect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)manEvent:(id)sender {
    [self selectMan];
}

- (IBAction)womanEvent:(id)sender {
    [self selectWoman];
}

-(NSString *)getSelectedSex{
    if(self.manBtn.tag == btn_selected){
        return @"男";
    }else{
        return @"女";
    }
}

-(void) selectMan{
    
    [self.manBtn setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
    [self.womanBtn setImage:[UIImage imageNamed:@"unselect_yuan"] forState:UIControlStateNormal];
    self.manBtn.tag = btn_selected;
    self.womanBtn.tag = btn_unselect;
}

-(void) selectWoman{
    
    [self.womanBtn setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
    [self.manBtn setImage:[UIImage imageNamed:@"unselect_yuan"] forState:UIControlStateNormal];
    self.manBtn.tag = btn_unselect;
    self.womanBtn.tag = btn_selected;
}


-(void) renderData:(CustomerInfo *)customerInfo
{
    if (customerInfo != nil && [NSStringUtils isNotBlank:customerInfo.sex]) {
        if([customerInfo.sex isEqualToString:@"男"]){
            [self selectMan];
        }else{
            [self selectWoman];
        }
    }
}

@end
