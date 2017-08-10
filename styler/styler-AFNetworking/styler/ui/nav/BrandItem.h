//
//  BrandItem.h
//  styler
//
//  Created by wangwanggy820 on 14-4-19.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand.h"

@protocol OrganizationDelegate <NSObject>

-(void)gotoSameOrganizationListController:(UIViewController *)viewController;

@end

@interface BrandItem : UIView

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (strong, nonatomic) Brand *brand;
@property (assign, nonatomic) id<OrganizationDelegate>delegate;

- (IBAction)gotoSameOrganizationListController:(id)sender;
-(void) initUI:(Brand *)brand;

@end
