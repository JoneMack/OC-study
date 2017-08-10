//
//  AllBrandController.h
//  styler
//
//  Created by System Administrator on 14-2-14.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "Brand.h"
#import "BrandItem.h"

@interface AllBrandController : UIViewController<UITableViewDataSource,UITableViewDelegate,OrganizationDelegate>

@property (weak, nonatomic) IBOutlet UITableView *brandListTable;
@property (strong, nonatomic) HeaderView *header;

@property (strong, nonatomic) NSMutableArray *brands; //品牌
@property (strong, nonatomic) NSMutableArray *sectionArray; //每个section的数组，为二维数组
@property (strong, nonatomic) UILocalizedIndexedCollation *theCollation;
@property (strong, nonatomic) NSMutableArray *sectionIndexTitleArray;//section 的 title

@end
