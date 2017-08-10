//
//  UserSettingViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/6.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfo.h"

@interface UserSettingViewController : UIViewController <UITableViewDelegate , UITableViewDataSource , UIAlertViewDelegate ,
                                                        UIActionSheetDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate >


@property (nonatomic , strong) HeaderView *headerView;



@property (strong, nonatomic) IBOutlet UITableView *bodyView;

@property (strong, nonatomic) IBOutlet UIView *bottomBgView;

@property (strong, nonatomic) IBOutlet UIButton *logoutBtn;

@property (strong, nonatomic) CustomerInfo *customerInfo;


- (IBAction)logout:(id)sender;

@end
