//
//  SetNameController.h
//  styler
//
//  Created by System Administrator on 13-5-22.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetNameController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *saveBut;
@property (weak, nonatomic) IBOutlet UITextField *nameIn;
@property (weak, nonatomic) IBOutlet UIView *upSpliteLine;
@property (weak, nonatomic) IBOutlet UIView *downSpliteLine;

- (IBAction)saveNewName:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end
