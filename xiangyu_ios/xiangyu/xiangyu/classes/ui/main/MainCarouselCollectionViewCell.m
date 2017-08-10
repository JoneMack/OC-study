//
//  MainCarouselCollectionViewCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MainCarouselCollectionViewCell.h"

@implementation MainCarouselCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor whiteColor]];
}


-(void) renderView:(Banner *)banner
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:banner.url]];
}


-(void) renderViewWithUrl:(NSString *)imgUrl{
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

-(void) renderViewWithImgName:(NSString *) imgName {
    [self.imageView setImage:[UIImage imageNamed:imgName]];
}



@end
