//
//  LeftBodyView.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/13.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LeftBodyView : UIView  <UITableViewDelegate , UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *avatarBtn;

@property (strong, nonatomic) IBOutlet UIButton *loginBtn;

@property (strong, nonatomic) IBOutlet UIButton *regBtn;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *phone;

@property (strong, nonatomic) UINavigationController *navigationController;

-(instancetype) initWithNavigationController:(UINavigationController *) navigationController;

- (IBAction)userLogin:(id)sender;


- (IBAction)phoneEvent:(id)sender;



-(void) renderUserInfo;

@end
