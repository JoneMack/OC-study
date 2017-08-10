//
//  ServiceDetailItem.m
//  styler
//
//  Created by System Administrator on 13-7-4.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "ServiceDetailItem.h"

@implementation ServiceDetailItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(id) instanceServiceDetailItem:(CommonItemTxt *)itemText{
    NSArray *nibView = [[NSBundle mainBundle] loadNibNamed:@"ServiceDetailItem" owner:nil options:nil];
    ServiceDetailItem *view = (ServiceDetailItem*)[nibView objectAtIndex:0];
    view.itemTxt = itemText;
    [view initUI];
    
    return view;
}


-(void) initUI{
    self.title.text = self.itemTxt.title;
    self.content.text = self.itemTxt.content;
    
    self.content.numberOfLines = 0;
    
    UIFont *titleFont = [UIFont systemFontOfSize:title_font_size];
    CGSize size = CGSizeMake(title_width, 2000);
    CGSize titleSize = [self.itemTxt.title sizeWithFont:titleFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    CGRect titleFrame = CGRectMake(0, service_detail_padding, title_width, titleSize.height);
    self.title.frame = titleFrame;
    self.title.font = [UIFont systemFontOfSize:title_font_size];
    self.title.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.title.textAlignment = NSTextAlignmentRight;
    
    CGSize contentSize = [ServiceDetailItem contentSize:self.itemTxt.content];
    CGRect contentFrame = CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y , 300-title_width-2*service_detail_padding, self.content.frame.size.height+3);
    self.content.frame = contentFrame;
    self.content.font = [UIFont systemFontOfSize:content_font_size];
    self.content.textColor = [ColorUtils colorWithHexString:gray_text_color];
    
    
    CGRect frame = self.frame;
    frame.size.height = contentSize.height+2*service_detail_padding;
    self.frame = frame;
    
    CGRect spliteFrame = self.spliteLine.frame;
    spliteFrame.origin.y = frame.size.height-1;
    self.spliteLine.frame = spliteFrame;
    self.spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
}

+(CGSize) contentSize:(NSString *)content{
    float contentWidth = 300-title_width-2*service_detail_padding;
    UIFont *contentFont = [UIFont systemFontOfSize:content_font_size];
    CGSize size = CGSizeMake(contentWidth,2000);
    CGSize contentSize = [content sizeWithFont:contentFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    return contentSize;
}

+(float) judgeHeight:(NSArray *)itemTxts{
    float height = 0;
    for (int i = 0; i < itemTxts.count; i++) {
        CommonItemTxt *itemTxt = itemTxts[i];
        height += [self contentSize:itemTxt.content].height+2*service_detail_padding;
    }
    return height;
}

@end
