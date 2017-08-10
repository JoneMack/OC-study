//
//  MyCollectionController.m
//  xiangyu
//
//  Created by xubojoy on 16/7/7.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MyCollectionController.h"
#import "MyCollectionCell.h"
#import "CollectionModel.h"
#import "HouseStore.h"
@interface MyCollectionController ()
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
static NSString *myCollectionCellIdentifier = @"MyCollectionCell";
@implementation MyCollectionController
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
    NSLog(@"========我的收藏=====");
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBottomBlackView) name:@"移除底部" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBottomBlackView) name:@"移除子视图底部" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.selectBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedHouseCollectionIdArray = [NSMutableArray new];
    self.selectedHouseCollectionIdDict = [NSMutableDictionary new];
    [self initTableView];
    self.currentPageNo = 1;
    self.currentTableViewStatus = load_data_status_waiting_load;
    [self transformEvent:event_load_data_init_load];
    [self initFooterView];
}

- (void)loadData{
    
    [[HouseStore sharedStore] getFavHouseInfos:^(NSArray *houseInfos, NSError *err) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.currentTableViewStatus = load_data_status_waiting_load;
        if(self.favHouseArray == nil){
            self.favHouseArray = [NSMutableArray new];
        }
        if(houseInfos != nil && houseInfos.count >0){
            [self.favHouseArray addObjectsFromArray:houseInfos];
        }else{
            self.currentTableViewStatus = load_data_status_load_over;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
//        NSLog(@">>>>>>我的收藏>>>>>>%@------%@",houseInfos,self.favHouseArray);
        [self initModelData];
        [self.tableView reloadData];

    } pageNum:[NSString stringWithFormat:@"%d",self.currentPageNo] x:nil y:nil];
}

- (void)initModelData{
    if (self.favHouseArray.count > 0) {
        [self.favHouseArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            if (_cells == nil) {
                _cells = [NSMutableArray array];
//            }
            CollectionModel *object = [[CollectionModel alloc] initWithDictionary:obj];
            NSLog(@">>>>>>object.collectionDate>>>>>>%@",object.collectionDate);
            [_cells addObject:object];
            NSLog(@">>>>>>_cells>>>>>>%@",_cells);
            
        }];
        [self.tableView reloadData];
    }
}

//初始化tableview
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width,screen_height-64-45) style:UITableViewStylePlain];
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
    [self.favHouseArray removeAllObjects];
//    [_cells removeAllObjects];
    [self transformEvent:event_load_data_pull_down];
}
//上拉刷新
-(void) footerRefreshing
{
    [self transformEvent:event_load_data_pull_up];
}


- (void)initFooterView{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height-64-45-50, screen_width, 50)];
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
    [cell setCellData:_cells[indexPath.section]];
    cell.tag = indexPath.section;
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 25)];
    headerView.backgroundColor = [ColorUtils colorWithHexString:common_bg_color];
    CollectionModel *obj = _cells[section];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, (screen_width-20)/2, 25)];
    dateLabel.font = [UIFont systemFontOfSize:small_font_size];
    
    dateLabel.text = obj.collectionDate;
    dateLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:dateLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(screen_width-20)/2, 0, (screen_width-20)/2, 25)];
    statusLabel.font = [UIFont systemFontOfSize:small_font_size];
    
    if ([obj.rentStatus isEqualToString:@"1"]) {
       statusLabel.text = @"已出租";
    }else{
        statusLabel.text = @"未出租";
    }
    
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
- (void)selectedBtn:(UIButton *)sender{
   //支持同时选中多行
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        [self initFooterView];
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
        [self.footerView removeFromSuperview];
//        [UIView animateWithDuration:0.5 animations:^{
            self.footerView.alpha = 0;
//        }];
        for (MyCollectionCell *cell in self.tableView.visibleCells) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.gestureRecognizers = nil;
        }
        for (CollectionModel *obj in _cells) {
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
    CollectionModel *obj = _cells[cell.tag];
    obj.isSelected = !obj.isSelected;
    
    NSLog(@">>>>>>收藏id>>>>>>>%@",obj.collectionId);
    if (obj.isSelected == YES) {
        [self.selectedHouseCollectionIdArray addObject:obj.collectionId];
    }else{
        [self.selectedHouseCollectionIdArray removeObject:obj.collectionId];
    }
    NSLog(@">>>>>>self.selectedHouseCollectionIdArray>>>>>>>%@",self.selectedHouseCollectionIdArray);
    [self.self.selectedHouseCollectionIdDict setObject:[self.selectedHouseCollectionIdArray componentsJoinedByString:@","] forKey:@"collectionId"];
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
        NSMutableDictionary *dict = [NSMutableDictionary new];
        NSMutableArray *allIDArray = [NSMutableArray new];
        for (CollectionModel *obj in _cells) {
            [allIDArray addObject:obj.collectionId];
        }
        [dict setObject:[allIDArray componentsJoinedByString:@","] forKey:@"collectionId"];
        [[HouseStore sharedStore] removeFavHouseInfo:^(NSError *err) {
            if (err == nil) {
                self.currentPageNo = 1;
                self.currentTableViewStatus = load_data_status_waiting_load;
                [self transformEvent:event_load_data_init_load];
                [self.tableView reloadData];
            }
        } collectionIds:dict];
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
    if (self.selectedHouseCollectionIdDict != nil) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //点击取消按钮后控制台打印语句。
        }];
        //实例化确定按钮
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[HouseStore sharedStore] removeFavHouseInfo:^(NSError *err) {
                if (err == nil) {
                    self.currentPageNo = 1;
                    self.currentTableViewStatus = load_data_status_waiting_load;
                    [self transformEvent:event_load_data_init_load];
                    [self.tableView reloadData];
                }
                
            } collectionIds:self.selectedHouseCollectionIdDict];
            
        }];
        //实例化确定按钮
        //向弹出框中添加按钮和文本框
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        //将提示框弹出
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self.view makeToast:@"请先选择后在删除！" duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
    }
}

//- (void)viewWillDisappear:(BOOL)animated{
//    debugMethod();
//    [super viewWillDisappear:animated];
//    [self.footerView removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"移除底部" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"移除子视图底部" object:nil];
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [self.footerView removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"移除底部" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"移除子视图底部" object:nil];
//}

#pragma mark 状态机
-(void) transformEvent:(int)eventType{
    
    if ((self.currentTableViewStatus == load_data_status_waiting_load
         || self.currentTableViewStatus == load_data_status_load_over)
        && eventType == event_load_data_init_load) {
        // 初始化加载
        if(self.favHouseArray != nil && self.favHouseArray.count >0){
            [self.favHouseArray removeAllObjects];
        }
//        if (_cells != nil && _cells.count > 0 ) {
//            [_cells removeAllObjects];
//        }
        self.currentPageNo = 1;
        self.currentTableViewStatus = load_data_status_loading;
        [self loadData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_up){
        // 上拉加载
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = self.currentPageNo + 1;
        [self.favHouseArray removeAllObjects];
        [self loadData];
    }else if (self.currentTableViewStatus == load_data_status_waiting_load
              && eventType == event_load_data_pull_down){
        // 下拉刷新
        self.currentTableViewStatus = load_data_status_loading;
        self.currentPageNo = 1;
        [self.favHouseArray removeAllObjects];
//        [_cells removeAllObjects];
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
