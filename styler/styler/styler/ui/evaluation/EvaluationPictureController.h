//
//  EvaluationPictureController.h
//  styler
//
//  Created by aypc on 13-12-21.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Evaluation.h"
typedef enum
{
    from_image = 0,
    from_url
}pictureResourceType;

@interface EvaluationPictureController : UIViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *pictureScoreView;
@property (weak, nonatomic) IBOutlet UIPageControl *picturePageControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSMutableArray *imageViewArray;

@property (retain, nonatomic) StylistEvaluation *evaluation;
@property pictureResourceType pictureType;
-(id)initWithResourceType:(pictureResourceType)type evaluation:(StylistEvaluation *)evaluation;
-(void)jumpToPage:(int)page;
@end
