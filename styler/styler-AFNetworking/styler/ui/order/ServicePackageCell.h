//
//  ServicePackageCell.h
//  styler
//
//  Created by wangwanggy820 on 14-3-31.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylistServicePackage.h"


#define collection_cell_width  152
#define collection_cell_height  145
#define collection_cell_item_margin 5
#define collection_cell_txt_line_height 20

@interface ServicePackageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *servicePackagePicture;
@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *serviceOriginPirceInfo;
@property (weak, nonatomic) IBOutlet UILabel *priceOfOrderInfo;
@property (weak, nonatomic) IBOutlet UIView *lineOfPrice;

-(void)renderServicePackage:(StylistServicePackage *)servicePackage;
+(float)getServiceCellHeight;

@end
