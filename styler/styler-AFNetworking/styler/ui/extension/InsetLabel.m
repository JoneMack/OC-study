//
//  InsetLabel.m
//  iUser
//
//  Created by System Administrator on 13-5-6.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "InsetLabel.h"

@implementation InsetLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)  initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets  {
    self  = [super  initWithFrame:frame];
    if(self){
        self.insets  = insets;
    }
    return  self;
}

-(id)  initWithInsets:(UIEdgeInsets)insets  {
    self  = [super  init];
    if(self){
        self.insets  = insets;
    }
    return  self;
}

-(void)  drawTextInRect:(CGRect)rect {
    return  [super  drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

@end
