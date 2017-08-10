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
#import "ShareContent.h"

@interface ContentNavController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (nonatomic , strong) HeaderView *header;
@property (nonatomic , weak) IBOutlet UIButton *locBut;

@property (nonatomic , weak) IBOutlet UIView *wapper;
@property (nonatomic , weak) IBOutlet UILabel *position;
@property (nonatomic , weak) IBOutlet UIButton *selectPosition;

@property (nonatomic , weak) IBOutlet UIWebView *webView;
@property (nonatomic , strong) UIButton *bigRetryBut;
@property BOOL hasLoadContent;
@property (nonatomic , strong) Reminder *reminder;
@property (nonatomic , weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic , strong) UIImage *shareImage;


- (IBAction)selectPosition:(id)sender;
- (IBAction)showCityNote:(id)sender;

-(void) initWebView;
-(ShareContent *) collectionShareContent;

@end
