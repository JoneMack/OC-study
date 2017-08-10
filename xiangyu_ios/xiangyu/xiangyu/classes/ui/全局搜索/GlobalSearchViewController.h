//
//  GlobalSearchViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/4.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotCircleCollectionView.h"

@interface GlobalSearchViewController : UIViewController <UITextFieldDelegate , UITableViewDelegate , UITableViewDataSource , UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *headerBlock;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) IBOutlet UIView *searchBg;


@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) UIView *separatorLine;

@property (strong, nonatomic) HotCircleCollectionView *hotCircleCollectionView;




- (IBAction)cancelSearch:(id)sender;











@end
