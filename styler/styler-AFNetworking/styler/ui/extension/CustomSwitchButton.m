//
//  CustomSwitchButton.m
//  styler
//
//  Created by aypc on 13-10-16.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "CustomSwitchButton.h"

@implementation CustomSwitchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andBackground:(UIImage *)image andButtonImage:(UIImage*)btnImage
{
    self = [self initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithPatternImage:image];
    switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(0, 0, frame.size.width/2, frame.size.height);
    [switchBtn setImage:btnImage forState:UIControlStateNormal];
    [switchBtn setImage:btnImage forState:UIControlStateHighlighted];
    [self addSubview:switchBtn];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSwitchBtn)];
    [self addGestureRecognizer:tap];
    return self;
}
-(id)initWithFrame:(CGRect)frame andBackground:(UIImage *)image andOnImage:(UIImage *)OI andDisenableImage:(UIImage *)DI andButtonImage:(UIImage *)btnImage
{
    self = [self initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithPatternImage:image];
    offImage = image;
    onImage = OI;
    disenableImage = DI;
    switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    switchBtn.frame = CGRectMake(0, 0, frame.size.width/2, frame.size.height);
    [switchBtn setImage:btnImage forState:UIControlStateNormal];
    [switchBtn setImage:btnImage forState:UIControlStateHighlighted];
    [switchBtn addTarget:self action:@selector(clickSwitchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:switchBtn];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSwitchBtn)];
    [self addGestureRecognizer:tap];
    return self;
}

-(void)setDisenable:(BOOL)enable
{
    self.enable = enable;
    if (enable) {
        [self setOn:enable];
    }else
    {
//        self.backgroundColor = [UIColor colorWithPatternImage:disenableImage];
        [self setHidden:YES];
    }
}

-(void)clickSwitchBtn
{
    if (self.enable) {
        [self changeSwitchValue];
    }
}

-(void)setSwitchEnable:(BOOL)enable
{
    self.enable = enable;
}

-(void)setOn:(int)value
{
    if (value == 0) {
        
        if (onImage != nil) {
            [self changeBackgroundImage:0];
        }
        
        switchBtn.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
        self.value = 0;
    }else
    {
        if (onImage != nil) {
            [self changeBackgroundImage:1];
        }
        switchBtn.frame = CGRectMake(self.frame.size.width/2,0,  self.frame.size.width/2, self.frame.size.height);
        self.value = 1;
    }
}

-(void)changeSwitchValue
{
    if ((self.value == 1)&&(switchBtn.frame.origin.x == self.frame.size.width/2)) {
        
        if (onImage != nil) {
            [self changeBackgroundImage:0];
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        switchBtn.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
        [UIView commitAnimations];
        self.value = 0;
    }else
    {
        if (onImage != nil) {
            [self changeBackgroundImage:1];
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        switchBtn.frame = CGRectMake(self.frame.size.width/2,0,  self.frame.size.width/2, self.frame.size.height);
        [UIView commitAnimations];
        self.value = 1;
    }
    
    [self performSelector:@selector(didDelegate) withObject:nil afterDelay:0.3];
}

-(void)didDelegate
{
    if ([self.delegate respondsToSelector:@selector(customSwitch:ChangedValue:)]) {
        [self.delegate customSwitch:self ChangedValue:self.value];
    }
}


-(void)changeBackgroundImage:(int)isON
{
    if (isON) {
        self.backgroundColor = [UIColor colorWithPatternImage:onImage];
    }else
    {
        self.backgroundColor = [UIColor colorWithPatternImage:offImage];
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
