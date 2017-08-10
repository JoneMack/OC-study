//
//  AddHeahthDataController.h
//  DrAssistant
//
//  Created by hi on 15/9/5.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"
#import "MyClubEntity.h"

@interface AddHeahthDataController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MyClubEntity *myClub;
@end
