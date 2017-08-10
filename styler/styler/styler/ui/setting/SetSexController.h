//
//  SetSexController.h
//  styler
//
//  Created by aypc on 13-9-30.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetSexController : UIViewController
{
    // 0 为男性，1 为女性
    int selectedSex;
}

@property (weak, nonatomic) IBOutlet UIImageView *maleSelectedIcon;
@property (weak, nonatomic) IBOutlet UIImageView *femaleSelectedIcon;
@property (weak, nonatomic) IBOutlet UIView *upSpliteLine;
@property (weak, nonatomic) IBOutlet UIView *middleSpliteLine;
@property (weak, nonatomic) IBOutlet UIView *downSpliteLine;

@property (weak, nonatomic) IBOutlet UIView *topView;

@end
