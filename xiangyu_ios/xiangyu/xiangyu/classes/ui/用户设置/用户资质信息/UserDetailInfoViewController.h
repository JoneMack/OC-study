//
//  UserDetailInfoViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDPhotosCell.h"
#import "SelectUserSexCell.h"
#import "CustomerInfo.h"

@interface UserDetailInfoViewController : UIViewController <UITableViewDelegate , UITableViewDataSource >

@property (nonatomic , strong) HeaderView *headerView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;

@property (strong, nonatomic) SelectUserSexCell *selectUserSexCell;

@property (nonatomic , strong) IDPhotosCell *idPhotosCell;

@property (nonatomic , strong) CustomerInfo *customerInfo;

- (IBAction)saveInfo:(id)sender;


@end
