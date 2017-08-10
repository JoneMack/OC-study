//
//  EvaluationPictureController.m
//  styler
//
//  Created by aypc on 13-12-21.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "EvaluationPictureController.h"
#import "UIViewController+Custom.h"

@interface EvaluationPictureController ()

@end

@implementation EvaluationPictureController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithResourceType:(pictureResourceType)type evaluation:(StylistEvaluation *)evaluation
{
    self = [self init];
    if (self) {
        
        self.pictureType = type;
        self.evaluation = evaluation;
        
        self.view.backgroundColor = [UIColor blackColor];
        
        [self initPictureWrapper];
        
        self.picturePageControl.backgroundColor = [UIColor clearColor];
        self.picturePageControl.currentPage = 0;
        self.picturePageControl.numberOfPages = evaluation.evaluationPictures.count;
        self.picturePageControl.frame = CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height-30, self.view.frame.size.width, 30);
        [self.picturePageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.picturePageControl];
        
        [self createPages];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightSwipeGestureAndAdaptive];
}

-(void)jumpToPage:(int)page
{
    [self.pictureScoreView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width * page, 0) animated:NO];
}

-(void)initPictureWrapper{
    self.pictureScoreView.frame = CGRectMake(0, 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height);
    
    int pictureCount = self.evaluation.evaluationPictures.count;
    
    CGSize contentSize = CGSizeMake(self.view.frame.size.width*pictureCount, [UIScreen mainScreen].applicationFrame.size.height);
    self.pictureScoreView.contentSize = contentSize;
    self.pictureScoreView.pagingEnabled = YES;
    self.pictureScoreView.showsHorizontalScrollIndicator = NO;
    self.pictureScoreView.backgroundColor = [UIColor clearColor];
    self.pictureScoreView.delegate = self;
    
    [self.view addSubview:self.pictureScoreView];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
    tapGr.cancelsTouchesInView = NO;
    [self.pictureScoreView addGestureRecognizer:tapGr];
}

-(void)createPages{
    int pictureCount = self.evaluation.evaluationPictures.count;
    self.imageViewArray = [[NSMutableArray alloc] initWithCapacity:pictureCount];
    
    for (int i = 0; i < pictureCount; i++) {
        
        UIImageView *pictureView = [[UIImageView alloc] init];
        
        EvaluationPicture *evaluationPicture = (EvaluationPicture *)self.evaluation.evaluationPictures[i];
        CGSize originSize = CGSizeMake(evaluationPicture.width, evaluationPicture.height);
        
        CGSize size = [self pictureDisplaySize:originSize];
        pictureView.frame = CGRectMake(0, 0, size.width, size.height);
        pictureView.center = CGPointMake(160  + 320 * i, [UIScreen mainScreen].applicationFrame.size.height / 2);
            
        [pictureView setImageWithURL:[NSURL URLWithString:evaluationPicture.pictureUrls] placeholderImage:nil options:SDWebImageDownloaderLowPriority|SDWebImageRetryFailed|SDWebImageRefreshCached];
        
        
        [self.imageViewArray addObject:pictureView];
        [self.pictureScoreView addSubview:pictureView];
    }
}
-(CGSize)pictureDisplaySize:(CGSize)imageSize
{
    CGSize size;
    
    if (imageSize.width > imageSize.height) {
        size.width = 320;
        size.height = 320 / imageSize.width * imageSize.height;
    }else if (imageSize.height >= imageSize.width)
    {
        size.height = [UIScreen mainScreen].applicationFrame.size.height;
        size.width = [UIScreen mainScreen].applicationFrame.size.height / imageSize.height * imageSize.width;
    }
    if (size.width > [UIScreen mainScreen].applicationFrame.size.width) {
        size.width = 320;
        size.height = 320 / imageSize.width * imageSize.height;
    }
    
    if (size.height > [UIScreen mainScreen].applicationFrame.size.height) {
        size.height = [UIScreen mainScreen].applicationFrame.size.height;
        size.width = [UIScreen mainScreen].applicationFrame.size.height / imageSize.height * imageSize.width;
    }
    return size;
}

- (void)changePage:(id)sender{
    int page = self.picturePageControl.currentPage;
    // update the scroll view to the appropriate page
    CGRect frame = self.pictureScoreView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.pictureScoreView scrollRectToVisible:frame animated:YES];
    
    [MobClick event:log_event_name_check_evluation_picture attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.evaluation.stylist.name, @"发型师名字",nil]];
}

-(void) scrollViewDidScroll:(UIScrollView *)sender{
    if(sender == self.pictureScoreView){
        CGFloat pageWidth = sender.frame.size.width;
        int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.picturePageControl.currentPage = page;
    }
}

-(NSString *)getPageName{

    return page_name_evaluation_pictures;
}

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
