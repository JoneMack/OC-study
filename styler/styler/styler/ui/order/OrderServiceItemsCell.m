//
//  OrderServiceItemsCell.m
//  styler
//
//  Created by wangwanggy820 on 14-4-10.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrderServiceItemsCell.h"

@implementation OrderServiceItemsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[NSBundle mainBundle] loadNibNamed:@"OrderServiceItemsCell" owner:self options:nil][0];
        self.backgroundColor = [UIColor clearColor];
        //服务订单说明
        self.serviceOrderDescription.font = [UIFont systemFontOfSize:default_font_size];
        //原价上面的线
        self.lineOnTheOriginPrice.backgroundColor = [ColorUtils colorWithHexString:gray_text_color];
        CGRect lineFrame = self.lineOnTheOriginPrice.frame;
        lineFrame.size.height = splite_line_height;
        self.lineOnTheOriginPrice.frame = lineFrame;
        //预定价
        self.orderPrice.font = [UIFont systemFontOfSize:default_font_size];

    }
    return self;
}

-(void)renderOrderServiceItems:(OrderServiceItem *)orderServiceItem{
    self.orderServiceItem = orderServiceItem;
    [self renderOrderServiceDescription];
    [self renderOrderServiceLineOnTheOriginPrice];
    [self renderOrderServicePrice];
}

-(void)renderOrderServiceDescription
{
    NSString *text = [self.orderServiceItem getServiceOrderItemDescription];
    text = [NSString stringWithFormat:@"%@%@\n",text,self.orderServiceItem.serviceItemName];
    int length1 = text.length;
    text = [NSString stringWithFormat:@"%@原价 ￥%d",text,self.orderServiceItem.price];
    int length2 = text.length;
    text = [NSString stringWithFormat:@"%@ %@",text,[self.orderServiceItem getServiceOrderItemSpecialOfferDescription]];
    int length3 = text.length;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    //文字颜色
    UIColor *color1 = [ColorUtils colorWithHexString:gray_text_color];
    UIColor *color2 = [ColorUtils colorWithHexString:black_text_color];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(0,length1)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(length1,length2 - length1)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(length2,length3 - length2)];
    //文字大小和字体
    UIFont *font1 = [UIFont systemFontOfSize:default_font_size];
    UIFont *font2 = [UIFont boldSystemFontOfSize:default_font_size];
    [attributeStr addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(0, length1)];
    [attributeStr addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(length1, length2 -length1)];
    [attributeStr addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(length2, length3 -length2)];
    self.serviceOrderDescription.attributedText = attributeStr;
}

-(void)renderOrderServiceLineOnTheOriginPrice
{
    NSString *text = [NSString stringWithFormat:@"原价 ￥%d",self.orderServiceItem.price];
    CGSize size = [text sizeWithFont:self.serviceOrderDescription.font];
    CGRect frame = self.lineOnTheOriginPrice.frame;
    frame.size.width = size.width;
    self.lineOnTheOriginPrice.frame = frame;
}

-(void)renderOrderServicePrice
{
    NSString *text = @"预订价 ";
    int length = text.length;
    text = [NSString stringWithFormat:@"%@￥%d",text,self.orderServiceItem.specialOfferPrice];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
    //文字颜色
    UIColor *color1 = [ColorUtils colorWithHexString:gray_text_color];
    UIColor *color2 = [ColorUtils colorWithHexString:black_text_color];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0,length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(length,text.length - length)];
    //文字大小和字体
    UIFont *font1 = [UIFont systemFontOfSize:default_font_size];
    UIFont *font2 = [UIFont boldSystemFontOfSize:default_font_size];
    [attributeStr addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, length)];
    [attributeStr addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(length, text.length -length)];
    self.orderPrice.attributedText = attributeStr;
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
