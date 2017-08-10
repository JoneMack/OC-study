//
//  FindHouseMoreOtherConditionTableViewCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/16.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "FindHouseMoreOtherConditionTableViewCell.h"

@implementation FindHouseMoreOtherConditionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.duwei setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    [self.duwei.layer setBorderColor:[ColorUtils colorWithHexString:@"595959"].CGColor];
    self.duwei.layer.masksToBounds = YES;
    self.duwei.layer.cornerRadius = 5;
    self.duwei.layer.borderWidth = 0.5;
    [self.duwei addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.duyang setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    [self.duyang.layer setBorderColor:[ColorUtils colorWithHexString:@"595959"].CGColor];
    self.duyang.layer.masksToBounds = YES;
    self.duyang.layer.cornerRadius = 5;
    self.duyang.layer.borderWidth = 0.5;
    [self.duyang addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.shouzu setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    [self.shouzu.layer setBorderColor:[ColorUtils colorWithHexString:@"595959"].CGColor];
    self.shouzu.layer.masksToBounds = YES;
    self.shouzu.layer.cornerRadius = 5;
    self.shouzu.layer.borderWidth = 0.5;
    [self.shouzu addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.xuequfang setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    [self.xuequfang.layer setBorderColor:[ColorUtils colorWithHexString:@"595959"].CGColor];
    self.xuequfang.layer.masksToBounds = YES;
    self.xuequfang.layer.cornerRadius = 5;
    self.xuequfang.layer.borderWidth = 0.5;
    [self.xuequfang addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.nearDitie setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    [self.nearDitie.layer setBorderColor:[ColorUtils colorWithHexString:@"595959"].CGColor];
    self.nearDitie.layer.masksToBounds = YES;
    self.nearDitie.layer.cornerRadius = 5;
    self.nearDitie.layer.borderWidth = 0.5;
    [self.nearDitie addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.chaonan setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    [self.chaonan.layer setBorderColor:[ColorUtils colorWithHexString:@"595959"].CGColor];
    self.chaonan.layer.masksToBounds = YES;
    self.chaonan.layer.cornerRadius = 5;
    self.chaonan.layer.borderWidth = 0.5;
    [self.chaonan addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.separatorLine = [[UIView alloc] init];
    [self.separatorLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color ]];
    self.separatorLine.frame = CGRectMake(0, 0, screen_width, splite_line_height);
    [self addSubview:self.separatorLine];
    
}

-(void) changeStatus:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 0){
        btn.tag = 1;
        [btn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        btn.tag = 0;
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    }
}


-(void) renderData:(NSMutableArray *) searchTab{
    
    if(searchTab != nil && searchTab.count >0){
        if([searchTab containsObject:@"isToilet"]){
            self.duwei.tag = 1;
            [self.duwei setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
            [self.duwei setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if([searchTab containsObject:@"isbalcony"]){
            self.duyang.tag = 1;
            [self.duyang setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
            [self.duyang setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if([searchTab containsObject:@"isFirstRent"]){
            self.shouzu.tag = 1;
            [self.shouzu setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
            [self.shouzu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if([searchTab containsObject:@"isSchool"]){
            self.xuequfang.tag = 1;
            [self.xuequfang setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
            [self.xuequfang setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if([searchTab containsObject:@"isYerornosubway"]){
            self.nearDitie.tag = 1;
            [self.nearDitie setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
            [self.nearDitie setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        if([searchTab containsObject:@"isSouth"]){
            self.chaonan.tag = 1;
            [self.chaonan setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
            [self.chaonan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    
}


-(void) resetCondition{
    self.duwei.tag = 0;
    [self.duwei setBackgroundColor:[UIColor whiteColor]];
    [self.duwei setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    
    self.duyang.tag = 0;
    [self.duyang setBackgroundColor:[UIColor whiteColor]];
    [self.duyang setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    
    self.shouzu.tag = 0;
    [self.shouzu setBackgroundColor:[UIColor whiteColor]];
    [self.shouzu setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    
    self.xuequfang.tag = 0;
    [self.xuequfang setBackgroundColor:[UIColor whiteColor]];
    [self.xuequfang setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    
    self.nearDitie.tag = 0;
    [self.nearDitie setBackgroundColor:[UIColor whiteColor]];
    [self.nearDitie setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    
    self.chaonan.tag = 0;
    [self.chaonan setBackgroundColor:[UIColor whiteColor]];
    [self.chaonan setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
    
}

-(NSMutableArray *) getSearchTag{
    
    NSMutableArray *searcheTag = [NSMutableArray new];
    
    if(self.duwei.tag != 0){
        [searcheTag addObject:@"isToilet"];
    }
    
    if(self.duyang.tag != 0){
        [searcheTag addObject:@"isbalcony"];
    }
    
    
    if(self.shouzu.tag != 0){
        [searcheTag addObject:@"isFirstRent"];
    }
    
    
    if(self.nearDitie.tag != 0){
        [searcheTag addObject:@"isYerornosubway"];
    }
    
    
    if(self.xuequfang.tag != 0){
        [searcheTag addObject:@"isSchool"];
    }
    
    
    if(self.chaonan.tag != 0){
        [searcheTag addObject:@"isSouth"];
    }
    return searcheTag;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
