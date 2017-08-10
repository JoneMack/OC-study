//
//  UserHdcCell.m
//  styler
//
//  Created by wangwanggy820 on 14-7-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserHdcCell.h"
#import "UILabel+Custom.h"
#import "HdcStore.h"

#define red_envelope_label_left_margin     3
@implementation UserHdcCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"UserHdcCell" owner:self options:nil] objectAtIndex:0];
        
    }
    return self;
}

-(void)render:(UserHdc *)card organization:(Organization *)organization withSplite:(BOOL)withSplite last:(BOOL)last{
    [self.hdcIconImgView setImageWithURL:[NSURL URLWithString:card.iconUrl] placeholderImage:nil options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    
    self.userHdc = card;
    
    self.priceLabel.textColor = [ColorUtils colorWithHexString:red_color];
    
    self.priceLabel.text = [card getPaymentAmountTxt];
    self.priceLabel.font = [UIFont boldSystemFontOfSize:big_font_size];
    
    self.hdcTitleLabel.text = [NSString stringWithFormat:@"%@",card.title];
    self.hdcTitleLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.hdcTitleLabel.font = [UIFont boldSystemFontOfSize:big_font_size];
    
    if (organization != nil) {
        self.organizationNameLabel.text = [NSString stringWithFormat:@"%@", organization.name];
    }
    self.organizationNameLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.organizationNameLabel.font = [UIFont systemFontOfSize:small_font_size];
    
    
    self.dateLabel.font = [UIFont systemFontOfSize:small_font_size];
    self.dateLabel.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
    self.dateLabel.text = [card timeNoteString];
    float organizationNameLabelWidth = self.hdcTitleLabel.realWidth;
    float x = self.hdcTitleLabel.frame.origin.x + organizationNameLabelWidth + red_envelope_label_left_margin;
    CGRect frame = self.redEnvelopeLabel.frame;
    frame.origin.x = x;
    self.redEnvelopeLabel.frame = frame;
    if (self.userHdc.hasUsedRedEnvelope && self.userHdc.orderItemStatus != user_card_status_unpayment && self.userHdc.getRedEnvelopeAmount>0 ) {  //使用了红包且不是未付款的订单
        
        self.redEnvelopeLabel.text = [NSString stringWithFormat:@"￥%d红包" , [self.userHdc getRedEnvelopeAmount]];
        self.redEnvelopeLabel.textColor = [ColorUtils colorWithHexString:red_color];
        self.redEnvelopeLabel.font = [UIFont systemFontOfSize:10];
        [self.redEnvelopeLabel setHidden:NO];
    }else{
        [self.redEnvelopeLabel setHidden:YES];
    }

    
    
    if (card.orderItemStatus == user_card_status_unpayment ) {
        self.hdcStatusLabel.hidden = YES;
        self.cancelBtn.hidden = NO;
    }else{
        
        CALayer *layer  = self.hdcStatusLabel.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:2];
        self.cancelBtn.hidden=YES;
        self.hdcStatusLabel.hidden = NO;
        self.hdcStatusLabel.backgroundColor = [self getStatusBgColor:card];
        self.hdcStatusLabel.textAlignment = NSTextAlignmentCenter;
        self.hdcStatusLabel.text = [card orderItemStatusTxt];
        self.hdcStatusLabel.textColor = [UIColor whiteColor];
        self.hdcStatusLabel.font = [UIFont systemFontOfSize:smaller_font_size];
    }
    
    if (self.spliteView) {
        [self.spliteView removeFromSuperview];
    }
    if (withSplite) {
        self.spliteView = [UIView new];
        if (last) {
            self.spliteView.frame = CGRectMake(0, user_hdc_cell_height-splite_line_height, self.frame.size.width, splite_line_height);
        }else{
            self.spliteView.frame = CGRectMake(general_padding, user_hdc_cell_height-splite_line_height, self.frame.size.width - general_margin, splite_line_height);
        }
        self.spliteView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [self.contentView addSubview:self.spliteView];
    }
}

-(UIColor *) getStatusBgColor:(UserHdc *)card{
    UIColor *result = nil;
    switch (card.orderItemStatus) {
        case 0:
            result = [ColorUtils colorWithHexString:orange_text_color];
            break;
        case 1:
            result = [ColorUtils colorWithHexString:light_gray_text_color];
            break;
        case 2:
            result = [ColorUtils colorWithHexString:green_background_color];
            break;
        case 3:
            result = [ColorUtils colorWithHexString:lighter_gray_text_color];
            break;
        case 4:
            result = [ColorUtils colorWithHexString:lighter_gray_text_color];
            break;
        case 5:
            result = [ColorUtils colorWithHexString:blue_color];
            break;
            
        default:
            break;
    }
    return result;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
