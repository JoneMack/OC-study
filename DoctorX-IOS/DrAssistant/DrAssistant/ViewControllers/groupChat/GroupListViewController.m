/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "GroupListViewController.h"

#import "EMSearchBar.h"
#import "SRRefreshView.h"
#import "BaseTableViewCell.h"
#import "EMSearchDisplayController.h"
#import "ChatViewController.h"
#import "UIViewController+HUD.h"
#import "GroupsAddViewController.h"
#import "CreateGroupViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "AddConsultationViewControllerViewController.h"
@interface GroupListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, IChatManagerDelegate, SRRefreshDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) SRRefreshView *slimeView;
//@property (strong, nonatomic) EMSearchBar *searchBar;
//@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation GroupListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
//    self.title = NSLocalizedString(@"title.group", @"Group");
    if (self.groupChatPushType == push_from_patient_group_chat) {
        self.title = @"患者群组";
    }else if (self.groupChatPushType == push_from_tonghang_group_chat){
        self.title = @"同行群组";
    }else if(self.groupChatPushType == push_from_tonghang_huizhen_chat || self.groupChatPushType == push_from_tonghang_huizhen_chat){
        self.title = @"会诊群组";
    }
    
#warning 把self注册为SDK的delegate
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
//    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView addSubview:self.slimeView];
//    [self searchController];
    
//    UIButton *publicButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
//    [publicButton setImage:[UIImage imageNamed:@"nav_createGroup"] forState:UIControlStateNormal];
//    [publicButton addTarget:self action:@selector(showPublicGroupList) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *publicItem = [[UIBarButtonItem alloc] initWithCustomView:publicButton];
//    
//    UIButton *createButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
//    [createButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
//    [createButton addTarget:self action:@selector(createGroup) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *createGroupItem = [[UIBarButtonItem alloc] initWithCustomView:createButton];
//
//    [self.navigationItem setRightBarButtonItems:@[createGroupItem, publicItem]];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    UIButton *saveBtn=[UIButton buttonWithType:UIButtonTypeContactAdd];
    [saveBtn addTarget:self action:@selector(commitDataAction) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *saveBarBtn = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = saveBarBtn;
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    [self reloadDataSource];
}
-(void)commitDataAction{
//    GroupsAddViewController *sVC = [GroupsAddViewController simpleInstance];
//    [self.navigationController pushViewController:sVC animated:YES];
    
    if(self.groupChatPushType == push_from_tonghang_huizhen_chat || self.groupChatPushType == push_from_tonghang_huizhen_chat){
        AddConsultationViewControllerViewController *addHuiZhen = [AddConsultationViewControllerViewController simpleInstance];
        [self.navigationController pushViewController:addHuiZhen animated:YES];
    }
    else
    {
        CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
        createChatroom.navTitle = self.title;
        NSLog(@"ididididid--%ld",self.friend_IDType);
        createChatroom.friend_IDType = self.friend_IDType;
        [self.navigationController pushViewController:createChatroom animated:YES];
    }
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - tableView PlaceHold
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:PLACEHOLDERINSCROLL];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
        NSString *imageName = @"group_header";
        cell.imageView.image = [UIImage imageNamed:imageName];
    
        if (group.groupSubject && group.groupSubject.length > 0) {
            NSString *resString = group.groupSubject;
            NSRange range = [group.groupSubject rangeOfString:@"ZZDBDZKJYXGS"];
            if (range.length >0) {
                
                NSString * result = [group.groupSubject substringFromIndex:range.location];
                NSLog(@"%@",result);
                if ([result isEqualToString:patients_group_list]) {
                        resString = [[group.groupSubject componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                }
                if ([result isEqualToString:tongHang_group_list]) {
                    resString = [[group.groupSubject componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                }
                if ([result isEqualToString:huizhen_group_list]) {
                    resString = [[group.groupSubject componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                }
            }
            cell.textLabel.text = resString;
        }
        else {
            cell.textLabel.text = group.groupId;
        }
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EMGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:group.groupId isGroup:YES];
    NSString *resString = group.groupSubject;
    NSRange range = [group.groupSubject rangeOfString:@"ZZDBDZKJYXGS"];
    if (range.length >0) {
        
        NSString * result = [group.groupSubject substringFromIndex:range.location];
        NSLog(@"%@",result);
        if ([result isEqualToString:patients_group_list]) {
            resString = [[group.groupSubject componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
        }
        if ([result isEqualToString:tongHang_group_list]) {
            resString = [[group.groupSubject componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
        }
        if ([result isEqualToString:huizhen_group_list]) {
            resString = [[group.groupSubject componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
        }
    }
    chatController.friend_type = self.friend_IDType;
    chatController.title = resString;
    chatController.qunGroup_type = self.qunChatGroupListType;
    [self.navigationController pushViewController:chatController animated:YES];

}

#pragma mark - SRRefreshDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsListWithCompletion:^(NSArray *groups, EMError *error) {
        if (!error) {
            [self.dataSource removeAllObjects];
            for (EMGroup *eMGroup in groups) {
                if ([eMGroup.groupSubject hasSuffix:self.qunChatGroupListType]) {
                    [self.dataSource addObject:eMGroup];
                }
            }
            [self.tableView reloadData];
        }
    } onQueue:nil];
    
    [_slimeView endRefresh];
}

#pragma mark - IChatManagerDelegate

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{
    if (!error) {
        [self reloadDataSource];
    }
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self reloadDataSource];
}

#pragma mark - data

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    
    NSArray *rooms = [[EaseMob sharedInstance].chatManager groupList];
//    NSLog(@">>>>>>>>>>>>>roomsroomsroomsroomsroomsrooms>>>>>>>%@>>>>>>>%@",rooms,self.qunChatGroupListType);
    for (EMGroup *eMGroup in rooms) {
//        NSLog(@">>>>>>>>>>>>>roomsroomsroomsroomsroomsrooms>>>>>>>>>>>>>>%@",eMGroup.groupSubject);
        if ([eMGroup.groupSubject hasSuffix:self.qunChatGroupListType]) {
            [self.dataSource addObject:eMGroup];
        }
    }
    [self.tableView reloadData];
}

@end
