//
//  MyTongHangController.m
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "MyTongHangController.h"
#import "GoodDoctorViewController.h"
#import "TongHangHeader.h"
#import "MultistageTableView.h"
#import "FriendSectionHeader.h"
#import "MyPatientsCell.h"
#import "MyPatientHandler.h"
#import "GroupInfoEntity.h"
#import "SearchResultForPatViewController.h"
#import "SearchViewController.h"
#import "ZhuanJiaDetailController.h"
#import "ZhuanZhenJieZhenViewController.h"
#import "ConsultationViewController.h"
#import "BulkViewController.h"
#import "SelectGroupController.h"
#import "HeadView.h"
#import "SRRefreshView.h"
@interface MyTongHangController ()<MyTongHangHeaderDelegate,UISearchBarDelegate,UIActionSheetDelegate,HeadViewDelegate,SRRefreshDelegate>
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *contactsSource;
@property (strong, nonatomic) SRRefreshView *slimeView;

@end

@implementation MyTongHangController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoadGroupListData) name:@"移动分组" object:nil];

}

- (void)reLoadGroupListData{
    [self.dataSource removeAllObjects];
    [self getGroupList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideLeftBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initTableView];

    self.tableView.tableFooterView = [UIView new];
    [self.tableView addSubview:self.slimeView];
    [self getGroupList];
}

-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-49) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 40;
    [self.view addSubview:self.tableView];
    TongHangHeader *header = [TongHangHeader tongHangHeader];
    header.delegate = self;
    header.searchNar.delegate = self;
    self.tableView.tableHeaderView = header;

}

- (void)getGroupList
{
        [self showWithStatus:@"请等待.."];
        [MyPatientHandler getAllGroupWithType:1 success:^(BaseEntity *object) {
            
            if (object.success) {
                [self dismissToast];
                
                GroupListEntity *entity = (GroupListEntity *)object;

                [self.dataSource removeAllObjects];
                for (GroupInfoEntity *friendGroup in entity.data) {
//                    GroupInfoEntity *friendGroup = [GroupInfoEntity friendGroupWithDict:dict];
                    [self.dataSource addObject:friendGroup];
                }
                
                [self.tableView reloadData];
                
            }else{
                
            }
        } fail:^(id object) {
            
        }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)MyTongHangHeaderAction:(UIButton *)btn
{
    switch (btn.tag) {
        case addTonghangTag:
        {
            NSLog(@"添加同行");
            SearchViewController *sVC = [SearchViewController simpleInstance];
            sVC.isPatOrDoc = @"ICOMEFROMEMyTongHangController";
            sVC.searchType = searchTongHang;
            sVC.reciveGroupArray = self.dataSource;
            sVC.title=@"添加同行";
            [self.tabBarController.navigationController pushViewController:sVC animated:YES];
            
            break;
        }
            break;
        case qunFaXIaoXiTag:
        {
            NSLog(@"群发消息");
            BulkViewController *sVC = [BulkViewController simpleInstance];
            sVC.title=@"群发消息";
            sVC.qunFaMsgType = push_from_my_tonghang_vc;
            [self.tabBarController.navigationController pushViewController:sVC animated:YES];
        }
            break;
        case myQunLiaoTag:
        {
            NSLog(@"我的群聊");
            _groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
            _groupController.groupChatPushType = push_from_tonghang_group_chat;
            _groupController.qunChatGroupListType = tongHang_group_list;
            _groupController.friend_IDType = 1;
            [self.tabBarController.navigationController pushViewController:_groupController animated:YES];

        }
            break;
        case addHuiZhenTag:
        {
            NSLog(@"添加会诊");
            _groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
            _groupController.groupChatPushType = push_from_tonghang_huizhen_chat;
            _groupController.qunChatGroupListType = huizhen_group_list;
            _groupController.friend_IDType = 1;
            [self.tabBarController.navigationController pushViewController:_groupController animated:YES];
//            ConsultationViewController *consult = [ConsultationViewController simpleInstance];
//            consult.friend_IDType = 1;
//            [self.tabBarController.navigationController pushViewController:consult animated:YES];
        }
            break;
        case jieZhenTag:
        {
            NSLog(@"接诊/转诊");
            ZhuanZhenJieZhenViewController *zhuanJie = [ZhuanZhenJieZhenViewController simpleInstance];
            [self.tabBarController.navigationController pushViewController:zhuanJie animated:YES];
        }
            break;
            case goodDocTag:
        {
            NSLog(@"好大夫");
            GoodDoctorViewController *goodDoc = [GoodDoctorViewController simpleInstance];
            goodDoc.title = @"好大夫教育";
            [self.tabBarController.navigationController pushViewController:goodDoc animated:YES];
        }
            break;
        default:
            break;
    }
}



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
    
    if ([friend.REAL_NAME length])
    {
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", friend.REAL_NAME];
    }
    else
    {
        cell.nameLabel.text = @"－－";
    }
    if (friend.POST.length == 0) {
        friend.POST = @"";
    }
    if (friend.major.length == 0) {
        friend.major = @"暂无信息";
    }
    cell.contentLabel.text = [NSString stringWithFormat:@"%@(%@)", friend.POST,friend.major];
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString: friend.thumb] placeholderImage:[UIImage placeholderAvater]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeadView *headView = [HeadView headViewWithTableView:tableView];
    headView.contentView.backgroundColor = [UIColor whiteColor];
    headView.delegate = self;
    headView.friendGroup = self.dataSource[section];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressSectionHeaderViewDel:)];
    longPress.minimumPressDuration = 2.0;
    headView.tag=section;
    [headView addGestureRecognizer:longPress];

    
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex: indexPath.section];
    UserEntity *friend = [entity.friends safeObjectAtIndex: indexPath.row];
    ZhuanJiaDetailController *zhuanjia = [ZhuanJiaDetailController simpleInstance];
    zhuanjia.zhuanJiaInfo = friend;
    zhuanjia.zhuanJiaxiangQingType = @"isTongHang";
    [self.tabBarController.navigationController pushViewController: zhuanjia animated:YES];
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
//    NSLog(@"--->%ld",self.dataSource.count);
    [self.dataSource removeAllObjects];
//    NSLog(@"--->%ld",self.dataSource.count);
    [self getGroupList];
    [_slimeView endRefresh];
//    NSLog(@"---->%ld",self.dataSource.count);
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
    searchResult.markComeFrom = @"SearchDoc";
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
//
////处理侧滑动画及好友申请
////=================================================================================
//
#pragma mark - WKTableViewCellDelegate
-(void)buttonTouchedOnCell:(WKTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath atButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"row:%ld,buttonIndex:%ld",(long)indexPath.section,(long)buttonIndex);
    NSIndexPath *indexPath1 = [self.tableView indexPathForCell:cell];
    GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex:indexPath1.section];
    UserEntity *friend = [entity.friends safeObjectAtIndex: indexPath1.row];
    if (buttonIndex==0){
        NSLog(@">>>>>>>>>>>>点击了删除>>>>>>>>>>>>%@-------------%ld--------%ld",entity.friends,indexPath1.section,indexPath1.row);
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
        sgvc.friendType = tonghang_friend_type;
        [self.tabBarController.navigationController pushViewController:sgvc animated:YES];
    }
}
//=================================================================================



#pragma mark - Delete Group
-(void)longPressSectionHeaderViewDel:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
        
    {
        NSInteger section = gestureRecognizer.view.tag;
       //NSLog(@"Section-%ld",section);
//        
//        NSLog(@"%@",[self.dataSource objectAtIndex:section]);
        
        GroupInfoEntity *entity = [self.dataSource safeObjectAtIndex:section];
//        NSLog(@"%@",entity.ID);
//        NSLog(@"%@",entity.friends);
        
        if ([entity.u_id intValue] > 0)
        {
            NSLog(@"你删除了UID>0的分组");
            
            
            [EMAlertView showAlertWithTitle:@"您将要删除该分组,是否继续" message:@"删除分组,分组中的好友将转移到全部同行" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                if (buttonIndex == 1)
                {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic safeSetObject:entity.ID forKey:@"groupId"];
                    [dic safeSetObject:@"1" forKey:@"type"];
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
- (void)creatNewGroup
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"新建分组" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加",nil];
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入新的组名"];
    
    [alert show];
    
    
}
/*
 - (void)inPutGroupNameWithNewGroup
{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新建分组"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"请输入新的组名";
    }];

        [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                
                                                    
                                                }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                NSLog(@"取消");
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
 
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *nameField = [alertView textFieldAtIndex:0];
//    NSLog(@"---%@-",nameField.text);
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        
        NSString *UserName = [GlobalConst shareInstance].loginInfo.login_name;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:nameField.text forKey:@"groupName"];
        [dic safeSetObject:@"1" forKey:@"groupType"];
        [dic safeSetObject:UserName forKey:@"account"];
        [dic addEntriesFromDictionary: [BaseEntity sign:nil]];
        
        [[GRNetworkAgent sharedInstance] requestUrl:AddGroup param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
//            NSLog(@"%@",reponeObject);
            
            if ([[[reponeObject objectForKey:@"success"] stringValue] isEqualToString:@"1"]) {
                [self.dataSource removeAllObjects];
                [self getGroupList];
            }
            
        } failure:^(GRBaseRequest *request, NSError *error) {
            
        } withTag:0];

    }
}
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
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
