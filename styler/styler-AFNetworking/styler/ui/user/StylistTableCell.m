//
//  ExpertTableCell.m
//  styler
//
//  Created by System Administrator on 13-5-18.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "StylistTableCell.h"

@implementation StylistTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle]loadNibNamed:@"StylistTableCell" owner:self options:nil] objectAtIndex:0];
        
        self.grayLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        self.grayLine.frame = CGRectMake(10, self.frame.size.height -splite_line_height, self.frame.size.width, splite_line_height);
        
        self.backgroundColor = [UIColor clearColor];
        self.outOfStack.backgroundColor = [UIColor clearColor];
        self.outOfStack.textColor = [UIColor whiteColor];
        self.outOfStack.font = [UIFont boldSystemFontOfSize:default_font_size];
        self.outOfStack.alpha = 0.8;
        
        CALayer *layer  = self.outOfStack.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:2];
        [layer setBorderWidth:1.0f];
        [layer setBorderColor:[UIColor clearColor].CGColor];
        
        
        self.workCount.font = [UIFont systemFontOfSize:small_font_size];
        self.workCount.textColor = [ColorUtils colorWithHexString:gray_text_color];
        self.workCount.textAlignment = NSTextAlignmentRight;

        self.deleteBtn.backgroundColor = [UIColor whiteColor];
        self.deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:default_font_size];
//        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [self.deleteBtn setTitleColor:[ColorUtils colorWithHexString:red_color] forState:UIControlStateNormal];
        
        layer  = self.deleteBtn.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:2];
//        [layer setBorderWidth:1.0f];
//        [layer setBorderColor:[UIColor redColor].CGColor];
        
    }
    return self;
}

-(void)renderStylistInfo:(Stylist *)stylist{
    self.stylistName.text = stylist.nickName;
    self.stylistName.font = [UIFont boldSystemFontOfSize:big_font_size];
    self.stylistName.textColor = [ColorUtils colorWithHexString:black_text_color];
    CGSize nameSize = [self.stylistName.text sizeWithFont:self.stylistName.font constrainedToSize:CGSizeMake(screen_width, 3000) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = self.stylistName.frame;
    frame.size.width = nameSize.width + general_padding/2;
    self.stylistName.frame = frame;
    [self.scoreView updateStarStatus:[stylist.expertTotalCount getAverageScore] viewMode:evaluation_score_view_mode_view];
    self.haircutPriceAndWorkNum.attributedText = [stylist getStylistHairCutPrice];
    CGSize size2 = [[stylist getHairCutSpecialOfferPriceText] sizeWithFont:[UIFont systemFontOfSize:small_font_size] constrainedToSize:CGSizeMake(screen_width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize size3 = [@"剪发" sizeWithFont:[UIFont systemFontOfSize:small_font_size] constrainedToSize:CGSizeMake(screen_width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    frame = self.haircutPriceAndWorkNum.frame;
    frame.size.width = size2.width;
    self.haircutPriceAndWorkNum.frame = frame;
    self.workCount.text = [NSString stringWithFormat:@"  %d个作品",stylist.expertTotalCount.worksCount];
    //原价上面的删除线
    if (self.line == nil) {
        self.line = [[UIView alloc] init];
        CGRect lineFrame = CGRectMake(frame.origin.x + size3.width+1, frame.origin.y + frame.size.height/2, [stylist getSize].width - size3.width, splite_line_height);
        self.line.frame = lineFrame;
        self.line.hidden = YES;
        self.line.backgroundColor = [ColorUtils colorWithHexString:black_text_color];
        [self.contentView addSubview:self.line];
    }
    [self.stylistAvatar setImageWithURL:[NSURL URLWithString:stylist.avatarUrl]placeholderImage:[UIImage imageNamed:@"stylist_default_image_before_load"] options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
    CALayer *layer  = self.stylistAvatar.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:self.stylistAvatar.frame.size.width/2];
    [layer setBorderWidth:1.0f];
    [layer setBorderColor:[UIColor whiteColor].CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
