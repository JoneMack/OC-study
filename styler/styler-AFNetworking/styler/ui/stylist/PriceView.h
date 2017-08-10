//
//  PriceView.h
//  styler
//
//  Created by System Administrator on 14-4-1.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylistServiceItem.h"

#define price_view_padding 10
#define price_cell_margin 5

@interface PriceView : UIView<UICollectionViewDataSource>

@property (strong, nonatomic) UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UICollectionView *priceCollectionView;
@property (weak, nonatomic) IBOutlet UIView *separatorLine;

@property (strong, nonatomic) StylistServiceItem *serviceItem;
@property int currentIndex;
@property NSIndexPath *currentIndexPath;

+(float)judgeHeight:(StylistServiceItem *)serviceItem;
-(void)renderUI:(StylistServiceItem *)serviceItem currentSelectedIndexPath:(NSIndexPath *)indexPath;
-(void)updateSelectedPrice:(int)price specialOfferPrice:(int)specialOfferPrice;
@end
