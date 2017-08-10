//
//  HeaderView.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/15.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView


@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UIButton *backBut;

@property (strong, nonatomic) IBOutlet UIButton *otherBtn;


@property (assign, nonatomic) BOOL needPop2Root; // 是否需要跳到根路径，如果不是跳到根路径，就返回到上一层

@property (weak, nonatomic) UINavigationController *nc;


-(id) initWithTitle:(NSString *)title navigationController:(UINavigationController *)nc;

#pragma mark 渲染 other btn , 需要的话就渲染，不需要就不用渲染
-(void) renderOtherBtn:(HeaderOtherBtnType)otherBtnType;

@end
