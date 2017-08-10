//
//  PriceCollectionViewCell.h
//  styler
//
//  Created by System Administrator on 14-4-1.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylistServiceItemPrice.h"

#define txt_line_height 16
#define txt_line_space 2

@interface PriceCollectionViewCell : UICollectionViewCell
//@property (weak, nonatomic) IBOutlet UIView *deleteLine;
//@property (weak, nonatomic) IBOutlet UILabel *originYuan;
//@property (weak, nonatomic) IBOutlet UILabel *originPrice;


@property (weak, nonatomic) IBOutlet UILabel *originYuan;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPrice;

+(float) judgeHeight:(StylistServiceItemPrice *)price;
-(void)renderUI:(StylistServiceItemPrice *)price;
-(void) updatePrice:(int)price specialOfferPrice:(int)specialOfferPrice;
@end
