//
//  HealthDataController.h
//  DrAssistant
//
//  Created by xubojoy on 15/10/24.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "HealthTopDateView.h"

@interface HealthDataController : BaseViewController<HealthTopDateViewDelegate>
@property (nonatomic, strong) NSString *friendId;
@property (nonatomic, strong) HealthTopDateView *healthTopDateView;
@end
