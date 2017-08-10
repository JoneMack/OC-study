//
//  EvaluationImages.h
//  styler
//
//  Created by wangwanggy820 on 14-3-26.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "JSONSerializable.h"

@protocol EvaluationPicture
@end
@interface EvaluationPicture : JSONModel

@property int width;
@property int height;
@property (copy, nonatomic) NSString *pictureUrls;
@property (copy, nonatomic) NSString *pictureThumbnailUrls;

@end
