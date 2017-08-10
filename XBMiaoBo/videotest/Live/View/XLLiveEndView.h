//
//  XLLiveEndView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

@interface XLLiveEndView : UIView

/** 查看其他主播 */
@property (nonatomic, copy) void (^lookOtherBlock)();
/** 退出 */
@property (nonatomic, copy) void (^quitBlock)();

@property (nonatomic, strong) LiveListModel *hotModel;

+ (instancetype)liveEndView;
@end
