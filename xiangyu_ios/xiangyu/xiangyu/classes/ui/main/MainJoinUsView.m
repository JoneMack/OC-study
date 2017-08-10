//
//  MainJoinUsView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/12.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainJoinUsView.h"
#import "RentDelegateViewController.h"

@implementation MainJoinUsView

-(instancetype) init
{
    self = [super init];
    if(self){
        self = [[[NSBundle mainBundle] loadNibNamed:@"MainJoinUsView" owner:self options:nil]  objectAtIndex:0];
        [self.titl1 setTextColor:[ColorUtils colorWithHexString:text_color_purple]];
        [self.phone setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray] forState:UIControlStateNormal];
        [self setBackgroundColor:[ColorUtils colorWithHexString:bg_gray]];
        [self.joinUs setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
        self.joinUs.layer.cornerRadius = 15.5;
        self.joinUs.layer.masksToBounds = YES;
        
        self.separatorLine = [[UIView alloc] init];
        [self.separatorLine setBackgroundColor:[ColorUtils colorWithHexString:separator_line_color]];
        self.separatorLine.frame = CGRectMake(0, 122.5, screen_width, splite_line_height);
        [self addSubview:self.separatorLine];
    }
    return self;
}



- (IBAction)weituochuzhu:(id)sender {
    
    RentDelegateViewController * rentDelegateController = [[RentDelegateViewController alloc] init];
    [self.navigationController pushViewController:rentDelegateController animated:YES];
}
@end
