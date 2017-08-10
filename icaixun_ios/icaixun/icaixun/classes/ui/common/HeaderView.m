//
//  HeaderView.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/15.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#define common_header_btn_width     50

#import "HeaderView.h"
#import "AppDelegate.h"
#import "AccountSessionSpringBoard.h"
#import "PayViewController.h"
#import "SystemStore.h"
#import "SystemPromptController.h"

@implementation HeaderView


-(id) initWithTitle:(NSString *)titleStr navigationController:(UINavigationController *)navigationController
{
    self = [super init];
    if (self) {
        // header view
        self = [[[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil] objectAtIndex:0];
        self.backgroundColor = [UIColor clearColor];
        self.nc = navigationController;
        
        // title
        [self.title setText:titleStr];
        
        // other btn
        self.otherBtn.hidden = YES;
        
        // 返回按钮
        UIImage *arrowBack = [UIImage imageNamed:@"icon_goback"];
        [self.backBut setImage:arrowBack forState:UIControlStateNormal];
        self.backBut.imageView.frame = CGRectMake(10, 10, 10, 10);
//          
//        [self.title setBackgroundColor:[UIColor yellowColor]];
//        [self.backBut setBackgroundColor:[UIColor redColor]];
//        [self.otherBtn setBackgroundColor:[UIColor blueColor]];
        
        [self.backBut addTarget:self action:@selector(popToFrontViewController:) forControlEvents:UIControlEventTouchUpInside];
        [self initFrame];
    }
    return self;
}

-(void) initFrame
{
    CGRect backButFrame = CGRectMake(0, status_bar_height, common_header_btn_width, 40);
    CGRect titleFrame = CGRectMake(common_header_btn_width, status_bar_height, screen_width - common_header_btn_width*2, 40);
    CGRect otherBtnFrame = CGRectMake(screen_width - common_header_btn_width, status_bar_height,
                                      common_header_btn_width, 40);
    
    if (CURRENT_SYSTEM_VERSION >= 7) {
        titleFrame.origin.y = status_bar_height;     // y轴从20开始
        backButFrame.origin.y = status_bar_height;   // y轴从20开始
        otherBtnFrame.origin.y = status_bar_height;
    }else{
        titleFrame.origin.y = 0;                           // y轴从0开始
        backButFrame.origin.y = 0;                     // y轴从0开始
        otherBtnFrame.origin.y = 0;
    }
    self.title.frame = titleFrame;
    self.backBut.frame = backButFrame;
    self.otherBtn.frame = otherBtnFrame;
    self.frame = CGRectMake(0, 0, screen_width, status_bar_height + navigation_height);
    
}

#pragma mark 渲染 other 按钮
-(void) renderOtherBtn:(HeaderOtherBtnType)otherBtnType
{
    if (otherBtnType == pay) {
        [self.otherBtn setTitle:@"充值" forState:UIControlStateNormal];
        [self.otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.otherBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        self.otherBtn.hidden = NO;
        self.otherBtn.tag = pay;
        [self.otherBtn addTarget:self action:@selector(otherHandler) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark 处理 other按钮点击事件
-(void) otherHandler
{
    if (self.otherBtn.tag == pay) {
        [[SystemStore sharedInstance] getAppInfo:^(AppInfo *appInfo, NSError *err) {

            if ([appInfo.pay isEqualToString:@"false"]) {
                SystemPromptController *promptController = [[SystemPromptController alloc] init];
                promptController.appInfo = appInfo;
                [self.nc pushViewController:promptController animated:YES];
            }else{
                PayViewController *payController = [[PayViewController alloc] init];
                [self.nc pushViewController:payController animated:YES];
            }
        }];
    }
}

-(void) popToFrontViewController:(id)sender
{
    if (self.needPop2Root == YES) {
        [self.nc popToRootViewControllerAnimated:NO];
    }else{
        [self.nc popViewControllerAnimated:YES];
    }
    
}





@end
