//
//  CommonItemTxtView.m
//  styler
//
//  Created by wangwanggy820 on 14-4-8.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "CommonItemTxtView.h"
#import "CommonItemTxt.h"
#import "UIView+Custom.h"

@implementation CommonItemTxtView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame commonItemTxtArray:(NSArray *)commonItemTxtArray font:(UIFont *)font{
    self = [super initWithFrame:frame];
    self.frame = frame;
    self.commonItemTxtArray = commonItemTxtArray;
    int i = 0;
    float padding = general_padding/2;
    float y = padding;
    for (CommonItemTxt *itemTxt in commonItemTxtArray) {
        //使用代码创建UIView，并使用代码添加两个UILable分别显示条目的标题和内容
        
        //通过计算标题区域的尺寸，并且可以获得标题的宽度
        CGSize titleSize = [itemTxt.title sizeWithFont:font
                                              forWidth:frame.size.width
                                         lineBreakMode:NSLineBreakByWordWrapping];
        //计算内容区域的尺寸
        float contentWidth = frame.size.width - padding*2;
        CGSize contentSize = [itemTxt.content sizeWithFont:font
                                         constrainedToSize:CGSizeMake(contentWidth, 2000)];
        
        //对标题进行布局
        CGRect frame = CGRectMake(padding, y, screen_width-padding, titleSize.height+padding);
        UILabel *title = [[UILabel alloc] initWithFrame:frame];
        //对标题设置内容及样式
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [ColorUtils colorWithHexString:red_color];
        title.font = [UIFont systemFontOfSize:default_font_size];
        title.text = itemTxt.title;
        [self addSubview:title];
        

        float contentHeight = contentSize.height;
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(padding, y+title.frame.size.height+padding/2, contentWidth, contentHeight)];
        content.backgroundColor = [UIColor clearColor];
        content.textAlignment = NSTextAlignmentLeft;
        content.numberOfLines = 0;
        content.font = font;
        content.textColor = [ColorUtils colorWithHexString:gray_text_color];
        content.text = itemTxt.content;
        [self addSubview:content];
        y += contentSize.height +2*padding+title.frame.size.height;
        i++;

//        设置content的行间距
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:content.text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:padding];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [content.text length])];
        [content setAttributedText:attributedString1];
        [content sizeToFit];
    }
    return self;
}


+(float) judgeHeight:(NSArray *)commonItemTxtArray font:(UIFont *)font
{
    float height = 0;
    for (CommonItemTxt *itemTxt in commonItemTxtArray) {
        CGSize titleSize = [itemTxt.title sizeWithFont:font forWidth:screen_width lineBreakMode:NSLineBreakByWordWrapping];
        float titleWidth = titleSize.width;
        float contentWidth = screen_width - titleWidth - general_padding;
        
        CGSize contentSize = [itemTxt.content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 2000)];
        
        height += contentSize.height+general_padding/2;
    }
    return height;
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
