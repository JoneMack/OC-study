//
//  RedpacketController.h
//  RuntimeTest
//
//  Created by xubojoy on 2018/1/23.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedpacketController : UIViewController

@property (nonatomic, strong) UIButton *beginBtn;
@property (nonatomic, strong) UIButton *endBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CALayer *moveLayer;
@property (nonatomic, strong) UIView *bgView;
@end
