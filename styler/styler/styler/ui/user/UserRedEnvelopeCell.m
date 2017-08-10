//
//  UserRedEnvelopeCell.m
//  styler
//
//  Created by System Administrator on 14-8-25.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UserRedEnvelopeCell.h"
#import "UILabel+Custom.h"

#define amount_and_name_space 5
#define select_icon_x  285
@implementation UserRedEnvelopeCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([UserRedEnvelopeCell class]) owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

-(void)render:(RedEnvelope *)redEnvelope withSplite:(BOOL)withSplite last:(BOOL)last showRedEnvelopeStatusFlag:(BOOL)showRedEnvelopeStatusFlag{
    //渲染金额
    self.amountLabel.text = [NSString stringWithFormat:@"%d元", redEnvelope.amount];
    self.amountLabel.textColor = [ColorUtils colorWithHexString:red_default_color];
    self.amountLabel.font = [UIFont boldSystemFontOfSize:bigger_font_size];
    
    //渲染红包名称
    float amountLabelWidth = self.amountLabel.realWidth;
    float x = self.amountLabel.frame.origin.x + amountLabelWidth + amount_and_name_space;
    CGRect frame = self.nameLabel.frame;
    frame.origin.x = x;
    self.nameLabel.frame = frame;
    self.nameLabel.font = self.amountLabel.font;
    self.nameLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
    
    
    //渲染使用时间
    self.timeNoteLabel.text = redEnvelope.getTimeNoteTxt;
    self.timeNoteLabel.textColor = [ColorUtils colorWithHexString:light_gray_text_color];
    self.timeNoteLabel.font = [UIFont systemFontOfSize:small_font_size];
    
    if (showRedEnvelopeStatusFlag) {
       
        //渲染状态
        self.statusLabel.text = redEnvelope.getStatusTxt;
        self.statusLabel.textColor = [ColorUtils colorWithHexString:white_text_color];
        self.statusLabel.font = [UIFont systemFontOfSize:small_font_size];
        switch (redEnvelope.status) {
            case red_envelope_status_bind:
            case red_envelope_status_locked:
                self.statusLabel.backgroundColor = [ColorUtils colorWithHexString:green_background_color];
                break;
            case red_envelope_status_used:
                self.statusLabel.backgroundColor = [ColorUtils colorWithHexString:orange_text_color];
                break;
            case red_envelope_status_expired:
                self.statusLabel.backgroundColor = [ColorUtils colorWithHexString:lighter_gray_text_color];
                break;
            default:
                break;
        }
        CALayer *layer  = self.statusLabel.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:2];
    
    }
    if (self.spliteView) {
        [self.spliteView removeFromSuperview];
    }
    if (withSplite) {
        self.spliteView = [UIView new];
        if (last) {
            self.spliteView.frame = CGRectMake(0, user_red_envelope_cell_height-splite_line_height, self.frame.size.width, splite_line_height);
        }else{
            self.spliteView.frame = CGRectMake(general_padding, user_red_envelope_cell_height-splite_line_height, self.frame.size.width - general_margin, splite_line_height);
        }
        self.spliteView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [self.contentView addSubview:self.spliteView];
    }
    
    
    if (self.selectImgView == nil) {
        self.selectImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sex_icon_select"]];
    }
    float y = (user_red_envelope_cell_height - self.selectImgView.image.size.width)/2;
    self.selectImgView.frame = CGRectMake(select_icon_x, y, self.selectImgView.image.size.width, self.selectImgView.image.size.width);
    [self.contentView addSubview:self.selectImgView];
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
