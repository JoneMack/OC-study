//
//  IndexController.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/15.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexHeaderView.h"

@interface IndexController : UIViewController <UITableViewDataSource , UITableViewDelegate , IndexHeaderDelegate>

@property (nonatomic , strong) UITableView *bodyTableView;

@property (nonatomic , strong) IndexHeaderView *indexHeaderView;

@property (nonatomic , strong) NSArray *experts;
@property (nonatomic , strong) NSMutableArray *expertMessages;
@property (nonatomic , strong) NSMutableArray *expertMessagesFrames;

@property int currentTableViewStatus;


@end
