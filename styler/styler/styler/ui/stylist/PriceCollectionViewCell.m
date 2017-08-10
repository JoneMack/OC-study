//
//  PriceCollectionViewCell.m
//  styler
//
//  Created by System Administrator on 14-4-1.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "PriceCollectionViewCell.h"

@implementation PriceCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PriceCollectionViewCell" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}



-(void)renderUI:(StylistServiceItemPrice *)price{
    self.backgroundColor = [UIColor whiteColor];
    
    float lastWidth = 0;
    float lastY = 0;
    for (int i = 0; i < price.serviceConditions.count; i++) {
        UILabel *serviceCondition = [[UILabel alloc] init];
        serviceCondition.text = [(ServiceCondition *)price.serviceConditions[i] value];
        serviceCondition.frame = CGRectMake(txt_line_space, txt_line_space+i*txt_line_height, self.frame.size.width+5*txt_line_space, txt_line_height);
        serviceCondition.font = [UIFont systemFontOfSize:small_font_size];
        serviceCondition.textColor = [ColorUtils colorWithHexString:black_text_color];
        [self.contentView addSubview:serviceCondition];
        
        CGSize conditionSize = [serviceCondition.text sizeWithFont:serviceCondition.font constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByCharWrapping];
        lastWidth = conditionSize.width;
        lastY = serviceCondition.frame.origin.y;
    }
    
//    self.originYuan.font = [UIFont systemFontOfSize:small_font_size];
//    self.originYuan.textColor = [ColorUtils colorWithHexString:black_text_color];
//    self.originYuan.frame = CGRectMake(txt_line_space+lastWidth, lastY, 10, txt_line_height);
//    
//    self.originPrice.text = [@(price.price) stringValue];
//    self.originPrice.font = [UIFont systemFontOfSize:small_font_size];
//    self.originPrice.textColor = [ColorUtils colorWithHexString:black_text_color];
//    CGSize originPriceSize = [self.originPrice.text sizeWithFont:self.originPrice.font constrainedToSize:CGSizeMake(200, 20) lineBreakMode:NSLineBreakByCharWrapping];
//    self.originPrice.frame = CGRectMake(self.originYuan.frame.origin.x+10, lastY, originPriceSize.width, txt_line_height);
//    
//    self.deleteLine.backgroundColor = [ColorUtils colorWithHexString:black_text_color];
//    self.deleteLine.frame = CGRectMake(self.originYuan.frame.origin.x+2, lastY+txt_line_height/2, originPriceSize.width+10, splite_line_height);
    
    self.originPriceLabel.font = [UIFont systemFontOfSize:small_font_size];
    self.originPriceLabel.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.originPriceLabel.frame = CGRectMake(txt_line_space, self.frame.size.height-txt_line_height-txt_line_space, 28, txt_line_height);

    self.originYuan.font = [UIFont systemFontOfSize:small_font_size];
    self.originYuan.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.originYuan.frame = CGRectMake(txt_line_space+self.originPriceLabel.frame.size.width-4, self.frame.size.height-txt_line_height-txt_line_space, 10, txt_line_height);
    
    self.originPrice.text = [@(price.price) stringValue];
    self.originPrice.font = [UIFont systemFontOfSize:small_font_size];
    self.originPrice.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.originPrice.frame = CGRectMake(self.originYuan.frame.origin.x+10, self.frame.size.height-txt_line_height-txt_line_space, 50, txt_line_height);
    
    CALayer *layer  = self.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:0];
    [layer setBorderWidth:0.5f];
    [layer setBorderColor:[ColorUtils colorWithHexString:splite_line_color].CGColor];
}

-(void) updatePrice:(int)price specialOfferPrice:(int)specialOfferPrice{
//    self.originPrice.text = [@(price) stringValue];
    self.originPrice.text = [@(specialOfferPrice) stringValue];
}

+(float) judgeHeight:(StylistServiceItemPrice *)price{
    float cellContentLineHeight = txt_line_height;
    int rows = 1+(price.serviceConditions.count>0?(price.serviceConditions.count):0);
    float cellHeight = cellContentLineHeight*rows + 2*txt_line_space;
    return cellHeight;
}

-(void) setSelected:(BOOL)selected{
    [super setSelected:selected];
    CALayer *layer  = self.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:0];
    if (selected) {
        [layer setBorderWidth:2.0f];
        [layer setBorderColor:[ColorUtils colorWithHexString:orange_text_color].CGColor];
    }else{
        [layer setBorderWidth:0.5f];
        [layer setBorderColor:[ColorUtils colorWithHexString:light_gray_text_color].CGColor];
    }
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
