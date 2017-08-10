//
//  MainFindWayCellView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/12.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainFindWayCellView : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *logo;

@property (strong, nonatomic) IBOutlet UILabel *name;

-(void) setLogoAndName:(NSString *)logo name:(NSString *)name;

@end
