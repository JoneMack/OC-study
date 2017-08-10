//
//  TabBarItem.m
//  CustomTabbarControllerDemo
//
//  Created by aypc on 13-11-1.
//  Copyright (c) 2013年 aypc. All rights reserved.
//

#import "TabBarItem.h"
#import "ColorUtils.h"
#import "Constant.h"

#define REMIND_ICON_FRAME CGRectMake(56, 10, red_dot_width, red_dot_width)
#define unselect_title_color  @"#818181"
@implementation TabBarItem


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"TabBarItem" owner:self options:Nil] objectAtIndex:0];
        self.frame = frame;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withIconImages:(NSArray *)imageArray withItemIndex:(int)index
{
    self = [self initWithFrame:frame];
    defaultImage = [imageArray objectAtIndex:0];
    selectedImage = [imageArray objectAtIndex:1];
    self.index = index;
    self.tabBarButton.tag = self.index;
    
    //设置icon
    self.tabBarIcon.image = defaultImage;
    CGRect iconFrame = self.tabBarIcon.frame;
    iconFrame.origin.y = 0;
    iconFrame.origin.x = (frame.size.width - 32)/2;
    if (index == 1) {
        iconFrame.origin.x = (frame.size.width - 32)/2 -1;
    }
    self.tabBarIcon.frame =iconFrame;
    
    //设置文字
    self.tabBarTitle.text = title;
    CGRect titleFrame = self.tabBarTitle.frame;
    self.tabBarTitle.font = [UIFont boldSystemFontOfSize:10];
    titleFrame.size.width = frame.size.width;
    titleFrame.origin.y = iconFrame.origin.y+iconFrame.size.height-5;
    self.tabBarTitle.frame = titleFrame;
    
    [self.tabBarButton addTarget:self action:@selector(clickTabBarItem:) forControlEvents:UIControlEventTouchUpInside];
    self.tabBarButton.frame = CGRectMake(0, 0, screen_width/imageArray.count, 51);
    return self;
}


-(void)addRemindIcon;
{
    UIImageView *remindImageView = [[UIImageView alloc]initWithFrame:REMIND_ICON_FRAME];
    remindImageView.image = [UIImage imageNamed:@"red_dot"];
    //[remindImageView setBackgroundColor:[UIColor grayColor]];
    remindImageView.tag = 100 + self.index;
    [self addSubview:remindImageView];
}

-(void)removeRemindIcon
{
    for (UIView * v in self.subviews) {
        if (v.tag == 100 + self.index) {
            [v removeFromSuperview];
        }
    }
}

-(void)clickTabBarItem:(UIButton *)sender
{
    [self.delegate clickTabBarItem:sender.tag];
}

-(void)setSelect:(BOOL)select
{
    self.isSelected = select;
    
    if (select) {
        self.tabBarIcon.image = selectedImage;
        self.tabBarTitle.textColor = [ColorUtils colorWithHexString:black_text_color];
    }else
    {
        self.tabBarIcon.image = defaultImage;
        self.tabBarTitle.textColor = [ColorUtils colorWithHexString:unselect_title_color];
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
