//
//  FeedbackController.h
//  styler
//
//  Created by System Administrator on 13-6-24.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"

@interface FeedbackController : UIViewController<UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *feedbackTable;

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomBg;
@property (weak, nonatomic) IBOutlet UITextField *feedbackIn;

@property (nonatomic, retain) UITapGestureRecognizer *tapGr;
@property (nonatomic, retain) NSMutableArray *msgs;
@property (strong, nonatomic) HeaderView *header;
@property BOOL stayup;

@end
