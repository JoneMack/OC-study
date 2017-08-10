//
//  BrandCell.m
//  styler
//
//  Created by System Administrator on 14-2-14.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "BrandCell.h"
#import "Brand.h"
#import "BrandItem.h"
#import "UIVIew+Custom.h"

@implementation BrandCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"BrandCell" owner:self options:nil] objectAtIndex:0];
        //设置左边的品牌
        self.leftBrandItem = [[BrandItem alloc] initWithFrame:CGRectMake(0, -1, screen_width/2 -general_padding, brand_cell_height + 2)];
        [self addSubview:self.leftBrandItem];
        [self.leftBrandItem addStrokeBorderWidth:0.5 cornerRadius:0 color:[ColorUtils colorWithHexString:splite_line_color]];
        //设置右边的品牌
        self.rightBrandItem = [[BrandItem alloc] initWithFrame:CGRectMake(screen_width/2 -general_padding + 1, 0, screen_width/2, brand_cell_height)];
        [self addSubview:self.rightBrandItem];
        //设置分割线
        self.spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        CGRect frame = self.spliteLine.frame;
        frame.size.height = splite_line_height;
        frame.origin.y = 0;
        self.spliteLine.frame = frame;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)initLeftBrand:(Brand *)leftBrand rightBrand:(Brand *)rightBrand
{
    [self.leftBrandItem initUI:leftBrand];
    [self.rightBrandItem initUI:rightBrand];
}

@end
