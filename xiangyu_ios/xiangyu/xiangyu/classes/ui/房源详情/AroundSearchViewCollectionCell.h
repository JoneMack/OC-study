//
//  AroundSearchViewCollectionCell.h
//  xiangyu
//
//  Created by xubojoy on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AroundSearchViewCollectionCell : UICollectionViewCell

@property (nonatomic ,strong) UIImageView *iconImgView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *contentLabel;


@property (weak, nonatomic) IBOutlet UIView *separLine;


- (void)renderAroundSearchViewCollectionCellWithIcon:(NSString *)icon titleStr:(NSString *)titleStr contentStr:(NSString *)contentStr showLine:(BOOL)show;

@end
