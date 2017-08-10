//
//  BindingSocailAccountController.h
//  styler
//
//  Created by aypc on 13-11-22.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "BindingSocailAccountController.h"
#import "HeaderView.h"
@interface BindingSocailAccountController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray * bindingArray;
    NSString* text;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HeaderView *header;

@end
