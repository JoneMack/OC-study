//
//  MyOrderedLookSegmentView.m
//  xiangyu
//
//  Created by xubojoy on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MyOrderedLookSegmentView.h"
#import "UILabel+Custom.h"

#define red_line_view_height 2
@implementation MyOrderedLookSegmentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

-(void)render:(NSArray *)btnTitleArray currentIndex:(int)currentIndex
{
    float x = 0;
    float btnWidth = self.frame.size.width/btnTitleArray.count;
    
    for (int i = 0; i < btnTitleArray.count; i ++) {
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        x = i*btnWidth;
        
        selectBtn.frame = CGRectMake(x, 0, btnWidth, 30);
        [selectBtn setTitle:[btnTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        selectBtn.tag = [self getBtnTag:i];
        [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:small_font_size]];
        [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn setTitleColor:[ColorUtils colorWithHexString:text_color_gray] forState:UIControlStateNormal];
        [selectBtn setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:selectBtn];
        
    }
    
    [self selectIndex:currentIndex];
}

-(int)getBtnTag:(int)index{
    return btn1_seed + index;
}

-(int)getInxByBtnTag:(int)tag{
    return tag - btn1_seed;
}

-(void)selectIndex:(int)index{
    static int currentSelectButtonTag = 0;
    static int previousSelectButtonTag = btn1_seed;
    
    currentSelectButtonTag = [self getBtnTag:index];
    
    UIButton *previousBtn=(UIButton *)[self viewWithTag:previousSelectButtonTag];
    
    [previousBtn setTitleColor:[ColorUtils colorWithHexString:gray_text_color] forState:UIControlStateNormal];
    [previousBtn setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *currentBtn = (UIButton *)[self viewWithTag:currentSelectButtonTag];
    [currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [currentBtn setBackgroundColor:[ColorUtils colorWithHexString:text_color_purple]];
    previousSelectButtonTag = currentSelectButtonTag;
    self.currentIndex = index;
    [self.delegate selectMyOrderedLookSegmentView:index];
}

-(void)renderRedDot:(int)index showRedDot:(BOOL)showRedDot{
    index = btn1_seed+index;  // 外面直接传第几个就可以，不用知道是从多少开始的。
    UIButton *btn = (UIButton *)[self viewWithTag:index];
    float width = btn.frame.size.width;
    float titleLabelWidth = btn.titleLabel.realWidth;
    width = width - ( (width-titleLabelWidth)/2 - 5 );
    
    if (self.redDotImage == nil) {
        self.redDotImage = [[UIImageView alloc] init];
        [btn addSubview:self.redDotImage];
    }
    self.redDotImage.frame = CGRectMake(width, (general_cell_height - red_dot_width)/2, red_dot_width, red_dot_width);
    self.redDotImage.image = [UIImage imageNamed:@"red_dot"];
    [self.redDotImage setHidden:(showRedDot==YES?NO:YES)];
}

-(void)selectBtnClick:(UIButton *)sender
{
    int index = [self getInxByBtnTag:(int)sender.tag];
    if(index == self.currentIndex){
        return ;
    }
    [self selectIndex:index];
}

@end
