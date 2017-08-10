//
//  SearchResultForPatViewController.m
//  DrAssistant
//
//  Created by Seiko on 15/9/28.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "SearchResultForPatViewController.h"
#import "MyPatientsCell.h"
#import "SearchHandler.h"
#import "PatientDetailController.h"
#import "ZhuanJiaDetailController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface SearchResultForPatViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation SearchResultForPatViewController
@synthesize dataFriendArr;
@synthesize dataArr;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"搜索结果";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self.view addSubview:self.tableView];
    [self searchWithName:self.searchResultNum];
    }

- (void)searchWithName:(NSString *)name
{
    if ([Utils isBlankString: name]) {
        [self showString:@"请输入账号"];
    }
    //NSMutableArray *array=[[NSMutableArray alloc]init];
    NSSet *set=[[NSSet alloc]init];
    for (UserEntity *userEntity in dataFriendArr) {
        if ([userEntity.LOGIN_NAME rangeOfString:name].length) {
                set=[set setByAddingObject:userEntity];
          }
        if ([userEntity.REAL_NAME rangeOfString:name].length) {
                set=[set setByAddingObject:userEntity];
        }
    }
    self.dataArr=[set allObjects];
   [self.tableView reloadData];
//    [SearchHandler searchUserWithAccount:name type:type success:^(BaseEntity *object) {
//        
//        if (object.success) {
//            
//            UserEntity *entity = (UserEntity *)object;
//            self.dataArr = entity.data;
//            [self.tableView reloadData];
//            
//        }else{
//            
//        }
//        
//    } fail:^(id object) {
//        
//    }];
}


- (NSMutableArray *)dataSource
{
    if (_dataSource == nil){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView's delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    MyPatientsCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyPatientsCell" owner:nil options:nil] firstObject];
    }
    UserEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
    
    NSString *name = entity.REAL_NAME;
    
    if ([Utils isBlankString: name]) {
        
        name = [NSString stringWithFormat:@"(%@)", entity.PHONE];
    }else{
        
        if (![Utils isBlankString: entity.major]) {
            name=  [name stringByAppendingFormat:@"(%@)", entity.major];
        }else if (![Utils isBlankString: entity.PHONE]){
            name=  [name stringByAppendingFormat:@"(%@)", entity.PHONE];
        }
    }
    
    
    NSString *desc = entity.docDesc;
    if ([Utils isBlankString: entity.docDesc]) {
        desc = entity.address;
    }
    
    cell.nameLabel.text = name;
    cell.detailLabel.text = desc;
    [cell.avtarImageView sd_setImageWithURL:[NSURL URLWithString: entity.thumb] placeholderImage:[UIImage placeholderAvater]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.markComeFrom isEqualToString:@"SearChPat"]) {
        PatientDetailController *patient = [[PatientDetailController alloc]init];
        patient.userInfoEntity = [self.dataArr safeObjectAtIndex: indexPath.row];
        patient.title=@"患者详情";
        [self.navigationController pushViewController:patient animated:YES];
    }
    else
    {
        UserEntity *entity = [self.dataArr safeObjectAtIndex: indexPath.row];
        ZhuanJiaDetailController *zhuanjia = [ZhuanJiaDetailController simpleInstance];
        zhuanjia.zhuanJiaInfo = entity;
        zhuanjia.title=@"医生详情";
        [self.navigationController pushViewController: zhuanjia animated:YES];
    }
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:PLACEHOLDERINSCROLL];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}


@end
