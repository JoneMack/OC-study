//
//  SelectLiveFlagCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/7/21.
//  Copyright © 2016年 相寓. All rights reserved.
//


#define live_flag_selected    1010
#define live_flag_unselect    1011

#import "SelectLiveFlagCell.h"

@implementation SelectLiveFlagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lineView setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
    
    [self.liveFlagBtn setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)selectEvent:(id)sender {
    
    if(self.tag == live_flag_selected){
        [self setTag:live_flag_unselect];
        [self.liveFlagBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
       
    }else{
        [self setTag:live_flag_selected];
        [self.liveFlagBtn setImage:[UIImage imageNamed:@"selected_purple"] forState:UIControlStateNormal];
    }
}

-(NSString *) getStatus{
    if(self.tag == live_flag_selected){
        return @"1";
    }else{
        return @"";
    }
}

@end
