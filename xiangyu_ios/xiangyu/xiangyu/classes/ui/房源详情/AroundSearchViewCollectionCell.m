//
//  AroundSearchViewCollectionCell.m
//  xiangyu
//
//  Created by xubojoy on 16/7/1.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "AroundSearchViewCollectionCell.h"

@implementation AroundSearchViewCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.separLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    
    self.iconImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImgView];
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:small_font_size];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [ColorUtils colorWithHexString:@"#2b2b2b"];
    [self.contentView addSubview:self.titleLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 16+5, self.frame.size.width-20, self.frame.size.height-16-5)];
    self.contentLabel.font = [UIFont systemFontOfSize:10];
    self.contentLabel.textColor = [ColorUtils colorWithHexString:@"#595959"];
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
//    self.contentLabel.backgroundColor = [UIColor purpleColor];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
}

- (void)renderAroundSearchViewCollectionCellWithIcon:(NSString *)icon titleStr:(NSString *)titleStr contentStr:(NSString *)contentStr showLine:(BOOL)show{
    
    self.iconImgView.image = [UIImage imageNamed:icon];
    
    
   CGSize titleLabelSize = [FunctionUtils getCGSizeByString:titleStr font:small_font_size];
    
    self.iconImgView.frame = CGRectMake((self.contentView.frame.size.width-16-4-titleLabelSize.width)/2, 0, 16, 16);
    
    self.titleLabel.frame = CGRectMake((self.contentView.frame.size.width-16-4-titleLabelSize.width)/2+16+4, 0, titleLabelSize.width, 16);
    self.titleLabel.text = titleStr;
    
    self.contentLabel.text = contentStr;

    if (show) {
        self.separLine.hidden = NO;
    }else{
        self.separLine.hidden = YES;
    }
    
}


@end
