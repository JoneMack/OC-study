//
//  PriceListController.m
//  styler
//
//  Created by System Administrator on 14-4-1.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "PriceListController.h"
#import "PriceView.h"
#import "UIViewController+Custom.h"
#import "StylistStore.h"

@interface PriceListController ()

@end

@implementation PriceListController

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
    [self initHeader];
    [self initWrapper];
}

-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_price_list navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void)initWrapper{
    int height = self.view.frame.size.height - self.header.frame.size.height;
    
    CGRect frame = CGRectMake(0, self.header.frame.size.height, self.view.frame.size.width, height);
    self.wrapper.frame = frame;
    self.wrapper.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    
    [SVProgressHUD showWithStatus:network_status_loading];
    StylistStore *stylistStore = [StylistStore sharedStore];
    [stylistStore getStylistPriceList:^(StylistPriceList *priceList, NSError *err) {
        self.priceList = priceList;
        
        float y = 0;
        for (int i = 0; i < self.priceList.stylistServiceItems.count; i++) {
            StylistServiceItem *serviceItem = self.priceList.stylistServiceItems[i];
            float height = [PriceView judgeHeight:serviceItem];
            CGRect frame = CGRectMake(0, y, self.view.frame.size.width, height);
            PriceView *priceView = [[PriceView alloc] initWithFrame:frame];
            priceView.priceCollectionView.delegate = self;
            [self.wrapper addSubview:priceView];
            [priceView renderUI:serviceItem currentSelectedIndexPath:nil];
            y += height;
        }
        self.wrapper.contentSize = CGSizeMake(self.view.frame.size.width, y);
        
        [SVProgressHUD dismiss];
    } stylistId:self.stylist.id];
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_price_list;
}

@end
