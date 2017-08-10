//
//  AboutUsBodyView.h
//  icaixun
//
//  Created by 冯聪智 on 15/8/4.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineDashView.h"
#import "AppInfo.h"

@interface AboutUsBodyView : UIView


@property (strong, nonatomic) IBOutlet UIView *blockView;

@property (strong, nonatomic) IBOutlet UILabel *serviceLabel;

@property (strong, nonatomic) IBOutlet UILabel *versionNum;
@property (strong, nonatomic) IBOutlet UILabel *copyrightLabel;


@property (strong, nonatomic) LineDashView *dashLine;


- (instancetype) initWithFrame:(CGRect)frame;
-(void) renderAppInfo:(AppInfo *)appInfo;


@end
