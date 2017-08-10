//
//  XLAnchorInfoView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"


@interface XLAnchorInfoView : UIView


@property (nonatomic, strong) LiveListModel *hotModel;

@property (nonatomic, strong) NSArray *allModels;

@property (nonatomic, copy) void (^selectBlock)(LiveListModel *hotModel);

+ (instancetype)anchorInfoView;
@end
