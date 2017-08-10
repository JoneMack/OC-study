//
//  ExpertIntroductionController.h
//  styler
//
//  Created by System Administrator on 14-1-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"

@interface StylistIntroductionController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (strong, nonatomic) HeaderView *header;

@property (copy, nonatomic) NSString *stylistName;
@property (copy, nonatomic) NSString *introductionTxt;

@end
