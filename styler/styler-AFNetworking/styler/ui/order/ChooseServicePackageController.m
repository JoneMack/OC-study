//
//  ChangeServicePackageController.m
//  styler
//
//  Created by wangwanggy820 on 14-3-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ChooseServicePackageController.h"
#import "StylistStore.h"
#import "OrderNavigationBar.h"
#import "ServicePackageCell.h"
#import "ChooseServiceConditionsController.h"
#import "UIViewController+Custom.h"
#import "LoadingStatusView.h"

#define bottom_y 2
#define loading_status_view_height 40
@interface ChooseServicePackageController ()

@end

@implementation ChooseServicePackageController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark ----- 请求网络数据
-(id)initWithStylist:(Stylist *)stylist
{
    self = [super init];
    self.stylist = stylist;
    LoadingStatusView *loading = [[LoadingStatusView alloc] initWithFrame:CGRectMake(0,180 + general_margin, screen_width, loading_status_view_height)];
    [loading updateStatus:@"正在加载，请稍等..." animating:YES];
    [self.view addSubview:loading];
    [[StylistStore sharedStore] getStylistServicePackage:^(NSArray *servicePackages, NSError *err) {
        if (!err) {
            if (!self.servicePackages) {
                self.servicePackages = [[NSMutableArray alloc] init];
            }
            [self.servicePackages addObjectsFromArray:servicePackages];
            [self.collectionView reloadData];
            loading.hidden = YES;
        }else{
            [loading updateStatus:network_unconnect_note animating:NO];
            return ;
        }
    } stylistId:stylist.id];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self initOrderNavigationBar];
    [self initCollcollectionView];
    [self initView];
}

-(void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
}

//头部
-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_choose_service_packge navigationController:self.navigationController];
    [self.header.backBut addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.header];
}

-(void)popView:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -----渲染头部下面的bar
-(void)initOrderNavigationBar{
    CGRect frame =  CGRectMake(0, self.header.frame.size.height + splite_line_height, screen_width, order_navigation_bar_height);
    OrderNavigationBar *orderBar = [[OrderNavigationBar alloc] initWithFrame:frame currentIndex:-1];
    [self.view addSubview:orderBar];
}
#pragma mark -----初始化UICollectionView
-(void)initCollcollectionView{
    [self.collectionView registerClass:[ServicePackageCell class] forCellWithReuseIdentifier:@"ServicePackageCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    float cellSpace = general_padding/2;
    float height = self.view.frame.size.height - self.header.frame.size.height - order_navigation_bar_height;

    self.collectionView.frame = CGRectMake(0, self.header.frame.size.height + order_navigation_bar_height, screen_width, height);
    //self.collectionView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.collectionView.backgroundColor = [UIColor clearColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = cellSpace;
    flowLayout.minimumLineSpacing = cellSpace;
    float itemWidth = (self.collectionView.frame.size.width-3*cellSpace)/2;
    float itemHeight = [ServicePackageCell getServiceCellHeight];
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self.collectionView setCollectionViewLayout:flowLayout];
}

#pragma mark ----- dataSource ---
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.servicePackages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ServicePackageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServicePackageCell" forIndexPath:indexPath];
    [cell renderServicePackage:self.servicePackages[indexPath.row]];
    return cell;
}

#pragma mark ---------collectionViewDelegateFlowLayout------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(general_padding, general_padding/2, general_padding/2, general_padding/2);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseServiceConditionsController *cscc = [[ChooseServiceConditionsController alloc]init];
    cscc.servicePackage = self.servicePackages[indexPath.row];
    cscc.priceList = self.priceList;
    cscc.stylist = self.stylist;
    [self.navigationController pushViewController:cscc animated:YES];
    [MobClick event:log_event_name_choose_service_package attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.stylist.name, @"发型师名字",nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_choose_service_packge;
}

@end
