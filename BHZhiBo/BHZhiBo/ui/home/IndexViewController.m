//
//  IndexViewController.m
//  BHZhiBo
//
//  Created by xubojoy on 2016/12/21.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "IndexViewController.h"
#import "CustomCollectionViewCell.h"
#import "AoiroSoraLayout.h"
#import "CommonWebViewController.h"
#import "JSONModel.h"
#import "BIDObjectToNsDictionary.h"
#import "BHZhiBoTabbar.h"
#import "ArticleStore.h"
#import "CommonContentWebController.h"
//#import <ShareSDKConnector/ShareSDKConnector.h>
#define COLLECTVIEW_HEIGHT (screen_height-tabbar_height-140-20-10-screen_width/2);
@interface IndexViewController ()<AoiroSoraLayoutDelegate>

@end
static NSString *customCategoryCollectionViewCellId = @"CustomCollectionViewCell";
@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.autoresizesSubviews = NO;
//    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];
    [self initHeadView];
//    self.imageArray = [NSMutableArray arrayWithObjects:@"12.jpg",@"13.jpg",@"14.jpg",@"15.jpg", nil];
    NSLog(@"--------联网成功");
    self.imageArray = [NSMutableArray new];
    self.articleArray = [NSMutableArray new];
    self.bannerArray = [NSMutableArray new];
    [self loadAppData];
}

- (void)initRefreshBtn{
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake((screen_width-80)/2, (screen_height-30)/2, 80, 30);
    refreshBtn.layer.cornerRadius = 2;
    refreshBtn.layer.masksToBounds = YES;
    refreshBtn.layer.borderWidth = splite_line_height;
    refreshBtn.layer.borderColor = [ColorUtils colorWithHexString:splite_line_color].CGColor;
    [refreshBtn setTitleColor:[ColorUtils colorWithHexString:gray_text_color] forState:UIControlStateNormal];
    [refreshBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    [refreshBtn.titleLabel setFont:[UIFont systemFontOfSize:default_font_size]];
    [refreshBtn addTarget:self action:@selector(refreshBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
}

- (void)refreshBtnClick{
    if ([[AppStatus sharedInstance] isConnetInternet]) {
        self.imageArray = [NSMutableArray new];
        self.articleArray = [NSMutableArray new];
        self.bannerArray = [NSMutableArray new];
        [self initMainScrollVew];
        [self initPageScrollView];
        [self initCategoryView];
        [self initCollectView];
        [self loadAppData];
    }else{
        
    }
}

- (void)loadAppData{
    [ArticleStore getRecommendArticles:^(Page *page, NSError *error) {
        if (error == nil) {
            if (page != nil) {
                for (NSDictionary *articleDic in page.items) {
                    self.article = [[Article alloc] initWithDictionary:articleDic error:nil];
                    if (self.article != nil) {
                        if ([self.article.articleType isEqualToString:@"轮播图"]) {
                            [self.imageArray addObject:self.article.articleLogo];
                            [self.bannerArray addObject:self.article];
                        }
                        [self.articleArray addObject:self.article];
                    }
                }
            }
            NSLog(@">>>>>>>>>>所有文章>>>>>>>%@",self.articleArray);
            [self refreshUI];
            [self.collectionView reloadData];
        }else{
            ExceptionMsg *exception = [[error userInfo] objectForKey:@"ExceptionMsg"];
            [self.view makeToast:exception.message duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
            [self initRefreshBtn];
        }
        
    } pageSize:100];
}

//初始化自定义导航
-(void)initHeadView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"黄金TD交流" navigationController:self.navigationController];
    self.headerView.backBut.hidden = YES;
    self.headerView.userInteractionEnabled = YES;
    [self.view addSubview:self.headerView];
    
//    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 20)];
//    statusView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:statusView];
}

//初始化scrollview容器
-(void)initMainScrollVew{
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height, screen_width, screen_height-self.headerView.frame.size.height-tabbar_height)];
    self.mainScrollView.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.mainScrollView];
}


- (void)initPageScrollView{
    float height = screen_width/3;
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screen_width, height) delegate:self placeholderImage:nil];
    self.cycleScrollView.autoScrollTimeInterval = 6.0;
    [self.mainScrollView addSubview:self.cycleScrollView];
}

- (void)refreshUI{
    [self initMainScrollVew];
    [self initPageScrollView];
    [self initCategoryView];
    [self initCollectView];
    self.cycleScrollView.imageURLStringsGroup = self.imageArray;
}

- (void)initCategoryView{
    float height = 0.0;
    if (screen_height >= 568) {
        height = 160;
    }else{
        height = 140;
    }
    self.customCategoryView = [[CustomCategoryView alloc] initWithFrame:CGRectMake(0, screen_width/3+general_padding, screen_width, height)];
    self.customCategoryView.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];
    self.customCategoryView.delegate = self;
    [self.mainScrollView addSubview:self.customCategoryView];
}

- (void)initCollectView{
    AoiroSoraLayout * layout = [[AoiroSoraLayout alloc]init];
    layout.interSpace = 5; // 每个item 的间隔
    layout.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.colNum = 2; // 列数;
    layout.delegate = self;
//    screen_height-tabbar_height-140-20-10-
    float H = screen_width/2;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,self.customCategoryView.frame.size.height+screen_width/3+general_padding, screen_width, H) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    
    self.collectionView.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];
    
    UINib *nib = [UINib nibWithNibName:@"CustomCollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib
                            forCellWithReuseIdentifier:customCategoryCollectionViewCellId];
    
    [self.mainScrollView addSubview:self.collectionView];
    float scrollewH = screen_width/3+general_padding+H+self.customCategoryView.frame.size.height;
    self.mainScrollView.contentSize = CGSizeMake(screen_width, scrollewH);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:customCategoryCollectionViewCellId forIndexPath:indexPath];
//    cell.contentView.backgroundColor = [ColorUtils randomColor];
    if (self.articleArray.count > 0) {
        [cell renderCustomCategoryCollectionViewCellWithItem:indexPath.item withArticleArray:self.articleArray];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float H = screen_width/2;
    if (indexPath.item == 0) {
        return CGSizeMake(screen_width/2,H);
    }else{
        return CGSizeMake(screen_width/2,H/2);
    }
}

#pragma mark -- 返回每个item的高度
- (CGFloat)itemHeightLayOut:(AoiroSoraLayout *)layOut indexPath:(NSIndexPath *)indexPath
{
//    screen_height-tabbar_height-140-20-10-
    float H = screen_width/2;
    if (indexPath.item == 0) {
        return H;
    }else{
        return H/2;
    }
}

#pragma mark -- 选中某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第 %ld 个cell",(long)indexPath.row);
    if (self.articleArray.count > 0) {
        for (Article *article in self.articleArray) {
            if (indexPath.item == 0) {
                if (article.id == 7) {
                    CommonContentWebController *cwvc = [[CommonContentWebController alloc] initWithArticle:article title:article.title];
                    [self.navigationController pushViewController:cwvc animated:YES];
                    
                }
            }else if (indexPath.item == 1){
                if (article.id == 8){
                    CommonContentWebController *cwvc = [[CommonContentWebController alloc] initWithArticle:article title:article.title];
                    [self.navigationController pushViewController:cwvc animated:YES];
                    
                }
            }else{
                if (article.id == 9){
                    CommonContentWebController *cwvc = [[CommonContentWebController alloc] initWithArticle:article title:article.title];
                    [self.navigationController pushViewController:cwvc animated:YES];
                    
                }
            }
        }
    }

}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@">>>>>>>>>>>>>>点击了第%d",(int)index);
    if (self.bannerArray.count > 0) {
        Article *article = self.bannerArray[index];
        CommonContentWebController *cwvc = [[CommonContentWebController alloc] initWithArticle:article title:article.title];
        [self.navigationController pushViewController:cwvc animated:YES];
    }
}

- (void)didSelectedCustomCategoryViewItem:(NSInteger)item categoryTitle:(NSString *)categoryTitle{

    NSLog(@">>>>>>>>>itemitemitem>>>>>点击了第%d",(int)item);
    if (item == 0) {
//        BHZhiBoTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
//        [tabBar.tabBarController setSelectedIndex:1];
        NSURL *appUrl = [[NSURL alloc] initWithString:@"https://itunes.apple.com/cn/app/jin-rong-shuapp/id1147075616?mt=8"];
        [[UIApplication sharedApplication] openURL:appUrl];

    }else if (item == 1) {
        BHZhiBoTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
        [tabBar.tabBarController setSelectedIndex:1];

    }else if (item == 4) {
        BHZhiBoTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
        [tabBar.tabBarController setSelectedIndex:2];

    }else{
        if (self.articleArray.count > 0) {
            for (Article *article in self.articleArray) {
                if (article.id == 2 && item == 2) {
                        CommonContentWebController *cwvc = [[CommonContentWebController alloc] initWithArticle:article title:categoryTitle];
                        [self.navigationController pushViewController:cwvc animated:YES];
                }else if (article.id == 3 && item == 3){
                    CommonContentWebController *cwvc = [[CommonContentWebController alloc] initWithArticle:article title:categoryTitle];
                    [self.navigationController pushViewController:cwvc animated:YES];
                }else if (article.id == 4 && item == 5){
                    CommonContentWebController *cwvc = [[CommonContentWebController alloc] initWithArticle:article title:categoryTitle];
                    [self.navigationController pushViewController:cwvc animated:YES];
                }else if (article.id == 5 && item == 6){
                    CommonContentWebController *cwvc = [[CommonContentWebController alloc] initWithArticle:article title:categoryTitle];
                    [self.navigationController pushViewController:cwvc animated:YES];
                }else if (article.id == 6 && item == 7){
                    CommonContentWebController *cwvc = [[CommonContentWebController alloc] initWithArticle:article title:categoryTitle];
                    [self.navigationController pushViewController:cwvc animated:YES];
                }
            }
        }
    }
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
