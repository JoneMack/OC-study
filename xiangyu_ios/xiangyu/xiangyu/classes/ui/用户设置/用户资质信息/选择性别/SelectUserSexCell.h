//
//  SelectUserSexCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/7/15.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfo.h"

@interface SelectUserSexCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UIButton *manBtn;

@property (strong, nonatomic) IBOutlet UIButton *womanBtn;

@property (strong, nonatomic) IBOutlet UIView *lineView;


- (IBAction)manEvent:(id)sender;

- (IBAction)womanEvent:(id)sender;

-(NSString *)getSelectedSex;

-(void) renderData:(CustomerInfo *)customerInfo;




@end
