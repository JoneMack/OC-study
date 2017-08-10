//
//  MyPatientController.m
//  DrAssistant
//
//  Created by hi on 15/9/2.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyPatientController.h"
#import "MyPatientsCell.h"
#import "ChatViewController.h"
#import "MyPatientHeader.h"
#import "MyPatientHandler.h"
#import "MultistageTableView.h"
#import "FriendSectionHeader.h"
#import "GroupInfoEntity.h"
#import "MyPatientsCell.h"
#import "YuYueController.h"
#import "SearchViewController.h"
#import "SearchResultForPatViewController.h" // 搜索结果列表
#import "BulkViewController.h"
#import "ClubViewController.h"
#import "HeadView.h"
#import "SelectGroupController.h"
#import "RegisterEntityResponse.h"
#import "PatientDetailController.h"
#import "SRRefreshView.h"
@interface MyPatientController ()<IChatManagerDelegate, MyPatientHeaderDelegate, UISearchBarDelegate,HeadViewDelegate,SRRefreshDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) NSMutableArray *sendGroup_dataArray;

//@property (strong, nonatomic)  MultistageTableView *mtableView;

@end

@implementation MyPatientController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoadPatientsGroupListData) name:@"移动分组" object:nil];
    
}

- (void)reLoadPatientsGroupListData{
    [self.dataSource removeAllObjects];
    [self startGetGroupList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideLeftBtn];
    [self initTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [UIView new];
    [self startGetGroupList];
    [self.tableView addSubview:self.slimeView];
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 40;
    [self.view addSubview:self.tableView];
    MyPatientHeader *paHeader = [MyPatientHeader patientHeader];
    paHeader.delegate = self;
    paHeader.searchBar.delegate = self;
    paHeader.searchBar.tintColor = [UIColor blueColor];
    self.tableView.tableHeaderView = paHeader;
}


- (void)startGetGroupList
{
//    [MyPatientHandler getAllGroupWithType:0 success:^(BaseEntity *object) {
//        
//        if (object.success) {
//            
//            GroupListEntity *entity = (GroupListEntity *)object;
//            self.dataSource = [entity.data mutableCopy];
//            [self.mtableView reloadData];
//            
//            self.sendGroup_dataArray = self.dataSource;
//            // [self showString:@"加载病人成功"];
//        }else{
//            
//        }
//        
//    } fail:^(id object) {
//        
//        
//    }];
    [self.dataSource removeAllObjects];
    [self showWithStatus:@"请等待.."];
    [MyPatientHandler getAllGroupWithType:0 success:^(BaseEntity *object) {
        
        if (object.success) {
            [self dismissToast];
            
            GroupListEntity *entity = (GroupListEntity *)object;
//            NSLog(@">>>>>>>>>获取分组>>>>>>>>>>>>%@",entity.data);
//            NSLog(@">>>>>>>>>获取分组个数——1>>>>>>>>>>>>%ld",self.dataSource.count);
            [self.dataSource removeAllObjects];
            for (GroupInfoEntity *friendGroup in entity.data) {
                [self.dataSource addObject:friendGroup];
            }
//            NSLog(@">>>>>>>>>获取分组个数>——2>>>>>>>>>>>%ld",self.dataSource.count);
            [self.tableView reloadData];
//            self.sendGroup_dataArray = self.dataSource;
            
        }else{
            
        }
    } fail:^(id object) {
        
    }];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)myPatientHeaderBtnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case AdPatientTag:
        {
            NSLog(@"AdPatientTag");
            SearchViewController *sVC = [SearchViewController simpleInstance];
            sVC.searchType = SearchPatient;
            sVC.isPatOrDoc = @"AddPat";
            sVC.reciveGroupArray = self.dataSource;
            sVC.title=@"添加患者";
            [self.tabBarController.navigationController pushViewController:sVC animated:YES];
            
        }
            break;
        case qunFaXiaoXiTag:
        {
            BulkViewController *sVC = [BulkViewController simpleInstance];
            sVC.title=@"群发消息";
            sVC.qunFaMsgType = push_from_my_patient_vc;
            [self.tabBarController.navigationController pushViewController:sVC animated:YES];
        }
            break;
        case myQunLiaoTag:
        {
            NSLog(@"myQunLiaoTag");
            _groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
            _groupController.groupChatPushType = push_from_patient_group_chat;
            _groupController.qunChatGroupListType = patients_group_list;
            _groupController.friend_IDType = 0;
            [self.tabBarController.navigationController pushViewController:_groupController animated:YES];

        }
            break;
        case yuYueTag:
        {
            YuYueController *sVC = [YuYueController simpleInstance];
            [self.tabBarController.navigationController pushViewController:sVC animated:YES];

        }
            break;

        case clubTag:
        {
            //NSLog(@"clubTag");
            [self checkWhetherJoinedClub];
        }
            break;
            
        default:
            break;
    }
}

-(void)checkWhetherJoinedClub{

    [MyPatientHandler checkWhetherJoinedClubWithType:14 success:^(BaseEntity *object) {
        if (object.success) {
            GroupListEntity *entity = (GroupListEntity *)object;
            GroupInfoEntity *infoEntity = entity.data[0];
            NSLog(@">>>>>>>>>>>>>>>>>>>%@",infoEntity.friends);
            if (infoEntity.friends.count > 0) {
                ClubViewController *mcvc = [[ClubViewController alloc] init];
                mcvc.friendsArray = infoEntity.friends;
                [self.tabBarController.navigationController pushViewController:mcvc animated:YES];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还没加入俱乐部" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [alert show];
            }
        }
    } fail:^(id object) {
        
    }];

}

#pragma mark - Table view data source
#pragma mark 加载数据

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GroupInfoEntity *friendGroup = self.dataSource[section];
    NSInteger count = friendGroup.isOpened ? friendGroup.friends.count : 0;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identity=@"cell-identity";
    CommonCell* cell=(CommonCell *)[tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell=[[CommonCell alloc]initWithStyle:UITableViewCellStyleDefault
                              reuseIdentifier:identity
                                     delegate:self
                                  inTableView:tableView withRightButtonTitles:@[@"删除",@"移动分组"]];
    }
    
    GroupInfoEntity *friendGroup = self.dataSource[indexPath.section];
    UserEntity *friend = friendGroup.friends[indexPath.row];
    
    //    cell.imageView.image = [UIImage imageNamed:friend.thumb];
    //    cell.textLabel.text = friend.name;
    //    cell.detailTextLabel.text = friend.intro;
    
    if ([friend.REAL_NAME length])
    {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", friend.REAL_NAME];
    }
    else
    {
        cell.nameLabel.text =@"－－";
    }
    if (friend.address.length == 0) {
        cell.contentLabel.text = @"暂无信息";
    }
    else
    {
        cell.contentLabel.text = friend.address;
    }
    
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString: friend.thumb] placeholderImage:[UIImage placeholderAvater]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadView *headView = [HeadView headViewWithTableView:tableView];
    headView.contentView.backgroundColor = [UIColor whiteColor];
    headView.delegate = self;
    headView.friendGroup = self.dataSource[section];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressDeleteSectionHeaderView:)];
    longPress.minimumPressDuration = 2.0;
    [headView addGestureRecognizer:longPress];
    headView.tag=section;
    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex: indexPath.section];
//    UserEntity *friend = [entity.friends safeObjectAtIndex: indexPath.row];
//    ZhuanJiaDetailController *zhuanjia = [ZhuanJiaDetailController simpleInstance];
//    zhuanjia.zhuanJiaInfo = friend;
//    [self.tabBarController.navigationController pushViewController: zhuanjia animated:YES];
    
    PatientDetailController *patDe = [PatientDetailController simpleInstance];
    GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex: indexPath.section];
    UserEntity *friend = [entity.friends safeObjectAtIndex: indexPath.row];
    patDe.userInfoEntity = friend;
    [self.tabBarController.navigationController pushViewController:patDe animated:YES];
}

- (void)clickHeadView
{
    [self.tableView reloadData];
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
}
#pragma mark - slimeRefresh delegate

//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self.dataSource removeAllObjects];
//    NSLog(@"%ld",self.dataSource.count);
    [self startGetGroupList];
    [_slimeView endRefresh];
//    NSLog(@"%ld",self.dataSource.count);
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
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
//
////处理侧滑动画及好友申请
////=================================================================================
//
#pragma mark - WKTableViewCellDelegate
-(void)buttonTouchedOnCell:(WKTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath atButtonIndex:(NSInteger)buttonIndex{
//    NSLog(@"row:%ld,buttonIndex:%ld",(long)indexPath.section,(long)buttonIndex);
    NSIndexPath *indexPath1 = [self.tableView indexPathForCell:cell];
    GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex:indexPath1.section];
    UserEntity *friend = [entity.friends safeObjectAtIndex: indexPath1.row];
//    NSLog(@">>>>>>>>>>>>点击后的数据>>>>>>>>>>>>%@-------------%ld--------%ld",entity.friends,indexPath1.section,indexPath1.row);
    if (buttonIndex==0){
//        NSLog(@">>>>>>>>>>>>点击了删除>>>>>>>>>>>>%@-------------%ld--------%ld",friend,indexPath1.section,indexPath1.row);
        [entity.friends safeRemoveObjectAtIndex:indexPath1.row];
        [MyPatientHandler deleteFriendByAccount:[GlobalConst shareInstance].loginInfo.login_name friendLoginName:friend.LOGIN_NAME success:^(BaseEntity *object) {
            if (object.success) {
                EMError *error = nil;
                // 删除好友
                BOOL isSuccess = [[EaseMob sharedInstance].chatManager removeBuddy:friend.LOGIN_NAME removeFromRemote:YES error:&error];
                if (isSuccess && !error) {
                   [self showSuccessAlert:@"删除成功"];
                }
            }
        } fail:^(id object) {
            
        }];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                               withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
        
    }else if (buttonIndex == 1){
        SelectGroupController *sgvc = [[SelectGroupController alloc] init];
        sgvc.groupName = entity.groupname;
        sgvc.friendId = friend.ID;
        sgvc.friendType = patient_friend_type;
        [self.tabBarController.navigationController pushViewController:sgvc animated:YES];
    }
}
//=================================================================================

#pragma mark - Delete Group
-(void)longPressDeleteSectionHeaderView:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
        
    {
        NSInteger section = gestureRecognizer.view.tag;
        
        GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex:section];

        if ([entity.u_id intValue] > 0)
        {
            NSLog(@"你删除了UID>0的分组");
            
            
            [EMAlertView showAlertWithTitle:@"您将要删除该分组,是否继续" message:@"删除分组,分组中的好友将转移到全部患者" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                if (buttonIndex == 1)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic safeSetObject:entity.ID forKey:@"groupId"];
                    [dic safeSetObject:@"0" forKey:@"type"];
                    [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
                    
                    [[GRNetworkAgent sharedInstance] requestUrl:DeleteGroup param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject)
                    {
                        if ([[[reponeObject objectForKey:@"success"] stringValue] isEqualToString:@"1"]) {
                            [self.dataSource safeRemoveObjectAtIndex:section];
                            [self.tableView reloadData];
                        }
                        
                    } failure:^(GRBaseRequest *request, NSError *error) {
                        
                    } withTag:0];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            
        }
        else
        {
            [self showErrorToast:@"禁止删除系统分组"];
        }
        
    }
    
}

#pragma mark - Add New Group
- (void)creatNewGroupForGroupList
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"新建分组" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加",nil];
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入新的组名"];
    
    [alert show];
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *nameField = [alertView textFieldAtIndex:0];
//    NSLog(@"---%@-",nameField.text);
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        NSString *UserName = [GlobalConst shareInstance].loginInfo.login_name;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:nameField.text forKey:@"groupName"];
        [dic safeSetObject:@"0" forKey:@"groupType"];
        [dic safeSetObject:UserName forKey:@"account"];
        [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
        
        [[GRNetworkAgent sharedInstance] requestUrl:AddGroup param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
//            NSLog(@"%@",reponeObject);
            
            if ([[[reponeObject objectForKey:@"success"] stringValue] isEqualToString:@"1"]) {
                [self.dataSource removeAllObjects];
                [self startGetGroupList];
            }
            
        } failure:^(GRBaseRequest *request, NSError *error) {
            
        } withTag:0];
        
    }
}

#pragma mark - setter getter
- (NSMutableArray *)sendGroup_dataArray
{
    if (_sendGroup_dataArray == nil){
        _sendGroup_dataArray = [NSMutableArray array];
    }
    return _sendGroup_dataArray;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)contactsSource
{
    if (_contactsSource == nil){
        _contactsSource = [NSMutableArray array];
    }
    return _contactsSource;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    SearchResultForPatViewController *searchResult = [SearchResultForPatViewController simpleInstance];
    searchResult.markComeFrom = @"SearChPat";
    searchResult.searchResultNum = searchBar.text;// 此处需验证是否手机号
    NSMutableArray *friendArray=[[NSMutableArray alloc]init];
    for (int i=0; i<self.dataSource.count; i++) {
         GroupInfoEntity *friendGroup = self.dataSource[i];
        for (int j=0;j<[friendGroup friends].count; j++) {
            UserEntity *userEntity=[friendGroup friends][j];
            [friendArray addObject:userEntity];
        }
    }
    searchResult.dataFriendArr=friendArray;
    [searchBar resignFirstResponder];
    [self.tabBarController.navigationController pushViewController:searchResult animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>点击View让键盘下");
    
    [self.tableView endEditing:YES];
}

@end
