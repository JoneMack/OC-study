//
//  ServicePicturesController.m
//  styler
//
//  Created by System Administrator on 13-7-24.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "ServicePicturesController.h"
#import "ServicePicture.h"
#import "UIViewController+Custom.h"

@interface ServicePicturesController ()

@end

@implementation ServicePicturesController

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
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initPictureWrapper];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = self.pictures.count;
    self.pageControl.currentPage = 0;
    self.pageControl.frame = CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height-30, self.view.frame.size.width, 30);
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    if (self.pictures.count == 1) {
        self.pageControl.hidden = YES;
    }
    
    [self createPages];
}

-(void)initPictureWrapper{
    self.pictureWrapper.frame = CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].applicationFrame.size.height);
    CGSize contentSize = CGSizeMake(self.view.frame.size.width*self.pictures.count, [UIScreen mainScreen].applicationFrame.size.height);
    self.pictureWrapper.contentSize = contentSize;
    self.pictureWrapper.pagingEnabled = YES;
    self.pictureWrapper.showsHorizontalScrollIndicator = NO;
    self.pictureWrapper.backgroundColor = [UIColor clearColor];
    self.pictureWrapper.delegate = self;
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    tapGr.cancelsTouchesInView = NO;
    tapGr.delegate = self;
    [self.pictureWrapper addGestureRecognizer:tapGr];
}

-(void)createPages{
    self.imageViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.pictures.count; i++) {
        ServicePicture *picture = (ServicePicture *)self.pictures[i];
        UIImageView *pictureView = [[UIImageView alloc] init];
        pictureView.backgroundColor = [UIColor clearColor];
        [pictureView setImageWithURL:[NSURL URLWithString:picture.fileUrl] placeholderImage:nil options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
        
        float displayWidth = self.view.frame.size.width;
        CGSize bigSize = [picture getBigCGSize];
        float rate = ((float)bigSize.width)/(float)bigSize.height;
        float displayHeight = (float)displayWidth/rate;
        if (displayHeight >= [UIScreen mainScreen].applicationFrame.size.height) {
            pictureView.frame = CGRectMake(0, 0, displayWidth, displayHeight);
        }else{
            pictureView.frame = CGRectMake(i*self.view.frame.size.width, ([UIScreen mainScreen].applicationFrame.size.height-displayHeight)/2, displayWidth, displayHeight);
        }
        [self.imageViews addObject:pictureView];
        [self.pictureWrapper addSubview:pictureView];
    }
}

- (void)changePage:(id)sender{
    int page = self.pageControl.currentPage;
    // update the scroll view to the appropriate page
    CGRect frame = self.pictureWrapper.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.pictureWrapper scrollRectToVisible:frame animated:YES];
}

-(void) scrollViewDidScroll:(UIScrollView *)sender{
    if(sender == self.pictureWrapper){
        CGFloat pageWidth = sender.frame.size.width;
        int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
    }
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPictureWrapper:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}

-(NSString *)getPageName{
    return page_name_work_pictures;
}

//-(void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:page_name_work_pictures];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:page_name_work_pictures];
//}
@end
