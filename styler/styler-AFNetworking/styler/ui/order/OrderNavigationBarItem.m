//
//  OrderNavigationBar.m
//  styler
//
//  Created by wangwanggy820 on 14-3-31.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrderNavigationBarItem.h"

#define item_num_width 17
#define item_separator_width 9
#define item_name_font_size 10
#define item_general_padding 17
@implementation OrderNavigationBarItem

- (id)initWithFrame:(CGRect)frame itemName:(NSString *)itemName num:(int)num selected:(BOOL)selected
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[NSBundle mainBundle] loadNibNamed:@"OrderNavigationBarItem" owner:self options:nil][0];
        
        float y = (frame.size.height - item_num_width)/2;
        
        //设置项目序号
        self.itemNum.text = [@(num +1) stringValue];
        self.itemNum.font = [UIFont systemFontOfSize:small_font_size];
        if (selected) {
            self.itemNum.textColor = [UIColor whiteColor];
            //[ColorUtils colorWithHexString:white_text_color];
        }else{
            self.itemNum.textColor = [ColorUtils colorWithHexString:black_text_color];
        }
        self.itemNum.frame = CGRectMake(0, 0, item_num_width, item_num_width);
        [self.itemNumBgView addSubview:self.itemNum];
        
        //设置项目序号背景
        if (selected) {
            self.itemNumBgView.image = [UIImage imageNamed:@"select_item_num_bg"];
        }else{
            self.itemNumBgView.image = [UIImage imageNamed:@"unselect_item_num_bg"];
        }
        self.itemNumBgView.frame = CGRectMake(item_general_padding, y, item_num_width, item_num_width);;
        
        //设置项目名称
        self.itemName.text = itemName;
        self.itemName.font = [UIFont systemFontOfSize:item_name_font_size];
        self.itemName.textColor = [ColorUtils colorWithHexString:gray_text_color];
        self.itemName.frame = CGRectMake(self.itemNumBgView.frame.origin.x + self.itemNumBgView.frame.size.width, y, bar_item_width - (self.itemNumBgView.frame.origin.x + self.itemNumBgView.frame.size.width), item_num_width);
       
        //设置项目“分隔符”
        self.itemSeparator.image = [UIImage imageNamed:@"item_separator_icon"];
        self.itemSeparator.frame = CGRectMake(frame.size.width, 0, item_separator_width, frame.size.height);
        self.itemSeparator.clipsToBounds = NO;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        self.frame = frame;
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
