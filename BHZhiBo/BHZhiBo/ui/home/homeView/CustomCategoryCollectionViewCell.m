//
//  HoneInOneCategoryCollectionViewCell.m
//  Golf
//
//  Created by xubojoy on 16/7/11.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import "CustomCategoryCollectionViewCell.h"

@implementation CustomCategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImgView.layer.cornerRadius = 5;
    self.iconImgView.layer.masksToBounds = YES;
}

- (void)updateConstraints{
    [super updateConstraints];
}

- (void)renderCustomCategoryCollectionViewCellWithItem:(NSInteger)item{
    self.contentView.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];
    self.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];

    if (item == 0){
        self.iconImgView.image = [UIImage imageNamed:@"1.jpg"];
        self.categoryTitleLabel.text = @"登录";
    }else if (item == 1){
        self.iconImgView.image = [UIImage imageNamed:@"2.jpg"];
        self.categoryTitleLabel.text = @"交流";
    }else if (item == 2){
        self.iconImgView.image = [UIImage imageNamed:@"3.jpg"];
        self.categoryTitleLabel.text = @"活动";
    }else if (item == 3){
        self.iconImgView.image = [UIImage imageNamed:@"4.jpg"];
        self.categoryTitleLabel.text = @"介绍";
    }else if (item == 4){
        self.iconImgView.image = [UIImage imageNamed:@"5.jpg"];
        self.categoryTitleLabel.text = @"财经";
    }else if (item == 5){
        self.iconImgView.image = [UIImage imageNamed:@"6.jpg"];
        self.categoryTitleLabel.text = @"注册";
    }else if (item == 6){
        self.iconImgView.image = [UIImage imageNamed:@"7.jpg"];
        self.categoryTitleLabel.text = @"学堂";
    }
    else{
        self.iconImgView.image = [UIImage imageNamed:@"8.jpg"];
        self.categoryTitleLabel.text = @"客服";
    }
}


@end
