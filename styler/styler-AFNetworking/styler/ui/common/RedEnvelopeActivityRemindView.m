//
//  RemindGetRedEnvelopeView.m
//  styler
//
//  Created by wangwanggy820 on 14-9-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define animate

#import "RedEnvelopeActivityRemindView.h"
#import "RedEnvelopeCardView.h"
#import "ShareSDKProcessor.h"

@implementation RedEnvelopeActivityRemindView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithShareContent:(ShareContent *)shareContent activityDescription:(NSString *)activityDescription amount:(int)amount{
    self = [super init];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"RedEnvelopeActivityRemindView" owner:self options:nil] objectAtIndex:0];
        
        CALayer *layer  = self.remindView.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:5.0];
        self.bounds = [UIApplication sharedApplication].keyWindow.bounds;
        self.backgroundColor = [ColorUtils colorWithHexString:gray_text_color alpha:0.4];
        self.remindView.backgroundColor = [ColorUtils colorWithHexString:light_gray_2_color];
        
        self.remindContentLab.backgroundColor = [UIColor clearColor];
        self.remindContentLab.textColor = [ColorUtils colorWithHexString:red_color];
        self.remindContentLab.font = [UIFont systemFontOfSize:big_font_size];
        self.remindContentLab.textAlignment = NSTextAlignmentCenter;
        self.remindContentLab.numberOfLines = 0;
//        self.remindContentLab.text = activityDescription;
        int start = [activityDescription rangeOfString:[NSString stringWithFormat:@"%d",amount]].location;
        int length = [activityDescription rangeOfString:[NSString stringWithFormat:@"%d",amount]].length;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:activityDescription];
        [attributedText addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:biggest_font_size]
                               range:NSMakeRange(start, length)];
        self.remindContentLab.attributedText = attributedText;

        
        self.confirmBtn.backgroundColor = [ColorUtils colorWithHexString:red_select_color];
        [self.confirmBtn setTitleColor:[ColorUtils colorWithHexString:white_text_color] forState:UIControlStateNormal];
        self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:bigger_font_size];
        CALayer *btnlayer  = self.confirmBtn.layer;
        [btnlayer setMasksToBounds:YES];
        [btnlayer setCornerRadius:5.0];
        
        self.shareContent = shareContent;
    }
    return self;

}

- (void)cancelRemindRedEnvelopeView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.remindView.frame;
        frame.origin.y = -self.remindView.frame.size.height;
        self.remindView.frame = frame;
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [self removeFromSuperview];
    }];
}

-(IBAction)shareImmediately:(id) sender{
    ShareSDKProcessor *shareSDKProcessor = [[ShareSDKProcessor alloc] init];
    [shareSDKProcessor followWeiXinTimeLine:sender shareContent:self.shareContent shareSuccessBlock:^{
        
        ShareSceneType *shareSceneType = [[ShareSceneType alloc] initWithType:self.shareContent.shareContentType sharedChannelType:ShareTypeWeixiTimeline];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_user_shared_success_show_reward_activity
                                                            object:shareSceneType];
        [self removeFromSuperview];
    }];
    
    AppStatus *as = [AppStatus sharedInstance];
    NSMutableString *content = [NSMutableString new];
    if (as.logined) {
        [content appendString:as.user.name];
    }
    if ([content length] == 0) {
        [content appendString:@"未登录用户"];
    }
    if (self.shareContent.shareContentType == shareOrganizationPage) {
        [content appendString:@"---分享机构"];
    }else if (self.shareContent.shareContentType == shareStylistPage) {
        [content appendString:@"---分享发型师"];
    }else if (self.shareContent.shareContentType == shareStylistWorkPage) {
        [content appendString:@"---分享发型师作品"];
    }
    [MobClick event:log_event_share_immediately attributes:[NSDictionary dictionaryWithObjectsAndKeys:content, @"立即分享",nil]];
    
}

-(NSString *)getPageName{
    return page_name_reward_activity_remind;
}

@end
