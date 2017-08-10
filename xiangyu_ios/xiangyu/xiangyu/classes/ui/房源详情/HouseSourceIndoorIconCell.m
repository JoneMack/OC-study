//
//  HouseSourceIndoorIconCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/8/5.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseSourceIndoorIconCell.h"
#import "HouseInfo.h"

@implementation HouseSourceIndoorIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


-(void) renderData:(NSString *)iconName{
    self.name.text = iconName;
    if ([iconName containsString:@"智能灯"]) {
        self.icon.image = [UIImage imageNamed:@"zhinengdeng"];
        
    }else if ([iconName containsString:@"智能门锁"]){
        self.icon.image = [UIImage imageNamed:@"zhinengshuo"];
    
    }else if ([iconName containsString:@"wifi"]){
        self.icon.image = [UIImage imageNamed:@"wifi"];
    }
    else if ([iconName containsString:@"空调"]){
        self.icon.image = [UIImage imageNamed:@"kongtiao"];
    }
    else if ([iconName containsString:@"热水器"]){
        self.icon.image = [UIImage imageNamed:@"reshuiqi"];
    }
    else if ([iconName containsString:@"冰箱"]){
        self.icon.image = [UIImage imageNamed:@"bingxinag"];
    }
    else if ([iconName containsString:@"洗衣机"]){
        self.icon.image = [UIImage imageNamed:@"xiyiji"];
    }
    else if ([iconName containsString:@"微波炉"]){
        self.icon.image = [UIImage imageNamed:@"weibolu"];
    }
    else if ([iconName containsString:@"饮水机"]){
        self.icon.image = [UIImage imageNamed:@"yinshuiji"];
    }
    else if ([iconName containsString:@"电视"]){
        self.icon.image = [UIImage imageNamed:@"tv"];
    }
    else if ([iconName containsString:@"衣柜"]){
        self.icon.image = [UIImage imageNamed:@"yigui"];
    }
    else if ([iconName containsString:@"鞋柜"]){
        self.icon.image = [UIImage imageNamed:@"xiegui"];
    }
    else if ([iconName containsString:@"收纳柜"]){
        self.icon.image = [UIImage imageNamed:@"shounaxiang"];
    }
    else if ([iconName containsString:@"沙发"]){
        self.icon.image = [UIImage imageNamed:@"shafa"];
    }else if ([iconName containsString:@"床"]){
        self.icon.image = [UIImage imageNamed:@"chuang"];
    }else if ([iconName containsString:@"床笠"]){
        self.icon.image = [UIImage imageNamed:@"chuangli"];
    }else if ([iconName containsString:@"书桌"]){
        self.icon.image = [UIImage imageNamed:@"shuzhuo"];
    }else if ([iconName containsString:@"椅子"]){
        self.icon.image = [UIImage imageNamed:@"yizi"];
    }else if ([iconName containsString:@"餐桌"]){
        self.icon.image = [UIImage imageNamed:@"canzhuo"];
    }else if ([iconName containsString:@"餐椅"]){
        self.icon.image = [UIImage imageNamed:@"canyi"];
    }else if ([iconName containsString:@"星晴"]){
        self.icon.image = [UIImage imageNamed:@"xingqing"];
    }else if ([iconName containsString:@"夏朵"]){
        self.icon.image = [UIImage imageNamed:@"xiaduo"];
    }else if ([iconName containsString:@"摩卡"]){
        self.icon.image = [UIImage imageNamed:@"moka"];
    }else if ([iconName containsString:@"罗曼"]){
        self.icon.image = [UIImage imageNamed:@"luoman"];
    }else if ([iconName containsString:@"阳光"]){
        self.icon.image = [UIImage imageNamed:@"yangguang"];
    }
    else{
        self.icon.image = [UIImage imageNamed:@"kabu"];
    }
}

@end
