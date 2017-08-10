//
//  OrderServiceItemsController.m
//  styler
//
//  Created by System Administrator on 14-4-9.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "OrderServiceItemsController.h"
#import "UIView+Custom.h"
#import "UIViewController+Custom.h"
#define service_item_cell_height 52

@interface OrderServiceItemsController ()

@end

@implementation OrderServiceItemsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOrder:(ServiceOrder *)order{
    self = [super init];
    self.serviceOrder = order;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader];
    [self layoutView];
    [self renderView];
}

-(void)initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_order_service_items navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void) layoutView{
    [self layoutAmountView];
    [self layoutServiceItemsTableView];
}

-(void) layoutAmountView{
    CGRect frame = self.amountView.frame;
    frame.origin.y = [self.header bottomY] + @(general_margin).floatValue;
    frame.size.height = 37;
    self.amountView.frame = frame;
    
    self.totalPriceTabel.clipsToBounds = NO;
}

-(void) layoutServiceItemsTableView{
    float y = [self.amountView bottomY] + general_margin;
    float height = [self judgeServiceItemsTableViewHeight];
    CGRect frame = self.serviceItemsTableView.frame;
    frame.origin.y = y;
    frame.size.height = height;
    self.serviceItemsTableView.frame = frame;
    self.serviceItemsTableView.scrollEnabled = NO;
}

-(float) judgeServiceItemsTableViewHeight{
    return self.serviceOrder.orderServiceItems.count*service_item_cell_height;
}


-(void) renderView{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    [self renderAmountView];
    [self renderServiceItemsTableView];
}

-(void) renderAmountView
{
    self.amountView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = self.amountView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:0];
    [layer setBorderWidth:0.5f];
    [layer setBorderColor:[ColorUtils colorWithHexString:splite_line_color].CGColor];
    //渲染总金额
    self.totalPriceTabel.font = [UIFont systemFontOfSize:default_font_size];
    self.totalPriceTabel.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.totalPriceTabel.backgroundColor = [UIColor clearColor];
    //金额
    self.totalPriceInfo.font = [UIFont systemFontOfSize:default_font_size];
    self.totalPriceInfo.textColor = [ColorUtils colorWithHexString:orange_text_color];
    self.totalPriceInfo.backgroundColor = [UIColor clearColor];
    self.totalPriceInfo.text = [NSString stringWithFormat:@"￥%d",self.serviceOrder.specialOfferPrice];
}

-(void) renderServiceItemsTableView
{
    self.serviceItemsTableView.dataSource = self;
    self.serviceItemsTableView.delegate = self;
    [self.serviceItemsTableView registerClass:[OrderServiceItemsCell class] forCellReuseIdentifier:@"OrderServiceItemsCell"];
    self.serviceItemsTableView.layer.masksToBounds = YES;
    self.serviceItemsTableView.layer.borderWidth = splite_line_height;
    self.serviceItemsTableView.layer.borderColor = [[ColorUtils colorWithHexString:splite_line_color] CGColor];
}

#pragma mark ------dataSource ----
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serviceOrder.orderServiceItems.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return service_item_cell_height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderServiceItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderServiceItemsCell"];
    [cell renderOrderServiceItems:self.serviceOrder.orderServiceItems[indexPath.row]];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_order_service_items;
}

@end
