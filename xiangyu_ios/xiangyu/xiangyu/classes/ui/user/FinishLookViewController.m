//
//  FinishLookViewController.m
//  xiangyu
//
//  Created by xubojoy on 16/8/8.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "FinishLookViewController.h"
#import "MyCollectionCell.h"
#import "OrderLookHouseInfo.h"
#import "HouseStore.h"

@interface FinishLookViewController ()
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic) BOOL isSelected;

@property (nonatomic, strong) UIButton *leftAllDeleteBtn;
@property (nonatomic, strong) UIButton *rightDeleteBtn;

@property int currentPageNo;
@property int pageSize;
@property int currentTableViewStatus;
@property int currentEventType;

@end
static NSString *myCollectionCellIdentifier = @"finishLookCell";
@implementation FinishLookViewController

-(instancetype)initWithSelectBtn:(UIButton *)btn navigationController:(UINavigationController *)navigationController{
    self = [super init];
    if (self) {
        self.selectBtn = btn;
        self.navigationController = navigationController;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    debugMethod();
    NSLog(@"========已完成的预约=====");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.selectBtn addTarget:self action:@selector(selectedFnishBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedFnishHouseIdArray = [NSMutableArray new];
    [self initTableView];
    self.currentPageNo = 1;
    self.currentTableViewStatus = load_data_status_waiting_load;
    [self transformEvent:event_load_data_init_load];
    [self initFooterView];
}

- (void)loadData{
    
    [[HouseStore sharedStore] getUserfinishedOrderList:^(NSArray *userOrderDetails, NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.currentTableViewStatus = load_data_status_waiting_load;
        if(self.finishLookHouseArray == nil){
            self.finishLookHouseArray = [NSMutableArray new];
        }
        if(userOrderDetails != nil && userOrderDetails.count >0){
            [self.finishLookHouseArray addObjectsFromArray:userOrderDetails];
            
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.currentTableViewStatus = load_data_status_load_over;
        }
        NSLog(@">>>>>>已完成约看>>>>>>%@------%@",userOrderDetails,self.finishLookHouseArray);
        [self initModelData];
        [self.tableView reloadData];
        
    } pageNum:[NSString stringWithFormat:@"%d",self.currentPageNo]];
}

- (void)initModelData{
    if (self.finishLookHouseArray.count > 0) {
        [self.finishLookHouseArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (_cells == nil) {
                _cells = [NSMutableArray array];
            }
            
            OrderLookHouseInfo *object = [[OrderLookHouseInfo alloc] initWithDictionary:obj];
            [_cells addObject:object];
            NSLog(@">>>>>>_cells>>>>>>%@",_cells);
            
        }];
        [self.tableView reloadData];
    }
}

//初始化tableview
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width,screen_height-64-45-40) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:@"MyCollectionCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:myCollectionCellIdentifier];
    [self.view addSubview:self.tableView];
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshing)];
}

//下拉刷新
-(void) headerRefreshing
{
    self.currentTableViewStatus = load_data_status_waiting_load;
    [self.finishLookHouseArray removeAllObjects];
    [_cells removeAllObjects];
    [self transformEvent:event_load_data_pull_down];
}
//上拉刷新
-(void) footerRefreshing
{
    [self transformEvent:event_load_data_pull_up];
}


- (void)initFooterView{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height-64-45-40-50, screen_width, 50)];
    self.footerView.backgroundColor = [UIColor blackColor];
    self.footerView.alpha = 0;
//    [self.navigationController.view addSubview:self.footerView];
    [self.view addSubview:self.footerView];
    [self.view bringSubviewToFront:self.footerView];
    
    
    self.leftAllDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftAllDeleteBtn.frame = CGRectMake(10, 0, 60, 50);
    [self.leftAllDeleteBtn setTitle:@"全部删除" forState:UIControlStateNormal];
    [self.leftAllDeleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftAllDeleteBtn.titleLabel setFont:[UIFont systemFontOfSize:default_font_size]];
    self.leftAllDeleteBtn.backgroundColor = [UIColor clearColor];
    [self.leftAllDeleteBtn addTarget:self action:@selector(leftAllDeleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.leftAllDeleteBtn];
    
    
    self.rightDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightDeleteBtn.frame = CGRectMake(screen_width-10-50, 0, 50, 50);
    [self.rightDeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    self.rightDeleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [self.rightDeleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightDeleteBtn.titleLabel setFont:[UIFont systemFontOfSize:default_font_size]];
    self.rightDeleteBtn.backgroundColor = [UIColor clearColor];
    [self.rightDeleteBtn addTarget:self action:@selector(rightDeleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerView addSubview:self.rightDeleteBtn];
}

#pragma mark - tableViewDelegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _cells.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:myCollectionCellIdentifier forIndexPath:indexPath];
    [cell renderMyCollectionCell:_cells[indexPath.section]];
    cell.tag = indexPath.section;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 25)];
    headerView.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (screen_width-20)/2, 25)];
    dateLabel.font = [UIFont systemFontOfSize:small_font_size];
    OrderLookHouseInfo *obj = _cells[section];
    NSString *creatTimeStr = [obj.createTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    dateLabel.text = creatTimeStr;
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:dateLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(screen_width-20)/2, 0, (screen_width-20)/2, 25)];
    statusLabel.font = [UIFont systemFontOfSize:small_font_size];
    NSDictionary *orderStatusDict = obj.orderStatus;
    statusLabel.text = orderStatusDict[@"name"];
    statusLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:statusLabel];
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, 24.5, screen_width, splite_line_height)];
    downLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    [headerView addSubview:downLine];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, splite_line_height)];
    footerView.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return splite_line_height;
}

#pragma mark 滚动监听
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@">>>>>>>>>>>滑动了");
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 25; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

////是否可以编辑  默认的时YES
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleNone;
}

//选择按钮点击响应事件
- (void)selectedFnishBtn:(UIButton *)sender{
    //支持同时选中多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
//        [UIView animateWithDuration:0.5 animations:^{
            self.footerView.alpha = 0.75;
//        }];
        for (MyCollectionCell *cell in self.tableView.visibleCells) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkCell:)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addGestureRecognizer:tapGesture];
        }
    } else {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
//        [UIView animateWithDuration:0.5 animations:^{
            self.footerView.alpha = 0;
//        }];
        for (MyCollectionCell *cell in self.tableView.visibleCells) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.gestureRecognizers = nil;
        }
        for (OrderLookHouseInfo *obj in _cells) {
            obj.isSelected = NO;
        }
        [self performSelector:@selector(EditEndRefresh) withObject:nil afterDelay:0.3f];
    }
    
}

- (void)EditEndRefresh {
    [self.tableView reloadData];
}

- (void)checkCell:(UITapGestureRecognizer *)tapGesture {
    MyCollectionCell *cell = (MyCollectionCell *)tapGesture.view;
    OrderLookHouseInfo *obj = _cells[cell.tag];
    obj.isSelected = !obj.isSelected;
    
    NSLog(@">>>>>>收藏id>>>>>>>%d",obj.orderId);
    if (obj.isSelected == YES) {
        [self.selectedFnishHouseIdArray addObject:@(obj.orderId)];
    }else{
        [self.selectedFnishHouseIdArray removeObject:@(obj.orderId)];
    }
    NSLog(@">>>>>>selectedFnishHouseIdArray>>>>>>>%@",self.selectedFnishHouseIdArray);
    [self.tableView reloadData];
}


- (void)leftAllDeleteBtnClick{
    NSLog(@">>>>>>>>>>>全部删除");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //点击取消按钮后控制台打印语句。
    }];
    //实例化确定按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSMutableArray *allIDArray = [NSMutableArray new];
        for (OrderLookHouseInfo *obj in _cells) {
            [allIDArray addObject:@(obj.orderId)];
        }
        [[HouseStore sharedStore] removeOrderHouseInfo:^(NSError *err) {
            if (err == nil) {
                self.currentPageNo = 1;
                self.currentTableViewStatus = load_data_status_waiting_load;
                [self transformEvent:event_load_data_init_load];
                [self.tableView reloadData];
            }
        } ids:[allIDArray componentsJoinedByString:@","]];
        
    }];
    //实例化确定按钮
    //向弹出框中添加按钮和文本框
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    //将提示框弹出
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)rightDeleteBtnClick{
    NSLog(@">>>>>>>>>>>删除");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //点击取消按钮后控制台打印语句。
    }];
    //实例化确定按钮
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[HouseStore sharedStore] removeOrderHouseInfo:^(NSError *err) {
            if (err == nil) {
                self.currentPageNo = 1;
                self.currentTableViewStatus = load_data_status_waiting_load;
                [self transformEvent:event_load_data_init_load];
                [self.tableView reloadData];
            }

        } ids:[self.selectedFnishHouseIdArray componentsJoinedByString:@","]];    }];
    //实例化确定按钮
    //向弹出框中添加按钮和文本框
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    //将提示框弹出
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark 状态机
-(void) transformEvent:(int)eventType{
    
    if ((self.currentTableViewStatus == load_data_status_waiting_load
         || self.currentTableViewStatus == load_data_status_load_over)
        && eventType == event_load_data_init_load) {
        // 初始化加载
        if(self.finishLookHouseArray != nil && self.finishLookHouseArray.count >0){
            [self.finishLookHouseArray removeAllObjects];
        }
        if (_cells != nil && _cells.count > 0 ) {
            [_cells removeAllObjects];
        }
        self.currentPageNo = 1;
        self.currentTableViewStatus = load_data_status_loading;
        [self loadData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_up){
        // 上拉加载
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = self.currentPageNo + 1;
        [self.finishLookHouseArray removeAllObjects];
        [self loadData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_down){
        // 下拉刷新
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = 1;
        [self.finishLookHouseArray removeAllObjects];
        [_cells removeAllObjects];
        [self.tableView reloadData];
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
