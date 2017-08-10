//
//  EvaluationImageDetailController.m
//  styler
//
//  Created by aypc on 13-12-17.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "EvaluationImageDetailController.h"
#import "UIImage+imagePlus.h"
#import "UIViewController+Custom.h"

@interface EvaluationImageDetailController ()

@end

@implementation EvaluationImageDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithImage:(UIImage *)image
{
    self = [super init];
    self.image = image;
    self.imageView.image = self.image;
    [self loadImageView];
    return self;
}

-(void)loadImageView
{
    if (self.image.size.width > self.image.size.height) {
        self.imageView.frame = CGRectMake(0, navigation_height, screen_width, screen_width/self.image.size.width * self.image.size.height);
    }else
    {
        
        self.imageView.frame = CGRectMake(0, navigation_height, (self.view.frame.size.height - navigation_height)/self.image.size.height * self.image.size.width,self.view.frame.size.height - navigation_height);
    }
    self.imageView.center = CGPointMake(160,( self.view.frame.size.height - navigation_height ) / 2 + navigation_height);
}

-(void)deleteImage
{
    [self.delegate deleteEvaluationImage:self.image];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)getPageName{
    return page_name_evaluation_picture;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setRightSwipeGestureAndAdaptive];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
