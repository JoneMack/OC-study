//
//  MessageListController.m
//  DrAssistant
//
//  Created by hi on 15/9/2.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListCell.h"
#import "ChatViewController.h"
#import "HMBannerView.h"
#import "GRNetworkAgent.h"
#import "AdsEntity.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "ValidateCodeHandler.h"
#import "MessageHandler.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MyPatientHandler.h"
#import "GroupInfoEntity.h"
#import "sqlite3.h"
@interface ChatListViewController ()<UIAlertViewDelegate,ChatViewControllerDelegate, IChatManagerDelegate,ChatViewControllerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HMBannerView *headerView;

@property (strong, nonatomic) NSArray *ads;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSString *msgId;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideLeftBtn];
    [self getAds];
    [self getAllPatientsFriendsData];
    self.userEntity = [[UserEntity alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO];
    [self removeEmptyConversationsFromDB];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshDataSource];
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}


- (void)getAllPatientsFriendsData
{
    [MyPatientHandler getAllGroupWithType:0 success:^(BaseEntity *object) {
        if (object.success) {
            [self dismissToast];
            self.friendEntityArray = [NSMutableArray new];
            self.resultDataArray = [NSMutableArray new];
            GroupListEntity *entity = (GroupListEntity *)object;
            NSLog(@">>>>>>>>>获取分组>>>>>>>>>>>>%@",entity.data);
            
            for (GroupInfoEntity *friendGroup in entity.data) {
                [self.friendEntityArray addObjectsFromArray:friendGroup.friends];
            }
            //            for (UserEntity *userEntity in self.friendEntityArray) {
            //                if (![userEntity.REAL_NAME isEqualToString:[GlobalConst shareInstance].loginInfo.real_name]) {
            //
            //                }
            //            }
            
            
        }else{
            
        }
    } fail:^(id object) {
        
    }];
    
    
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
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 80;
}

#pragma mark - IChatMangerDelegate



-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - 环信
- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.conversationType == eConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.chatter];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
                                                             deleteMessages:YES
                                                                append2Chat:NO];
    }
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
}


#pragma mark - public

-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    [_tableView reloadData];
    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        //        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        //        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        //        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.beginReceiveOffine", @"Begin to receive offline messages"));
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages{
    NSLog(NSLocalizedString(@"message.endReceiveOffine", @"End to receive offline messages"));
}


#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          NSLog(@"message1   ==  %@",message1);
                          EMMessage *message2 = [obj2 latestMessage];
                          NSLog(@"message2   ==  %@",message2);
                          
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                          
                      }];
    
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (EMConversation *conversation in sorte) {
        NSLog(@"%@=========%@",conversation.chatter,[GlobalConst shareInstance].loginInfo.login_name);
        //        if([@"PUSH" isEqualToString:conversation.latestMessage.ext[@"type"]]){
        //                      //判断是否是服务器推送信息 然后标记为已读
        //
        //                [conversation markMessageWithId:conversation.latestMessage.messageId asRead:YES];
        //        }
        EMMessage *message=[conversation latestMessage];
        //for ( EMMessage *message in messageArr) {
            NSLog(@"messageall%@",message);
            if([@"PUSH" isEqualToString:message.ext[@"type"]]){
                //判断是否是服务器推送信息 然后标记为已读
                [conversation markMessageWithId:message.messageId asRead:YES];
                
            }
            if([@"sys_notice" isEqualToString:message.ext[@"msg_type"]]){
                //判断是否是服务器推送信息 然后标记为已读
                [conversation markMessageWithId:message.messageId asRead:YES];
                [conversation removeMessageWithId:message.messageId];
                id<IEMMessageBody> msgBody = [message.messageBodies firstObject];
                NSString *txt = ((EMTextMessageBody *)msgBody).text;
                if([txt isEqualToString:@"checkTreatment"]){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"转诊信息" message:message.ext[@"msg_txt"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    _msgId=message.ext[@"msg_id"];
                    alertView.tag = 900;
                    [alertView show];
                }
            }
            if ([@"app" isEqualToString:message.ext[@"msg_type"]]) {
                NSLog(@"APPAPPAPP");
                [conversation removeMessage:message];
            }
            if ([@"webim" isEqualToString:message.ext[@"msg_type"]]) {
                if (![message.to isEqualToString:message.ext[@"real_receive_id"]]) {
                    NSLog(@"webimwebimwebimwebimwebim");
                    [conversation removeMessage:message];
                EMMessage *msg=[message initMessageWithID:message.messageId sender:message.from receiver:message.ext[@"real_receive_id"] bodies:message.messageBodies];
                [[EaseMob sharedInstance].chatManager insertMessagesToDB:@[msg]];
            }
            }
       // }
        if (![conversation.chatter isEqualToString:@"admin"]&&![conversation.chatter isEqualToString:[GlobalConst shareInstance].loginInfo.login_name]) {
            [tmpArray addObject:conversation];
        }
      }
    //[[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    ret = [[NSMutableArray alloc] initWithArray:tmpArray];
    
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate ChatListformattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}



#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ChatListCell" owner:nil options:nil];
        cell = [arr lastObject];
        
    }
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    //    cell.name = conversation.chatter;
    EMMessage *msg = conversation.latestMessage;
    NSLog(@">>>>>>>>>>>收到的消息是>>>>>>>>>>>>>%@",msg.ext);
    if (conversation.conversationType == eConversationTypeChat) {
       EMBuddy *buddy;
        if ([msg.ext[@"msg_type"] isEqualToString:@"webim"]) {
           buddy = [EMBuddy buddyWithUsername:msg.ext[@"real_receive_id"]];
        }else{
            buddy = [EMBuddy buddyWithUsername:conversation.chatter];
        }
        //EMBuddy *buddy = [EMBuddy buddyWithUsername:conversation.chatter];
        //        NSLog(@">>>>>>>>>聊天列表name>>>>>>>>>>%@",buddy.username);
        if ([conversation.chatter isEqualToString:buddy.username]) {
        [MessageHandler getUserInfoByUserAccount:buddy.username success:^(BaseEntity *object) {
            
            ChatListUserEntity *chatEntity = (ChatListUserEntity *)object;
            NSDictionary *dict = chatEntity.dataDic;
            //            NSLog(@">>>>>>>>>聊天列表请求的数据dict>>>>>>>>>>%@",dict);
            NSString *nameString = dict[@"REAL_NAME"];
            if (nameString.length == 0) {
                cell.name = dict[@"LOGIN_NAME"];
            }
            else
            {
                cell.name = dict[@"REAL_NAME"];
            }
            
            [cell.avtarImageView sd_setImageWithURL:dict[@"thumb"] placeholderImage:[UIImage imageNamed:@"chatListCellHead.png"]];
        } fail:^(id object) {
            //            cell.layer.cornerRadius=25;
            //            cell.layer.masksToBounds=YES;
            cell.name = buddy.username;
            cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
            
        }];
        }
    }
    else{
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"])
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    //                    NSLog(@">>>>>>>>>群聊group11111111>>>>>>>>>>%@",group);
                    //                    cell.name = group.groupSubject;
                    NSRange range = [group.groupSubject rangeOfString:@"ZZDBDZKJYXGS"];
                    if (range.length >0) {
                        
                        NSString * result = [group.groupSubject substringFromIndex:range.location];
                        NSLog(@"%@",result);
                        if ([result isEqualToString:patients_group_list]) {
                            cell.name = [[group.groupSubject componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                        }
                        if ([result isEqualToString:tongHang_group_list]) {
                            cell.name = [[group.groupSubject componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                        }
                        if ([result isEqualToString:huizhen_group_list]) {
                            cell.name = [[group.groupSubject componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                        }
                    }
                    
                    imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                    
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    
                    
                    break;
                }
            }
        }
        else
        {
            //            NSLog(@">>>>>>>>>群聊conversation.ext>>>>>>>>>>%@",conversation.ext);
            NSString *groupName = [conversation.ext objectForKey:@"groupSubject"];
            NSRange range = [groupName rangeOfString:@"ZZDBDZKJYXGS"];
            if (range.length >0) {
                
                NSString * result = [groupName substringFromIndex:range.location];
                NSLog(@"%@",result);
                if ([result isEqualToString:patients_group_list]) {
                    cell.name = [[groupName componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                }
                if ([result isEqualToString:tongHang_group_list]) {
                    cell.name = [[groupName componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                }
                if ([result isEqualToString:huizhen_group_list]) {
                    cell.name = [[groupName componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                }
            }
            
            //            cell.name = [conversation.ext objectForKey:@"groupSubject"];
            //            group_header
            [cell.avtarImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"group_header"]];
            imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        }
        cell.placeholderImage = [UIImage imageNamed:imageName];
    }
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    ChatViewController *chatController;
    NSString *title = conversation.chatter;
    if (conversation.conversationType != eConversationTypeChat) {
        if ([[conversation.ext objectForKey:@"groupSubject"] length])
        {
            title = [conversation.ext objectForKey:@"groupSubject"];
        }
        else
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    title = group.groupSubject;
                    break;
                }
            }
        }
        NSString *chatter = conversation.chatter;
        
        chatController = [[ChatViewController alloc] initWithChatter:chatter
                                                    conversationType:conversation.conversationType];
        NSRange range = [title rangeOfString:@"ZZDBDZKJYXGS"];
        if (range.length >0) {
            
            NSString * result = [title substringFromIndex:range.location];
            NSLog(@"%@",result);
            if ([result isEqualToString:patients_group_list]) {
                title = [[title componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                chatController.friend_type = 0;
                chatController.qunGroup_type = patients_group_list;
            }
            if ([result isEqualToString:tongHang_group_list]) {
                title = [[title componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                chatController.friend_type = 1;
                chatController.qunGroup_type = tongHang_group_list;
            }
            if ([result isEqualToString:huizhen_group_list]) {
                title = [[title componentsSeparatedByString:@"ZZDBDZKJYXGS"] safeObjectAtIndex:0];
                chatController.friend_type = 1;
                chatController.qunGroup_type = huizhen_group_list;
            }
        }
        
    } else if (conversation.conversationType == eConversationTypeChat) {
        ChatListCell *cell = (ChatListCell *)[tableView cellForRowAtIndexPath:indexPath];
        title = cell.name;
        NSString *chatter;
        EMMessage *msg = conversation.latestMessageFromOthers;
        //        if ([msg.ext[@"msg_type"] isEqualToString:@"webim"]) {
        //            chatter = msg.ext[@"real_receive_id"];
        //        }else{
        chatter = conversation.chatter;
        //        }
        
        chatController = [[ChatViewController alloc] initWithChatter:chatter
                                                    conversationType:conversation.conversationType];
             NSLog(@">>>>>>>>>>>>消息列表嘛呢>>>>>>>>>>>>>>>>%@",msg);
        if ([msg.ext[@"msg_type"] isEqualToString:@"webim"]||[msg.ext[@"msg_type"] isEqualToString:@"app"]) {
            chatController.msg_type = doctor_to_patient;
            NSLog(@"%@XXXXX",msg.ext[@"msg_type"]);
        }else{
            if ([GlobalConst shareInstance].loginInfo.user_type==1) {
                chatController.chatToType = doctor_to_tong_hang;
            }else{
                chatController.chatToType =patient_to_doctor;
            }
        }
        
        //        for (UserEntity *userEntity in self.friendEntityArray) {
        //            if ([chatter isEqualToString:userEntity.PHONE]) {
        //                chatController.msg_type = doctor_to_patient;
        //            }
        //        }
    }
    
    chatController.title = title;
    
    chatController.delelgate = self;
    [self.tabBarController.navigationController pushViewController:chatController animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



#pragma mark - ChatViewControllerDelegate

// 根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
- (NSString *)avatarWithChatter:(NSString *)chatter{
    //    return @"http://img0.bdstatic.com/img/image/shouye/jianbihua0525.jpg";
    return nil;
}

// 根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
- (NSString *)nickNameWithChatter:(NSString *)chatter{
    return chatter;
}


- (HMBannerView *)headerView
{
    if (_headerView == nil) {
        
        _headerView = [[HMBannerView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT/3) scrollDirection:ScrollDirectionLandscape images:@[@""]];
        _headerView.rollingDelayTime = 1.5;
    }
    
    return _headerView;
}

- (void)getAds
{
    NSDictionary *dic = [BaseEntity sign: nil];
    [[GRNetworkAgent sharedInstance] requestUrl:ADS_URL param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodGet withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        
        AdsEntity *entity = [AdsEntity objectWithKeyValues:reponeObject];
        if (entity.data == 0) {
            [self showString:@""];
            NSLog(@">>>>>>无数据>>>>>>>");
            return ;
        }
        NSMutableArray *arr = [NSMutableArray array];
        
        for (AdsEntity *info in entity.data) {
            //判断用户加载图片
            NSLog(@">>>>>>>>//判断用户加载图片>>>>>>>>>>>%@",info.url);
            NSLog(@"%ld",[GlobalConst shareInstance].loginInfo.user_type);
            NSLog(@"%ld",info.type);
            if(info.type ==[GlobalConst shareInstance].loginInfo.user_type){
                [arr safeAddObject: info.url];
            }
        }
        if (arr.count == 0) {
            NSLog(@">>>数组空>>>无数据>>>>>>>");
            return;
        }
        if (arr != nil) {
            [self.headerView updateCycleScrollView:arr];
        }
        
        
    } failure:^(GRBaseRequest *request, NSError *error) {
        
    } withTag:0];
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==900){
        if(_msgId){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
        [dic setObject:_msgId forKey:@"id"];
        [[GRNetworkAgent sharedInstance] requestUrl:checkTreatment param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
        } failure:^(GRBaseRequest *request, NSError *error) {
        } withTag:0];
        }
    }
}


@end
