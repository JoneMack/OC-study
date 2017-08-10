//
//  UserInfoCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/18.
//  Copyright © 2016年 相寓. All rights reserved.
//

#define btn_selected  1001
#define btn_unselect  1000


#import "UserInfoCell.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.man setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7)];
    [self.woman setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.woman setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [self.man setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
    [self.woman setImage:[UIImage imageNamed:@"unselect_yuan"] forState:UIControlStateNormal];
    self.man.tag = btn_selected;
    self.woman.tag = btn_unselect;
    
}


-(void) renderCustomerData:(CustomerInfo *) customerInfo{
    
    if(customerInfo == nil){
        return ;
    }
    self.customerInfo = customerInfo;
    [self.userName setText:self.customerInfo.userName];
    [self.mobile setText:self.customerInfo.mobile];
    [self.idNo setText:self.customerInfo.idNo];
    [self.confirmIdNo setText:self.customerInfo.idNo];
    [self.emergencyContactName setText:self.customerInfo.emergencyContactName];
    [self.emergencyContactPhone setText:self.customerInfo.emergencyContactPhone];
    [self.contactRelation setText:self.customerInfo.contactRelation];
    
    if ([self.customerInfo.sex isEqualToString:@"男"]) {
        [self.man setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
    }else{
        [self.woman setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
    }
    
}


- (IBAction)manEvent:(id)sender {
    [self selectMan];
}

- (IBAction)womanEvent:(id)sender {
    [self selectWoman];
}

-(void) selectMan{
    
    [self.man setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
    [self.woman setImage:[UIImage imageNamed:@"unselect_yuan"] forState:UIControlStateNormal];
    self.man.tag = btn_selected;
    self.woman.tag = btn_unselect;
}

-(void) selectWoman{
    
    [self.woman setImage:[UIImage imageNamed:@"select_yuan"] forState:UIControlStateNormal];
    [self.man setImage:[UIImage imageNamed:@"unselect_yuan"] forState:UIControlStateNormal];
    self.man.tag = btn_unselect;
    self.woman.tag = btn_selected;
}




-(NSString *)getSex{
    if(self.man.tag == btn_selected){
        return @"男";
    }else{
        return @"女";
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
}

@end
