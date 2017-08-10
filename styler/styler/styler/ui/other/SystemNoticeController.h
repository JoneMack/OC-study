//
//  SystemNoticeController.h
//  styler
//
//  Created by System Administrator on 13-6-21.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemNoticeController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *systemNoticeTableView;

@property (nonatomic, retain) NSArray *notices;


@end
