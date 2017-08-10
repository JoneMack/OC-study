//
//  OrganizationSpecialOfferListViewController.h
//  styler
//
//  Created by 冯聪智 on 14-9-23.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define special_offer_list_status_waiting_load   1
#define special_offer_list_status_loading        2
#define special_offer_list_status_load_over      3
#define special_offer_list_status_load_fail      4
#define special_offer_list_status_load_success   5

#define event_init_load        1
#define event_load_success     2
#define event_load_over        3
#define event_load_fail        4
#define event_pull_up          5

#import <UIKit/UIKit.h>
#import "OrganizationFilterView.h"
#import "OrganizationFilter.h"
#import "SpecialOfferCellView.h"


@interface OrganizationSpecialOfferListViewController : UIViewController <UITableViewDataSource ,
                                                                          UITableViewDelegate ,
                                                                          OrganizationFilterViewDelegate,
                                                                          SpecialOfferCellViewDelegate>


@property (nonatomic, strong) HeaderView *header;
@property (nonatomic, strong) OrganizationFilterView *organizationFilterView;
@property (nonatomic, strong) OrganizationFilter *organizationFilter;
@property (nonatomic, strong) UIView *marginBlock;

@property (nonatomic, strong) UITableView *specialOfferListTableView;
@property (copy, nonatomic) NSString *selectedBrandName;
@property (nonatomic, strong) UIView *showMoreLine;
@property (nonatomic, strong) UIButton *showMoreButton;
@property (nonatomic, strong) UIView *bottomLineView;
//@property int hdcType;
@property int currentTableViewStatus;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


-(id) initWithOrganizationFilter:(OrganizationFilter *)organizationFilter;


@end
