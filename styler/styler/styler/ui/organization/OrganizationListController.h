//
//  OrganizationController.h
//  styler
//
//  Created by wangwanggy820 on 14-4-21.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Brand.h"
#import "OrganizationStore.h"

#define right_btn_width               44
#define right_btn_height              44
#define right_btn_x                   271
#define order_type_list_cell_height   40
#define orderTypeList_frame_width     80
#define loading_cell_height             75
#define organization_order_by_distance    2
#define organization_order_by_price       3
#define organization_order_by_business_circle  5
#define organization_order_by_reserve   true
#define organization_order_by_unreserve false
@interface OrganizationListController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *organizationTableView;
@property (strong, nonatomic) HeaderView *header;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSMutableArray *organizations;
@property (nonatomic,strong)NSMutableArray *hdcs;

@property int orderType;//排序类型
@property BOOL reserve;//排序时正序/反序
@property (copy, nonatomic) NSString *poi;//位置

-(id)initWithUrl:(NSString *)url title:(NSString *)title;

@end
