//
//  YuYueOrderNameViewController.h
//  DrAssistant
//
//  Created by taller on 15/10/10.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"

@interface YuYueOrderNameViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataNameArr;
@end
