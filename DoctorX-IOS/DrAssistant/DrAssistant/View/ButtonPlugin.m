//
//  ButtonPlugin.m
//  DrAssistant
//
//  Created by Seiko on 15/10/9.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#define MYVIEWWITH  (self.bounds.size.width)
#define MYVIEWHEIGHT  (self.bounds.size.height)


#import "ButtonPlugin.h"

@implementation ButtonPlugin

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake((MYVIEWWITH-60)/2,MYVIEWHEIGHT/6,60,60);
    self.titleLabel.frame = CGRectMake(MYVIEWWITH/100,MYVIEWHEIGHT*9/10, MYVIEWWITH-MYVIEWWITH/50,MYVIEWHEIGHT/5);
    //    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.textAlignment = 1;
}


@end
