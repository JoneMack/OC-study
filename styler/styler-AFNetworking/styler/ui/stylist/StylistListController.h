//
//  BusinessCirclesExpertController.h
//  styler
//
//  Created by System Administrator on 14-2-17.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StylistView.h"

@interface StylistListController : UIViewController

@property (nonatomic , strong) StylistView * stylistView;
@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, copy) NSString *title;
@property int stylerType;

-(id) initWithRequestUrl:(NSString *)requestUrl title:(NSString *)title type:(int)stylerType;

@end
