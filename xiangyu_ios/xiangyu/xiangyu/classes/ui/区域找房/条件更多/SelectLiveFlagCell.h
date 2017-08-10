//
//  SelectLiveFlagCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/21.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectLiveFlagCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIButton *liveFlagBtn;

@property (strong, nonatomic) IBOutlet UIView *lineView;


- (IBAction)selectEvent:(id)sender;


-(NSString *) getStatus;

@end
