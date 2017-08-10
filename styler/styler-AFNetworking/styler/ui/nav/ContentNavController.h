//
//  ContentNavController.h
//  styler
//
//  Created by System Administrator on 14-2-11.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "Reminder.h"

@interface ContentNavController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) HeaderView *header;
@property (weak, nonatomic) IBOutlet UIButton *locBut;

@property (weak, nonatomic) IBOutlet UIView *wapper;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UIButton *selectPosition;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) UIButton *bigRetryBut;
@property BOOL hasLoadContent;
@property (strong, nonatomic) Reminder *reminder;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)selectPosition:(id)sender;
- (IBAction)showCityNote:(id)sender;

-(void) initWebView;
@end
