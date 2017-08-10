//
//  AboutController.h
//  styler
//
//  Created by System Administrator on 13-7-15.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AboutUsController : UIViewController<UIGestureRecognizerDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
