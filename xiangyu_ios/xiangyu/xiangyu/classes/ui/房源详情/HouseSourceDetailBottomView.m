//
//  HouseSourceDetailBottomView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseSourceDetailBottomView.h"
#import "BookHouseViewController.h"
#import "UserLoginViewController.h"
#import "HouseStore.h"
#import "FillUserInfoViewController.h"


@implementation HouseSourceDetailBottomView

- (instancetype)init
{
    self = [super init];
    if(self){
        [self render];
    }
    return self;
}

-(void) render
{
    self.favBtn = [[UIButton alloc] init];
    [self.favBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.favBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.favBtn setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray]
                      forState:UIControlStateNormal];
    
    [self.favBtn setImage:[UIImage imageNamed:@"star_black"] forState:UIControlStateNormal];
    self.favBtn.frame = CGRectMake(0, 0, screen_width*0.3, 49);
    
    [self addSubview:self.favBtn];
    
    self.qianyueOnline = [[UIButton alloc] init];
    [self.qianyueOnline setTitle:@"在线签约" forState:UIControlStateNormal];
    [self.qianyueOnline.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.qianyueOnline setTitleColor:[ColorUtils colorWithHexString:text_color_deep_gray]
                      forState:UIControlStateNormal];
    [self.qianyueOnline setImage:[UIImage imageNamed:@"note_black"] forState:UIControlStateNormal];
    self.qianyueOnline.frame = CGRectMake(self.favBtn.rightX, 0, screen_width*0.3, 49);
    
    [self addSubview:self.qianyueOnline];
    
    
    self.yuyuekanfang = [[UIButton alloc] init];
    [self.yuyuekanfang setTitle:@"预约看房" forState:UIControlStateNormal];
    [self.yuyuekanfang.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.yuyuekanfang setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
    [self.yuyuekanfang setBackgroundColor:[ColorUtils colorWithHexString:bg_yellow]];
    self.yuyuekanfang.frame = CGRectMake(self.qianyueOnline.rightX, 0, screen_width*0.4, 49);
    
    [self addSubview:self.yuyuekanfang];
    
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(screen_width*0.3, 10, splite_line_height, 29.5)];
    separateLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self addSubview:separateLine];
    
    separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width  , splite_line_height)];
    separateLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [self addSubview:separateLine];
    
    [self bindEvents];
}


-(void) renderData:(HouseInfo *)houseInfo
{
    self.houseInfo = houseInfo;
    if([NSStringUtils isBlank:self.houseInfo.collectionId]){
        [self.favBtn setImage:[UIImage imageNamed:@"star_black"] forState:UIControlStateNormal];
    }else{
        [self.favBtn setImage:[UIImage imageNamed:@"star_yellow_small"] forState:UIControlStateNormal];
    }
    
}

-(void) bindEvents
{
    
    [self.favBtn addTarget:self action:@selector(favHouseSource) forControlEvents:UIControlEventTouchUpInside];
    
    [self.yuyuekanfang addTarget:self action:@selector(showYuyuekanfang) forControlEvents:UIControlEventTouchUpInside];
    
    [self.qianyueOnline addTarget:self action:@selector(showQianyueOnline) forControlEvents:UIControlEventTouchUpInside];
}


-(void) favHouseSource
{
    if (self.houseInfo != nil) {
        if([NSStringUtils isNotBlank:self.houseInfo.collectionId]){
            [self.window makeToast:@"您已收藏该房源" duration:2.0 position:[NSValue valueWithCGPoint:self.window.center]];
        }
        
        AppStatus *as = [AppStatus sharedInstance];
        if([as logined]){
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setObject:self.houseInfo.houseId forKey:@"houseInfoId"];
            [params setObject:self.houseInfo.rentType forKey:@"rentType"];
            [[HouseStore sharedStore] postFavHouseInfo:^(NSError *err) {
                
                if(err == nil){
                    [self.window makeToast:@"收藏成功" duration:2.0 position:[NSValue valueWithCGPoint:self.window.center]];
                    [self.favBtn setImage:[UIImage imageNamed:@"star_yellow_small" ]  forState:UIControlStateNormal];
                }else{
                    [self.window makeToast:@"收藏失败" duration:2.0 position:[NSValue valueWithCGPoint:self.window.center]];
                }
            } param:params];
        }else{
            
            UserLoginViewController *loginController = [[UserLoginViewController alloc] init];
            [self.navigationController pushViewController:loginController animated:YES];
        }
    }
}

/**
 * 在线签约
 */
-(void) showQianyueOnline{
    AppStatus *as = [AppStatus sharedInstance];
    if([as logined]){
        FillUserInfoViewController *fillUserInfoViewController = [[FillUserInfoViewController alloc] init];
        fillUserInfoViewController.houseInfo = self.houseInfo;
        fillUserInfoViewController.house = self.house;
        [self.navigationController pushViewController:fillUserInfoViewController animated:YES];
    }else{
        
        UserLoginViewController *loginController = [[UserLoginViewController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];
    }

}


-(void) showYuyuekanfang
{
    BookHouseViewController *bookHouseController = [[BookHouseViewController alloc] init];
    bookHouseController.houseInfo = self.houseInfo;
    [self.navigationController pushViewController:bookHouseController animated:YES];
}


@end
