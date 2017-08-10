//
//  MainCarouselCollectionViewCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Banner.h"

@interface MainCarouselCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;


-(void) renderView:(Banner *)banner;

-(void) renderViewWithUrl:(NSString *)imgUrl;


-(void) renderViewWithImgName:(NSString *) imgName;

@end
