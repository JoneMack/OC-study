//
//  AboutUsBodyView.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/4.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "AboutUsBodyView.h"

@implementation AboutUsBodyView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"AboutUsBodyView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
        
        self.blockView.layer.masksToBounds = YES;
        self.blockView.layer.cornerRadius = 10;
        
        [self.copyrightLabel setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
        
    }
    return self;
}

-(void) renderAppInfo:(AppInfo *)appInfo
{
    NSLog(@">>>>>>>>>>>>>>>>>>>%@",appInfo.appInfo);
    self.serviceLabel.text = appInfo.appInfo;
    self.versionNum.text = [NSString stringWithFormat:@"V%@" , [AppStatus sharedInstance].appVersion];
}

@end
