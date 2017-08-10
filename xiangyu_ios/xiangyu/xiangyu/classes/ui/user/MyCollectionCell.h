//
//  MyCollectionCell.h
//  xiangyu
//
//  Created by xubojoy on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
#import "OrderLookHouseInfo.h"
@interface MyCollectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewStatus;

@property (nonatomic ,weak) IBOutlet UILabel *nameLabel;

@property (nonatomic ,weak) IBOutlet UILabel *houseTypeLabel;

@property (nonatomic ,weak) IBOutlet UILabel *addressLabel;

@property (nonatomic ,weak) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *orderLookBtn;


- (void)setCellData:(CollectionModel *)obj;

- (void)renderMyCollectionCell:(OrderLookHouseInfo *)orderLookHouseInfo;

@end
