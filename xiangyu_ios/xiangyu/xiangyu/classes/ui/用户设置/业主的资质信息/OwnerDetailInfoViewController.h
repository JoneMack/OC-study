//
//  OwnerDetailInfoViewController.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/11.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnerDetailInfoViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property (strong , nonatomic) HeaderView *headerView;

@property (strong, nonatomic) IBOutlet UITableView *bodyView;

@end
