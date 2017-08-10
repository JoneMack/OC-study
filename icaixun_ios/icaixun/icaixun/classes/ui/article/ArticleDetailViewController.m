//
//  ArticleDetailViewController.m
//  icaixun
//
//  Created by 冯聪智 on 15/8/19.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleStore.h"

@interface ArticleDetailViewController ()

@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightSwipeGesture];
    [self initHeaderView];
    [self initBodyView];
    [self addReadCount];
}

- (void)addReadCount
{
    [[ArticleStore sharedInstance] postReadCount:^(Article *article, NSError *err) {
        if (article != nil) {
            self.article.readCount = article.readCount;
        }
    } articleId:[self.article.id intValue]];
}

-(void) initHeaderView
{
    self.headerView = [[HeaderView alloc] initWithTitle:@"文章"navigationController:self.navigationController];
    UIImage *bgImg = [UIImage imageNamed:@"bg_page_header@2x.jpg"];
    self.headerView.layer.contents = (id) bgImg.CGImage;
    [self.view addSubview:self.headerView];
}

-(void) initBodyView
{
    self.bodyView = [UIView new];
    self.bodyView.frame = CGRectMake(0, self.headerView.bottomY, screen_width, screen_height - self.headerView.bottomY);
    [self.bodyView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.bodyView];
    [self initTitleBlock];
}

-(void) initTitleBlock
{
    self.titleBlock = [UIView new];
    self.titleBlock.frame = CGRectMake(0, 0, screen_width, 75);
    [self.bodyView addSubview:self.titleBlock];
    
    self.titleLabe = [UILabel new];
    self.titleLabe.text = self.article.title;
    self.titleLabe.frame = CGRectMake(15, 15, screen_width - 40, 20);
    self.titleLabe.font = [UIFont systemFontOfSize:16];
    [self.titleBlock addSubview:self.titleLabe];
    
    self.createTimeAndReadCountLabel = [UILabel new];
    self.createTimeAndReadCountLabel.text= [self.article getCreateTimeAndReadCount];
    self.createTimeAndReadCountLabel.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.createTimeAndReadCountLabel.font = [UIFont systemFontOfSize:13];
    self.createTimeAndReadCountLabel.frame = CGRectMake(15, 40, screen_width - 40, 15);
    [self.titleBlock addSubview:self.createTimeAndReadCountLabel];
    
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:gray_common_color];
    self.separatorLine.frame = CGRectMake(0, 67.5 , screen_width,splite_line_height);
    [self.titleBlock addSubview:self.separatorLine];
    
    self.downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow_bg@2x.jpg"]];
    self.downArrow.frame = CGRectMake(20, 67.5, 15, 5);
    [self.titleBlock addSubview:self.downArrow];
    
//    self.webView = [[UIWebView alloc] init];
//    self.webView.frame = CGRectMake(7, self.titleBlock.bottomY, screen_width - 7,
//                                    screen_height -self.headerView.bottomY - self.titleBlock.bottomY - 10);
//    self.webView.scrollView.showsHorizontalScrollIndicator = YES;
//    self.webView.scrollView.scrollEnabled =YES;
//    [self.webView setBackgroundColor:[UIColor whiteColor]];
//    [self.webView setOpaque:NO];
//    [self.webView loadHTMLString:self.article.content baseURL:nil];
//    [self.bodyView addSubview:self.webView];
    [self initMainScrollVew];
    [self initIntroduceLabel];
    
}

//初始化scrollview容器
-(void)initMainScrollVew{
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(7, self.titleBlock.bottomY, screen_width,
                                                    screen_height -self.headerView.bottomY - self.titleBlock.bottomY - 10)];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.userInteractionEnabled = YES;
    [self.bodyView addSubview:self.mainScrollView];
}


-(void)initIntroduceLabel{
    
    self.introduceLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screen_width-2*10, 30)];//这个frame是初设的，没关系，后面还会重新设置其size。
    //    self.introduceLab.backgroundColor = [UIColor purpleColor];
    self.introduceLab.text = self.article.content;
    self.introduceLab.font = [UIFont systemFontOfSize:16];
    [self.introduceLab setNumberOfLines:0];
    [self.introduceLab sizeToFit]; //这句可以控制label自适应文字
    [self.mainScrollView addSubview:self.introduceLab];
    self.mainScrollView.contentSize = CGSizeMake(screen_width, self.introduceLab.frame.size.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
