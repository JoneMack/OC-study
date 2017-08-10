//
//  EvaluationImageViewController.m
//  styler
//
//  Created by wangwanggy820 on 14-3-20.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "EvaluationImageViewController.h"
#import "UIViewController+Custom.h"

@interface EvaluationImageViewController ()

@end

@implementation EvaluationImageViewController

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
    // Do any additional setup after loading the view from its nib.
    [self setRightSwipeGestureAndAdaptive];
    [self initbackgourd];
    [self initHeader];
    [self initEvaluationImageView];
}

-(void)initbackgourd
{
    self.view.backgroundColor = [UIColor blackColor];

}

-(void)initHeader
{
    self.header = [[HeaderView alloc]initWithTitle:page_name_evaluation navigationController:self.navigationController];
    CGRect frame = self.delBtn.frame;
    frame.origin.x = self.header.frame.size.width - general_padding - frame.size.width;
    self.delBtn.frame = frame;
    [self.header addSubview:self.delBtn];
    [self.view addSubview:self.header];
}

-(void)initEvaluationImageView{
    self.evaluationImgView.image = self.evaluationImg;
    
    
    float finalWidth,finalHeight = 0;
    float originWidth,originHeight = 0;
    CGSize displaySize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-self.header.frame.size.height);
    float displayRatio = displaySize.width/displaySize.height;
    
    originWidth = self.evaluationImg.size.width;
    originHeight = self.evaluationImg.size.height;
    float originImgRatio = self.evaluationImg.size.width/originHeight;
    
    //计算最终图片显示尺寸
    if(originImgRatio >= displayRatio){
        finalWidth = originWidth>displaySize.width?displaySize.width:originWidth;
        finalHeight = finalWidth/originImgRatio;
    }else{
        finalHeight = originHeight>displaySize.height?displaySize.height:originHeight;
        finalWidth = finalHeight*originImgRatio;
    }

    //计算图片最终布局
    float x = (displaySize.width - finalWidth)/2;
    float y = (displaySize.height - finalHeight)/2+self.header.frame.size.height;
    
    self.evaluationImgView.frame = CGRectMake(x, y, finalWidth, finalHeight);
}

-(NSString *)getPageName{
    return page_name_evaluation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)delImg:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"delete_evalustion_image" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
