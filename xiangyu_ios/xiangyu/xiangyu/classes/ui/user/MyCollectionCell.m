//
//  MyCollectionCell.m
//  xiangyu
//
//  Created by xubojoy on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MyCollectionCell.h"

@implementation MyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.orderLookBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.orderLookBtn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    self.orderLookBtn.layer.cornerRadius = 2;
    self.orderLookBtn.layer.masksToBounds = YES;
    self.orderLookBtn.hidden = YES;
}

- (void)setCellData:(CollectionModel *)obj
{
    self.imageViewStatus.image = obj.isSelected ? [UIImage imageNamed:@"icons_selected"] : [UIImage imageNamed:@"icons_unselected"];
    if ([NSStringUtils isNotBlank:obj.fmpic]) {
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:obj.fmpic] placeholderImage:[UIImage imageNamed:@"zhanweitu_small"]];
    }
    self.nameLabel.text = [obj getName];
    self.houseTypeLabel.text = [NSString stringWithFormat:@"%@%@厅",obj.fewRoom,obj.fewHall];
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@㎡",obj.inDistrict,obj.circle,obj.space];
    self.priceLabel.text = obj.rentPrice;
    if ([obj.rentStatus isEqualToString:@"1"]) {
        self.orderLookBtn.hidden = YES;
    }else{
        self.orderLookBtn.hidden = NO;
    }
}

- (void)renderMyCollectionCell:(OrderLookHouseInfo *)orderLookHouseInfo{
    NSLog(@">>>>>>>渲染>>>>>>%@",orderLookHouseInfo);
    self.imageViewStatus.image = orderLookHouseInfo.isSelected ? [UIImage imageNamed:@"icons_selected"] : [UIImage imageNamed:@"icons_unselected"];
    if ([NSStringUtils isNotBlank:orderLookHouseInfo.fmpic]) {
            [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:orderLookHouseInfo.fmpic] placeholderImage:[UIImage imageNamed:@"zhanweitu_small"]];
    }

    self.nameLabel.text = [orderLookHouseInfo getName];
    self.houseTypeLabel.text = [NSString stringWithFormat:@"%d室%d厅",orderLookHouseInfo.houseFewRoom,orderLookHouseInfo.houseFewHall];
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %d㎡",orderLookHouseInfo.houseInDistrict,orderLookHouseInfo.houseCircle,orderLookHouseInfo.houseSpace];
    self.priceLabel.text = orderLookHouseInfo.rentPrice;
    
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews)
                {
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img=(UIImageView *)v;
                        
                        img.hidden = YES;
                    }
                }
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.orderLookBtn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        [self.orderLookBtn setBackgroundColor:[ColorUtils colorWithHexString:bg_purple]];
    }
}


@end
