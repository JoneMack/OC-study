//
//  CustomIconTextCell.h
//  styler
//
//  Created by wangwanggy820 on 14-3-6.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomIconTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (strong, nonatomic) UIView *spliteView;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImgView;


@property (weak, nonatomic) IBOutlet UILabel *remindDotLab;


-(void) renderUI:(UIImage *)iconImg contentTxt:(NSString *)contentTxt showSpliteView:(BOOL)show contentColor:(UIColor *)color;

@end
