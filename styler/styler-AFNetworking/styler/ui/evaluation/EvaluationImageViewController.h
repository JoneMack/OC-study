//
//  EvaluationImageViewController.h
//  styler
//
//  Created by wangwanggy820 on 14-3-20.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "PostEvaluationController.h"

@interface EvaluationImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIImageView *evaluationImgView;
@property (strong, nonatomic)HeaderView *header;
@property (retain, nonatomic) UIImage *evaluationImg;
@property int imgInx;

- (IBAction)delImg:(id)sender;

@end
