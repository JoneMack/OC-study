//
//  MainHouseSourceCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/8/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainHouseSourceCell.h"

@implementation MainHouseSourceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.name setTextColor:[ColorUtils colorWithHexString:text_color_deep_gray2]];
    [self.name setFont:[UIFont boldSystemFontOfSize:15]];
    [self.address setTextColor:[ColorUtils colorWithHexString:text_color_gray]];
    [self.distance setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    [self.price setTextColor:[ColorUtils colorWithHexString:text_color_orange2]];
    
    [self.tag1.layer setBorderWidth:1];
    self.tag1.layer.masksToBounds = YES;
    self.tag1.layer.cornerRadius = 4;
    [self.tag1.layer setBorderColor:[[ColorUtils colorWithHexString:text_color_orange] CGColor]];
    [self.tag1 setTextColor:[ColorUtils colorWithHexString:text_color_orange]];
    
    [self.tag2.layer setBorderWidth:1];
    self.tag2.layer.masksToBounds = YES;
    self.tag2.layer.cornerRadius = 4;
    [self.tag2.layer setBorderColor:[[ColorUtils colorWithHexString:text_color_blue] CGColor]];
    [self.tag2 setTextColor:[ColorUtils colorWithHexString:text_color_blue]];
    
    [self.tag3.layer setBorderWidth:1];
    self.tag3.layer.masksToBounds = YES;
    self.tag3.layer.cornerRadius = 4;
    [self.tag3.layer setBorderColor:[[ColorUtils colorWithHexString:text_color_red] CGColor]];
    [self.tag3 setTextColor:[ColorUtils colorWithHexString:text_color_red]];
    
    [self.tag4.layer setBorderWidth:1];
    self.tag4.layer.masksToBounds = YES;
    self.tag4.layer.cornerRadius = 4;
    [self.tag4.layer setBorderColor:[[ColorUtils colorWithHexString:text_color_light_purple] CGColor]];
    [self.tag4 setTextColor:[ColorUtils colorWithHexString:text_color_light_purple]];
    
    [self.tag5.layer setBorderWidth:1];
    self.tag5.layer.masksToBounds = YES;
    self.tag5.layer.cornerRadius = 4;
    [self.tag5.layer setBorderColor:[[ColorUtils colorWithHexString:text_color_green] CGColor]];
    [self.tag5 setTextColor:[ColorUtils colorWithHexString:text_color_green]];
    
    [self.separatorLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void) renderData:(House *)house{
    if(house == nil){
        return;
    }
    
    NSLog(@" house : %@" , house);
    self.house = house;
    if(self.house.fmpic != nil && ![self.house.fmpic isEqualToString:@""]){
        [self.img sd_setImageWithURL:[NSURL URLWithString:self.house.fmpic]];
    }
    [self.name setText:[self.house getName]];
    [self.address setText:[self.house getAddressStr]];
    [self.houseStyle setText:[self.house getHouseStyle]];
    
    if([self.house.liveFlg isEqualToString:@"0"]){
        [self.zhibo setHidden:YES];
    }
    
    [self.price setText:house.rentPrice];
    
    
    [self.distance setTitle:[house getDistanceStr] forState:UIControlStateNormal];
    [self.distance setTitle:house.houseId forState:UIControlStateNormal];
    
    NSArray *tabList = self.house.tabList;
    for(int i=0 ; i<tabList.count ; i++){
        if(i== 0){
            [self.tag1 setHidden:NO];
            [self.tag1 setText:self.house.tabList[i]];
        }else if(i== 1){
            [self.tag2 setHidden:NO];
            [self.tag2 setText:self.house.tabList[i]];
        }else if(i== 2){
            [self.tag3 setHidden:NO];
            [self.tag3 setText:self.house.tabList[i]];
        }else if(i== 3){
            [self.tag4 setHidden:NO];
            [self.tag4 setText:self.house.tabList[i]];
        }else if(i== 4){
            [self.tag5 setHidden:NO];
            [self.tag5 setText:self.house.tabList[i]];
            break;
        }
    }
}

-(void) hideDistance
{
    [self.distance setHidden:YES];
}

@end
