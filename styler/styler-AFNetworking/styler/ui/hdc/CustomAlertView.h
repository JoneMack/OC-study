//
//  CustomAlertView.h
//  styler
//
//  Created by wangwanggy820 on 14-8-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView
{

    UIView *bg;
    UIView *preView;
}

-(id) initWithFrame:(CGRect)frame titleText:(NSString *)titleText contentText:(NSString *)contentText;

@end
