//
//  ServicePicturesController.h
//  styler
//
//  Created by System Administrator on 13-7-24.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#define nav_view_height 40
#define dot_width 6

#import <UIKit/UIKit.h>

@interface ServicePicturesController : UIViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *pictureWrapper;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *imageViews;

@property (retain, nonatomic) NSArray *pictures;



@end
