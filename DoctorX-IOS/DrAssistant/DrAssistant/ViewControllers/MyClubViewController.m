//
//  MyClubViewController.m
//  DrAssistant
//
//  Created by hi on 15/9/3.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyClubViewController.h"
#import "ClubDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface MyClubViewController ()<DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation MyClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the v
    [self hideLeftBtn];
    [self showWithStatus:@"请等待.."];
    [MyClubHandler requestMyClubs:^(BaseEntity *object) {
        [self dismissToast];
        if (object.msg) {
            
            MyClubEntity *enitty = (MyClubEntity *)object;
            self.dataArr = enitty.clubList;
            
            [self.tableView reloadData];
        }else{
            [self showString:object.msg];
        }
        
    } fail:^(id object) {
        
        
    }];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor defaultBgColor];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:PLACEHOLDERINSCROLL];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static  NSString  *CellIdentiferId = @"myClubCell";
    MyClubCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"MyClubCell" owner:nil options:nil];
        cell = [nibs lastObject];
        cell.backgroundColor = [UIColor defaultBgColor];
    };
    
    MyClubEntity *info = [self.dataArr safeObjectAtIndex: indexPath.row];
    
    cell.name.text = info.clubName;
    cell.descLabel.text = [NSString stringWithFormat:@"已有专家:%zi人", info.NUMS];
    //cell.sortLabel.text = [NSString stringWithFormat:@"排名:%zi", info.SORT];
    //cell.joinBtn.enabled = !info.isJoined;
    cell.cludId=info.ID;
    //UIImage *place = [UIImage imageNamed:@"club_Placeholder"];
   // [cell.thumnail sd_setImageWithURL:[NSURL URLWithString: info.CLUB_THUMB] placeholderImage: place];
    //date 2015-10-04
    // 图片显示
    [cell.thumnail sd_setImageWithURL:[NSURL URLWithString:info.CLUB_THUMB]];
    [cell.thumnail setShowActivityIndicatorView: YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyClubEntity *info = [self.dataArr safeObjectAtIndex: indexPath.row];
    ClubDetailViewController *cVC = [ClubDetailViewController simpleInstance];
    cVC.ClubInfo = info;
    [self.tabBarController.navigationController pushViewController: cVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

#pragma  mark - getter

- (NSArray *)dataArr
{
    if (_dataArr == nil)
    {
        _dataArr = [[NSArray alloc] init];
    }
    return _dataArr;
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
