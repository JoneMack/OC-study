//
//  LeveyTabBar.m
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import "ImageUtils.h"
#import "UIImage+imagePlus.h"
#import "LeveyTabBar.h"
#import "Constant.h"
#import "PushProcessor.h"
#import "AppStatus.h"


@implementation LeveyTabBar
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray andItemTitle:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = CGRectMake(0, -20, screen_width, tabbar_height+20);
		_backgroundView = [[UIImageView alloc] initWithFrame:frame];
        UIImage *bgImg = [UIImage imageNamed:@"bg_navbar"];
        self.backgroundView.layer.contents = (id) bgImg.CGImage;
        [self.backgroundView setBackgroundColor:[UIColor clearColor]];
		[self addSubview:_backgroundView];
		self.buttons = [NSMutableArray array];
        CGFloat width = screen_width/imageArray.count;
        for (int i = 0; i < [imageArray count]; i++)
		{
            TabBarItem * tabBarItem = [[TabBarItem alloc]initWithFrame:CGRectMake(width * i, 0, width, frame.size.height) withTitle:[titles objectAtIndex:i] withIconImages:[imageArray objectAtIndex:i] withItemIndex:i];
            tabBarItem.delegate = self;
            [self.buttons addObject:tabBarItem];
            [self addSubview:tabBarItem];
		}
        [self updateUnreadIcon:nil];
    }
    return self;
}

-(void)clickTabBarItem:(int)index
{
    [self selectTabAtIndex:index];
}


- (void)setBackgroundImage:(UIImage *)img
{
	[_backgroundView setImage:img];
}

- (void)tabBarButtonClicked:(id)sender
{
	UIButton *btn = sender;
	[self selectTabAtIndex:btn.tag];
}

- (void)selectTabAtIndex:(NSInteger)index
{
	for (int i = 0; i < [self.buttons count]; i++)
	{
		TabBarItem *b = [self.buttons objectAtIndex:i];
		[b setSelect:NO];
	}
	TabBarItem *btn = [self.buttons objectAtIndex:index];
	[btn  setSelect:YES];
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        [_delegate tabBar:self didSelectIndex:btn.index];
    }
}


- (void)addRemindIconIndex:(int)index;
{
    TabBarItem * ti = [self.buttons objectAtIndex:index];
    [ti addRemindIcon];
}

- (void)removeRemindIconIndex:(int)index
{
    TabBarItem * ti = [self.buttons objectAtIndex:index];
    [ti removeRemindIcon];
}


-(void)updateUnreadIcon:(NSNotification *)sender
{

}

@end
