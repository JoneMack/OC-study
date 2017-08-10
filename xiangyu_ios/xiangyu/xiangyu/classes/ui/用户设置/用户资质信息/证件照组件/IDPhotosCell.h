//
//  IDPhotosCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDPhotoView.h"
#import "CustomerInfo.h"

@interface IDPhotosCell : UITableViewCell

@property (nonatomic , strong) IDPhotoView *firstIDPhoto;

@property (nonatomic , strong) IDPhotoView *secondIDPhoto;

@property (nonatomic , strong) IDPhotoView *thirdIDPhoto;




-(void) renderUI;


-(void) renderData:(CustomerInfo *)customerInfo;


@end
