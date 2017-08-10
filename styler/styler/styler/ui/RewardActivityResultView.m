//
//  ReceiveRedEnvelopeView.m
//  styler
//
//  Created by wangwanggy820 on 14-9-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "RewardActivityResultView.h"
#import "ShareSDKProcessor.h"
#import "RewardActivity.h"
#define tel_text_field_height    38

@implementation RewardActivityResultView
{
    int redEnvelopeSeedAmount;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithReceiveDesc:(NSString *)receiveDesc amount:(int)perAmount secondRedEnvelopeSeedId:(int)secondRedEnvelopeSeedId{
    self = [super init];
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"RewardActivityResultView" owner:self options:nil] objectAtIndex:0];
        
        self.bounds = [UIApplication sharedApplication].keyWindow.bounds;
        self.backgroundColor = [ColorUtils colorWithHexString:gray_text_color alpha:0.4];
        
        CALayer *layer  = self.redEnvelopeView.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:5.0];
        
        
        self.titleLab.textColor = [ColorUtils colorWithHexString:white_text_color];
        self.titleLab.numberOfLines = 0;
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.font = [UIFont systemFontOfSize:bigger_font_size];
        int start = [receiveDesc rangeOfString:[NSString stringWithFormat:@"%d", perAmount]].location;
        int length = [receiveDesc rangeOfString:[NSString stringWithFormat:@"%d",perAmount]].length;
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:receiveDesc];
        [attributedText addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:biggest_font_size]
                               range:NSMakeRange(start, length)];
        self.titleLab.attributedText = attributedText;

        self.receiveBtn.backgroundColor = [ColorUtils colorWithHexString:red_select_color];
        CALayer *btnlayer  = self.receiveBtn.layer;
        [btnlayer setMasksToBounds:YES];
        [btnlayer setCornerRadius:5.0];
        self.receiveBtn.titleLabel.font = [UIFont systemFontOfSize:bigger_font_size];
        [self.receiveBtn setTitleColor:[ColorUtils colorWithHexString:white_text_color] forState:UIControlStateNormal];
        [self.receiveBtn addTarget:self action:@selector(shareToWeiXinTimeLine:) forControlEvents:UIControlEventTouchUpInside];
        
        self.frame = [[UIApplication sharedApplication].keyWindow frame];
        self.redEnvelopeView.center = [[UIApplication sharedApplication].keyWindow center];
        
        redEnvelopeSeedAmount = perAmount;
        self.seedId = secondRedEnvelopeSeedId;
    }
    return self;
}

-(void)shareToWeiXinTimeLine:(id)sender{
    AppStatus *as = [AppStatus sharedInstance];
//    NSString *content = [NSString stringWithFormat:@"我给你发了%d元美发红包，快来抢！",redEnvelopeSeedAmount];
    NSString *content = [NSString stringWithFormat:@"我发了%d个时尚猫红包，美发可以省很多！快来抢！" , as.rewardActivityUserShareRedEnvelopeCount] ;
    
    NSString *url = [NSString stringWithFormat:@"%@/app/redEnvelopeSeeds/%d/movement",as.webPageUrl,self.seedId];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"red_bag_open@2x" ofType:@"png"];
    
    ShareContent *shareContent = [[ShareContent alloc] initWithTitle:@"" content:content sinaWeiBoContent:nil url:url image:nil imageUrl:imagePath shareContentType:0];
    ShareSDKProcessor *shareSDKProcessor = [[ShareSDKProcessor alloc] init];
    [shareSDKProcessor followWeiXinTimeLine:sender shareContent:shareContent shareSuccessBlock:^{
        [self removeFromSuperview:sender];
        
        [SVProgressHUD showSuccessWithStatus:@"分享成功" duration:0.5];
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_reload_table_view object:nil];
        
    }];
}

- (IBAction)removeFromSuperview:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.redEnvelopeView.frame;
        frame.origin.y = -self.redEnvelopeView.frame.size.height;
        self.redEnvelopeView.frame = frame;
    } completion:^(BOOL finished) {
        [self setHidden:YES];
        [self removeFromSuperview];
    }];
}

-(NSString *)getPageName{
    return page_name_reward_activity_get;
}


@end
