//
//  PriceView.m
//  styler
//
//  Created by System Administrator on 14-4-1.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "PriceView.h"
#import "PriceCollectionViewCell.h"

@implementation PriceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PriceView" owner:self options:nil] objectAtIndex:0];
        
        self.frame = frame;
        
        //设置服务名
        self.serviceName = [[UILabel alloc] init];
        self.serviceName.textAlignment = NSTextAlignmentRight;
        
        self.serviceName.textColor = [ColorUtils colorWithHexString:black_text_color];
        self.serviceName.font = [UIFont systemFontOfSize:default_font_size];
        self.serviceName.numberOfLines = 0;
        self.serviceName.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)updateSelectedPrice:(int)price specialOfferPrice:(int)specialOfferPrice{
    for (int i = 0; i < self.serviceItem.serviceItemPrices.count; i++) {
        //NSLog(@">>>>>> i:%d", i);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PriceCollectionViewCell *cell = (PriceCollectionViewCell*)[self.priceCollectionView cellForItemAtIndexPath:indexPath];
        if (self.currentIndexPath.section == indexPath.section
                              && self.currentIndexPath.item == indexPath.item) {
            [cell updatePrice:price specialOfferPrice:specialOfferPrice];
        }
    }
}

-(void) renderUI:(StylistServiceItem *)serviceItem currentSelectedIndexPath:(NSIndexPath *)indexPath{
    self.serviceItem = serviceItem;
    self.currentIndexPath = indexPath;
    //设置服务名的布局
    self.serviceName.text = serviceItem.name;
    CGSize fiveCharacterSize = [@"四个汉字" sizeWithFont:self.serviceName.font constrainedToSize:CGSizeMake(200, 25) lineBreakMode:NSLineBreakByCharWrapping];
    float serviceNameWidth = fiveCharacterSize.width;
    
    CGSize nameSize = [self.serviceName.text sizeWithFont:self.serviceName.font constrainedToSize:CGSizeMake(serviceNameWidth, 100) lineBreakMode:NSLineBreakByCharWrapping];
    
    self.serviceName.frame = CGRectMake(price_view_padding, price_view_padding, serviceNameWidth, nameSize.height);
    [self addSubview:self.serviceName];
    
    
    //设置服务价格集合视图
    self.priceCollectionView.backgroundColor = [UIColor clearColor];
    [self.priceCollectionView registerClass:PriceCollectionViewCell.class forCellWithReuseIdentifier:@"PriceCollectionViewCell"];
    
    float serviceNamePlaceHoldWidth = serviceNameWidth+price_view_padding;
    float priceCollectionViewWidth = self.frame.size.width - price_view_padding*2 - serviceNamePlaceHoldWidth;
    self.priceCollectionView.frame = CGRectMake(serviceNamePlaceHoldWidth+price_view_padding, price_view_padding, priceCollectionViewWidth, [PriceView judgeCollectionViewHeight:serviceItem]);
    self.priceCollectionView.backgroundColor = [UIColor clearColor];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    float itemWidth = (priceCollectionViewWidth - 2*price_cell_margin)/3;
    float itemHeight = [PriceCollectionViewCell judgeHeight:(StylistServiceItemPrice *)serviceItem.serviceItemPrices[0]];
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumInteritemSpacing = price_cell_margin;
    layout.minimumLineSpacing = price_cell_margin;
    
    self.priceCollectionView.collectionViewLayout = layout;
    self.priceCollectionView.dataSource = self;
    
    [self.priceCollectionView scrollToItemAtIndexPath:indexPath
                                     atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    [self.priceCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionBottom];
    
    self.separatorLine.frame = CGRectMake(general_padding, self.frame.size.height-splite_line_height, self.frame.size.width-general_padding, splite_line_height);
    self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.serviceItem.serviceItemPrices.count;
}


-(UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PriceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PriceCollectionViewCell" forIndexPath:indexPath];
    StylistServiceItemPrice *price = self.serviceItem.serviceItemPrices[indexPath.row];
    [cell renderUI:price];
    
    if (self.currentIndexPath != nil
        && self.currentIndexPath.section == indexPath.section
        && self.currentIndexPath.item == indexPath.item) {
        CALayer *layer  = cell.layer;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:0];
        [layer setBorderWidth:2.0f];
        [layer setBorderColor:[ColorUtils colorWithHexString:orange_text_color].CGColor];
        cell.selected = YES;
    }
    return cell;
}

+(float) judgeCollectionViewHeight:(StylistServiceItem *)serviceItem{
    //单元格高度
    StylistServiceItemPrice *price = (StylistServiceItemPrice *)serviceItem.serviceItemPrices[0];
    float cellHeight = [PriceCollectionViewCell judgeHeight:price];
    
    //所有单元格以及间距总和得到集合视图高度
    int rows = serviceItem.serviceItemPrices.count%3==0?(serviceItem.serviceItemPrices.count/3):(serviceItem.serviceItemPrices.count/3+1);
    return cellHeight*rows+(rows-1)*price_cell_margin;
}

+(float) judgeHeight:(StylistServiceItem *)serviceItem{
    return [PriceView judgeCollectionViewHeight:serviceItem] + 2*price_view_padding;
}


@end
