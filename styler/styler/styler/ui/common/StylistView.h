//
//  ExpertListView.h
//  styler
//
//  Created by aypc on 13-10-2.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#define load_status_waiting_load       0
#define load_status_first_not_network  1
#define load_status_not_network        2
#define load_status_no_more            4
#define load_status_loading            5
#define load_status_request_fail       3
#define load_status_request_first_fail 6

#define tableviewcellheight      75


@protocol PushToStylistProfileDelegate <NSObject>
@optional
-(void)pushToExpertProfile:(NSString*)idStr;

@end

#import <UIKit/UIKit.h>

@interface StylistView : UIScrollView<UITableViewDataSource,UITableViewDelegate>
{
    
    NSMutableArray *stylistes;
    UIView *footerView;
    UILabel *loadStatusLabel;
    UIActivityIndicatorView *loadStatusIndicator;
    BOOL hasMore;
    int loadStatus;
    int currentPageNo;
    BOOL loading;
    UIButton *reloadBtn;
    int currentRow;
}

@property (copy, nonatomic) NSString * requestUri;
@property (weak, nonatomic) IBOutlet UITableView *stylistTableView;
@property int stylerType;
@property (weak, nonatomic) UIViewController *controller;
@property (strong, nonatomic) UIButton *reloadBtn;
@property (strong, nonatomic) UILabel *networkLable;
@property (strong, nonatomic) NSMutableArray *stylistes;

-(id)initWithRequestUri:(NSString *)requestUri andFrame:(CGRect)frame controller:(UIViewController *)controller;
-(void)updataTableView:(NSNotification *)info;

@end
