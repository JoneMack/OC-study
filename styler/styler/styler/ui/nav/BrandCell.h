//
//  BrandCell.h
//  styler
//
//  Created by System Administrator on 14-2-14.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandItem.h"
#import "Brand.h"

@interface BrandCell : UITableViewCell

@property (strong, nonatomic) BrandItem *leftBrandItem;
@property (strong, nonatomic) BrandItem *rightBrandItem;
@property (weak, nonatomic) IBOutlet UIView *spliteLine;

-(void) initLeftBrand:(Brand *)leftBrand rightBrand:(Brand *)rightBrand;

@end
