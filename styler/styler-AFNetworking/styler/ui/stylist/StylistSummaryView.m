//
//  StylistSummaryView.m
//  styler
//
//  Created by System Administrator on 14-1-20.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "StylistSummaryView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Custom.h"
#import "NSStringUtils.h"

@implementation StylistSummaryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStylist:(Stylist *)stylist frame:(CGRect)frame{
    self = [[[NSBundle mainBundle]loadNibNamed:@"StylistSummaryView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
        self.stylist = stylist;
        //渲染发型师头像
        [self.avatar setImageWithURL:[NSURL URLWithString:self.stylist.avatarUrl] placeholderImage:[UIImage imageNamed:@"stylist_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
        [self.avatar addStrokeBorderWidth:0 cornerRadius:self.avatar.frame.size.height/2 color:nil];
        [self.avatar setUserInteractionEnabled:YES];
        //渲染发型师的文字信息
        self.nickNameLab.text = self.stylist.nickName;
        [self.nickNameLab setTextColor:[ColorUtils colorWithHexString:black_text_color]];
        [self.nickNameLab setFont:[UIFont boldSystemFontOfSize:big_font_size]];
        CGSize nickNameSize = [self.nickNameLab.text sizeWithFont:self.nickNameLab.font constrainedToSize:CGSizeMake(96, 20) lineBreakMode:NSLineBreakByCharWrapping];
        CGRect nickNameFrame = CGRectMake(self.nickNameLab.frame.origin.x, self.nickNameLab.frame.origin.y, nickNameSize.width, nickNameSize.height);
        self.nickNameLab.frame = nickNameFrame;
        //评价平均信息
        [self.scoreView updateStarStatus:[stylist.expertTotalCount getAverageScore] viewMode:evaluation_score_view_mode_view];
        if (nickNameSize.width > [@"四个汉字" sizeWithFont:self.nickNameLab.font constrainedToSize:CGSizeMake(screen_width, 3000) lineBreakMode:NSLineBreakByWordWrapping].width) {
            CGRect frame = self.scoreView.frame;
            frame.origin.x = [self.nickNameLab rightX] +general_padding/2;
            self.scoreView.frame = frame;
        }
        if (stylist.offdays != nil && stylist.offdays.count>0 && [NSStringUtils isNotBlank:stylist.offdaysStr] ) {
            self.offDaysLab.text = [NSString stringWithFormat:@"休息日：%@",stylist.offdaysStr];
            self.offDaysLab.font = [UIFont systemFontOfSize:small_font_size];
            self.offDaysLab.textColor = [ColorUtils colorWithHexString:black_text_color];
        }else{
            self.nickNameLab.frame = CGRectMake(self.nickNameLab.frame.origin.x, (75-21)/2, self.nickNameLab.frame.size.width, self.nickNameLab.frame.size.height);
            self.scoreView.frame = CGRectMake(self.scoreView.frame.origin.x, (75-14)/2, self.scoreView.frame.size.width, self.scoreView.frame.size.height);
//            self.scoreLabel.frame = CGRectMake(self.scoreLabel.frame.origin.x, 42, self.scoreLabel.frame.size.width, self.scoreLabel.frame.size.height);
//            self.rightArrowImgView.frame = CGRectMake(self.rightArrowImgView.frame.origin.x, 22, self.rightArrowImgView.frame.size.width, self.rightArrowImgView.frame.size.height);
        }
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

@end
