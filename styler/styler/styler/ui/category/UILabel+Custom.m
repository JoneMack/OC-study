//
//  UILabel+Custom.m
//  styler
//
//  Created by wangwanggy820 on 14-6-28.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel (Custom)

-(void)setParagrahStyle:(NSDictionary *)contentDict titleColor:(UIColor *)titleColor contentColor:(UIColor *)contentColor
{
    NSArray *titles = [contentDict allValues];
    NSArray *contents = [contentDict allKeys];
    NSString *allContent = @"";
    for (int i = 0; i<contentDict.count; i++) {
        if (i == 0) {
            allContent = [NSString stringWithFormat:@"%@\n%@",titles[i],contents[i]];
        }else{
            allContent = [NSString stringWithFormat:@"%@\n%@\n%@",allContent,titles[i],contents[i]];
        }
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:allContent];
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:general_padding/2];
    [attr addAttribute:NSParagraphStyleAttributeName
                 value:paragrahStyle range:NSMakeRange(0, [allContent length])];
    [attr addAttribute:NSForegroundColorAttributeName
                 value:contentColor range:NSMakeRange(0, allContent.length)];
    int lenght = 0;
    for (int i = 0; i< titles.count; i++) {
        NSString *title = titles[i];
        NSString *content = contents[i];
        [attr addAttribute:NSForegroundColorAttributeName value:titleColor
                     range:NSMakeRange(lenght, title.length)];
        lenght += content.length + title.length + 2;
    }
    
    UIFont *font = [UIFont systemFontOfSize:default_font_size];
    [attr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, allContent.length)];
    
    self.attributedText = attr;
}

-(float) realWidth
{
    return  [self.text sizeWithFont:self.font].width;
}

@end
