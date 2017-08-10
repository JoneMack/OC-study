//
//  MainHeaderView.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainHeaderView.h"

@implementation MainHeaderView

-(void) awakeFromNib
{
    
}


-(instancetype) initWithFrame:(CGRect) frame{
    self = [super initWithFrame:frame];
    if(self){
        self = [[[NSBundle mainBundle] loadNibNamed:@"MainHeaderView" owner:self options:nil] objectAtIndex:0];
        [self.currentCity setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 41)];
        [self.currentCity setImageEdgeInsets:UIEdgeInsetsMake(0, 61, 0, 0)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftMenuEvent) name:notification_name_show_left_menu_event object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLeftMenuEvent) name:notification_name_close_left_menu_event object:nil];
    }
    return self;
}


- (IBAction)showLeftMenu:(id)sender
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_show_left_menu object:nil];
    
}

- (void) showLeftMenuEvent
{
    [UIView animateWithDuration:0.5 animations:^{
        self.leftMenu.transform = CGAffineTransformRotate(self.leftMenu.transform, M_PI/2);
    }];
}

- (void) closeLeftMenuEvent
{
    [UIView animateWithDuration:0.5 animations:^{
        self.leftMenu.transform = CGAffineTransformRotate(self.leftMenu.transform, -M_PI/2);
    }];
}
@end
