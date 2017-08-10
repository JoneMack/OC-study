//
//  XLUserInfoView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

@interface XLUserInfoView : UIView

- (void)userWithHotModel:(LiveListModel *)hotModel ofView:(UIView *)view;

@property (nonatomic, copy) void (^selectedBlock)();

+ (instancetype)userInfoView;
@end
