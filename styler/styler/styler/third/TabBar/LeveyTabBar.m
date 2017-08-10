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
#import "EaseMobProcessor.h"


@implementation LeveyTabBar
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray andItemTitle:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        
		_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.backgroundView.image = [UIImage loadImageWithImageName:@"under_bar"];
		[self addSubview:_backgroundView];
		self.buttons = [NSMutableArray array];
        CGFloat width = 320.f/imageArray.count;
        for (int i = 0; i < [imageArray count]; i++)
		{
            TabBarItem * tabBarItem = [[TabBarItem alloc]initWithFrame:CGRectMake(width * i, 0, width, frame.size.height) withTitle:[titles objectAtIndex:i] withIconImages:[imageArray objectAtIndex:i] withItemIndex:i];
            tabBarItem.delegate = self;
            [self.buttons addObject:tabBarItem];
            [self addSubview:tabBarItem];
		}
        [self updateUnreadIcon:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadIcon:) name:notification_name_update_push object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadIcon:) name:notification_name_update_has_unevaluate_order object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadIcon:) name:notification_name_session_update object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadIcon:) name:notification_name_im_message_status_update object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadIcon:) name:notification_name_update_has_unpayment_hdc object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadIcon:) name:notification_name_has_new_stylist_works object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadIcon:) name:notification_name_remind_user_update_default_name object:nil];
        
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
    PushProcessor *pushProcessor = [PushProcessor sharedInstance];
    AppStatus *as = [AppStatus sharedInstance];
    if ([pushProcessor hasUnreadOrderPush] || as.hasUnevaluationOrder || as.hasUnpaymentHdc ||
        [as isDefaultUserName]) {
        [self addRemindIconIndex:3];
    }else
    {
        [self removeRemindIconIndex:3];
    }
    
    if (as.hasNewStylistWorks) {
        [self addRemindIconIndex:1];
    }else{
        [self removeRemindIconIndex:1];
    }
    
    if ([EaseMobProcessor unreadSupportMessageCount] > 0) {
        [self addRemindIconIndex:2];
    }else{
        [self removeRemindIconIndex:2];
    }
}

@end
