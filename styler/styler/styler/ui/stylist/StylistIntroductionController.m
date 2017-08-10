//
//  ExpertIntroductionController.m
//  styler
//
//  Created by System Administrator on 14-1-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "StylistIntroductionController.h"
#import "HeaderView.h"
#import "UIViewController+Custom.h"

@interface StylistIntroductionController ()

@end

@implementation StylistIntroductionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightSwipeGestureAndAdaptive];
    [self initView];
    [self initHeader];
    [self renderIntroduction];
}

-(void) initView
{
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.view.autoresizesSubviews = NO;
}

-(void) initHeader
{
    self.header = [[HeaderView alloc] initWithTitle:self.stylistName navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void) renderIntroduction
{
    [self.introduction setFont:[UIFont systemFontOfSize:default_font_size]];
    [self.introduction setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
    [self.introduction setNumberOfLines:0];
    [self.introduction setText:self.introductionTxt];
    CGRect frame = self.introduction.frame;
    frame.origin.y = self.header.frame.size.height;
    CGSize introductionTxtSize = [self.introduction.text sizeWithFont:self.introduction.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    self.introduction.frame = CGRectMake(10, frame.origin.y+10, introductionTxtSize.width, introductionTxtSize.height);
}

-(NSString *)getPageName{
    return self.stylistName;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
