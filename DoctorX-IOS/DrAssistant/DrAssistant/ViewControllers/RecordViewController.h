//
//  RecordViewController.h
//  DrAssistant
//
//  Created by taller on 15/10/5.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"
@interface RecordViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (void)getUserData;
@end
