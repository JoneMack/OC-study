//
//  RewardActivityOverView.m
//  styler
//
//  Created by wangwanggy820 on 14-9-12.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "RewardActivityOverView.h"

@implementation RewardActivityOverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"RewardActivityOverView" owner:self options:nil] objectAtIndex:0];
//        self.bounds = [UIApplication sharedApplication].keyWindow.bounds;
        self.frame = [[UIApplication sharedApplication].keyWindow frame];
        self.backgroundColor = [ColorUtils colorWithHexString:gray_text_color alpha:0.4];
        
        self.rewardActivityOverRemindView.center = [[UIApplication sharedApplication].keyWindow center];
        self.rewardActivityOverRemindView.backgroundColor = [ColorUtils colorWithHexString:light_gray_2_color];
        CALayer *layer  = self.rewardActivityOverRemindView.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:5.0];
        
        self.activityOverRemindContentLab.backgroundColor = [UIColor clearColor];
        self.activityOverRemindContentLab.textColor = [ColorUtils colorWithHexString:red_color];
        self.activityOverRemindContentLab.font = [UIFont systemFontOfSize:bigger_font_size];
        self.activityOverRemindContentLab.numberOfLines = 0;

        self.activityOverRemindContentLab.text = @"  红包木有了，下次手快点儿。";
        self.activityOverRemindContentLab.textAlignment = NSTextAlignmentCenter;
        
        self.closeBtn.backgroundColor = [ColorUtils colorWithHexString:red_select_color];
        [self.closeBtn setTitleColor:[ColorUtils colorWithHexString:white_text_color] forState:UIControlStateNormal];
        self.closeBtn.titleLabel.font = [UIFont systemFontOfSize:bigger_font_size];
        CALayer *btnlayer  = self.closeBtn.layer;
        [btnlayer setMasksToBounds:YES];
        [btnlayer setCornerRadius:5.0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)closeBtnclick:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.rewardActivityOverRemindView.frame;
        frame.origin.y = -self.rewardActivityOverRemindView.frame.size.height;
        self.rewardActivityOverRemindView.frame = frame;
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [self removeFromSuperview];
        [SVProgressHUD dismiss];
    }];
}

-(NSString *)getPageName{
    return page_name_reward_activity_over;
}

@end
