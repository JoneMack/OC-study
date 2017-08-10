//
//  ChangeServicePackageController.h
//  styler
//
//  Created by wangwanggy820 on 14-3-29.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "Stylist.h"
#import "OrderNavigationBarItem.h"
#import "StylistServicePackage.h"
#import "StylistPriceList.h"

@interface ChooseServicePackageController : UIViewController<UICollectionViewDataSource,  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) HeaderView *header;
@property (strong, nonatomic) Stylist *stylist;
@property (nonatomic, retain) StylistPriceList *priceList;
@property (strong, nonatomic) NSMutableArray *servicePackages;

-(id)initWithStylist:(Stylist *)stylist;

@end
