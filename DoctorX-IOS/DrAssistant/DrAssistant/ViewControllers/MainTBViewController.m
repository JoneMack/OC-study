//
//  MainTBViewController.m
//  DrAssistant
//
//  Created by hi on 15/9/2.
//  Copyright (c) 2015Âπ? Doctor. All rights reserved.
//

#import "MainTBViewController.h"
#import "AccountViewController.h"
#import "MyClubViewController.h"
#import "MyDoctorViewController.h"
#import "MyTongHangController.h"

#import "AccountViewController.h"
#import "ChatListViewController.h"
#import "MyTongHangController.h"
#import "MyPatientController.h"
#import "MyPAccountController.h"
#import <AVFoundation/AVFoundation.h>
#import "EMCDDeviceManager.h"
#import "ChatViewController.h"
#import "TTGlobalUICommon.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

MainTBViewController *tabbarVC;

@interface MainTBViewController ()<UIAlertViewDelegate, IChatManagerDelegate, EMCallManagerDelegate>
{
    ChatListViewController *_chatListVC;
    EMConnectionState _connectionState;
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong, nonatomic) NSString *userFriendName;
@property (strong, nonatomic) NSString *msgId;
@end

@implementation MainTBViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNOTIFICATION_LOGOUT object:nil];
     [self unregisterNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
#warning 把self注册为SDK的delegate
    [self registerNotifications];
    
    self.view.backgroundColor = [UIColor defaultBgColor];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:nil];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *nItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = nItem;
    
    tabbarVC = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginout:) name:KNOTIFICATION_LOGINCHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutWithChatter:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callControllerClose:) name:@"callControllerClose" object:nil];
    
    [self addControl];
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [self didUnreadMessagesCountChanged];
}

- (void)addControl
{
    USER_TYPE type = [GlobalConst shareInstance].loginInfo.user_type;
   
    _chatListVC = [ChatListViewController simpleInstance];
    [self addChildVc:_chatListVC title:@"消息" image:@"Informationa.png" selectedImage:@"Informationb.png"];
    
    if (type == PatientType) {
        
        MyDoctorViewController *mdVC = [MyDoctorViewController simpleInstance];
        [self addChildVc:mdVC title:@"医生" image:@"mydoctorsa" selectedImage:@"mydoctorsb"];
        
        MyClubViewController *myClub = [MyClubViewController simpleInstance];
        [self addChildVc:myClub title:@"俱乐部" image:@"tab_club" selectedImage:@"tab_club_Sel"];
        
        MyPAccountController *mpAccount = [MyPAccountController simpleInstance];
        [self addChildVc:mpAccount title:@"我" image:@"tab_myAccont" selectedImage:@"tab_myAccont_Sel"];
        
    }else if (type == DoctorType){
        
        MyPatientController *patientVC = [MyPatientController simpleInstance];
        [self addChildVc:patientVC title:@"患者" image:@"tab_myPatients" selectedImage:@"tab_myPatients_Sel"];
        
        MyTongHangController *tonghangVC = [MyTongHangController simpleInstance];
        [self addChildVc:tonghangVC title:@"同行" image:@"tab_myTongHang" selectedImage:@"tab_myTongHang_Sel"];
        
//        MyAssistantController *assitantVC = [MyAssistantController simpleInstance];
//       [self addChildVc:assitantVC title:@"我的助理" image:@"tab_Assistant" selectedImage:@"tab_Assistant_Sel"];
        
        AccountViewController *myAVC = [AccountViewController simpleInstance];
        [self addChildVc:myAVC title:@"我" image:@"tab_myAccont" selectedImage:@"tab_myAccont_Sel"];
    }
}

- (void)loginout:(NSNotification *)notification
{
    if ([notification.object isNSNumber]) {
        if (![notification.object boolValue]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configTabBarImageAndColor];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private


- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIColor *nor_color = COLOR(83, 83, 83, 1.0);
    UIColor *sel_color = COLOR(19, 181, 177, 1.0);
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] =nor_color;
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = sel_color;
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}


- (void)configTabBarImageAndColor
{
    UIColor *nor_color = COLOR(83, 83, 83, 1.0);
    UIColor *sel_color = COLOR(19, 181, 177, 1.0);
    NSArray *nor_images = nil;
    NSArray *sel_images = nil;
    
    USER_TYPE type = [GlobalConst shareInstance].loginInfo.user_type;
    if (type == DoctorType) {
        
        nor_images = @[@"Informationa.png", @"mypatienta.png", @"club.png" , @"mya.png"];
        sel_images = @[@"Informationb.png",@"mypatientb.png",  @"clubb.png" , @"myb.png"];
        
    }else if (type == PatientType){
        
        nor_images = @[@"Informationa.png", @"mydoctora.png" ,@"club.png", @"mya.png"];
        sel_images = @[@"Informationb.png", @"mydoctorb.png" ,@"clubb.png", @"myb.png"];
    }
    
    for (NSInteger i = 0; i < self.tabBar.items.count; i++)
    {
        UITabBarItem *item = [self.tabBar.items safeObjectAtIndex: i];
        NSDictionary *normlDic = @{NSForegroundColorAttributeName :  nor_color};
        NSDictionary *selDic = @{NSForegroundColorAttributeName :  sel_color};
        
        [item setTitleTextAttributes:normlDic   forState:UIControlStateNormal];
        [item setTitleTextAttributes:selDic     forState:UIControlStateSelected];
        
        item.image = [[UIImage imageNamed:[nor_images safeObjectAtIndex: i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:[sel_images safeObjectAtIndex: i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}

- (UINavigationController *)navVC:(UIViewController *)viewVC
{
    return [[UINavigationController alloc] initWithRootViewController:viewVC];
}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //[[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //[[EaseMob sharedInstance].callManager removeDelegate:self];
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        if(![@"sys_notice" isEqualToString:conversation.latestMessage.ext[@"msg_type"]]&&![@"PUSH" isEqualToString:conversation.latestMessage.ext[@"type"]] && ![@"admin" isEqualToString:conversation.chatter]){
            unreadCount += conversation.unreadMessagesCount;
        }
        
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            
            NSString *text = [NSString stringWithFormat:@"%i",(int)unreadCount];
            _chatListVC.tabBarItem.badgeValue = text;
        }else{
            _chatListVC.tabBarItem.badgeValue = nil;
        }
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount
{
//    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
//        if (unreadCount > 0) {
//            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _contactsVC.tabBarItem.badgeValue = nil;
//        }
//    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}


#pragma mark - call

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    if (!bCanRecord) {
        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setting.microphoneNoAuthority", @"No microphone permissions") message:NSLocalizedString(@"setting.microphoneAuthority", @"Please open in \"Setting\"-\"Privacy\"-\"Microphone\".") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alt show];
    }
    
    return bCanRecord;
}

- (void)callOutWithChatter:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        if (![self canRecord]) {
            return;
        }
        
        EMError *error = nil;
        NSString *chatter = [object objectForKey:@"chatter"];
        EMCallSessionType type = [[object objectForKey:@"type"] intValue];
        EMCallSession *callSession = nil;
        if (type == eCallSessionTypeAudio) {
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:50 error:&error];
        }
        else if (type == eCallSessionTypeVideo){
//            if (![CallViewController canVideo]) {
//                return;
//            }
//            callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:50 error:&error];
        }
        
        if (callSession && !error) {
//            [[EaseMob sharedInstance].callManager removeDelegate:self];
//            
//            CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:NO];
//            callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
//            [self presentViewController:callController animated:NO completion:nil];
        }
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"error") message:error.description delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (void)callControllerClose:(NSNotification *)notification
{
    //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    [audioSession setActive:YES error:nil];
    
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    [_chatListVC refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages
{
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
//#if !TARGET_IPHONE_SIMULATOR
        
        //        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        //        if (!isAppActivity) {
        //            [self showNotificationWithMessage:message];
        //        }else {
        //            [self playSoundAndVibration];
        //        }
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                if ([@"PUSH" isEqualToString:message.ext[@"type"]]||[@"sys_notice" isEqualToString:message.ext[@"msg_type"]]) {
                    [self showNotificationWithMessage:message];
                }
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
//#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        //NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    //title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                //title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        //notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        NSLog(@"message:%@",message);
        if([@"PUSH" isEqualToString:message.ext[@"type"]]){
            //判断是否是服务器推送信息 然后标记为已读
            NSLog(@"判断是否是服务器推送信息 然后标记为已读");
        }else
        if([@"sys_notice" isEqualToString:message.ext[@"msg_type"]]){
            //判断是否是服务器推送认证信息 然后发送通知
           NSLog(@"message.messageType%@",message.messageBodies);
            id<IEMMessageBody> msgBody = [message.messageBodies firstObject];
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            if ([@"certOk" isEqualToString:txt] ) {
                txt=@"认证医生成功";
            }
            if ([@"certCancel" isEqualToString:txt]){
                txt=@"认证医生失败";
            }
            if([@"asstantRelationDoctorOk" isEqualToString:txt]){
               txt=@"申请助理成功";
            }
            if([@"assitantRelationDoctorCancel" isEqualToString:txt]){
               txt=@"申请助理失败";
            }
//            if([txt rangeOfString:@"医生的转诊记录"].location !=NSNotFound){
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"转诊信息" message:txt delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                _msgId=message.ext[@"msg_id"];
//                alertView.tag = 900;
//                [alertView show];
//                return;
//            }
            notification.alertBody=txt;
        }else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
        }
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
                                                  otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_chatListVC isConnect:NO];
    }
}

#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
    }
#endif
    message = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
    UIAlertView *alertView = nil;
    alertView = [[UIAlertView alloc] initWithTitle:@"好友请求" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 200;
    _userFriendName=username;
     [alertView show];
   //[_chatListVC isConnect:YES];
}

- (void)_removeBuddies:(NSArray *)userNames
{
    [[EaseMob sharedInstance].chatManager removeConversationsByChatters:userNames deleteMessages:YES append2Chat:YES];
    [_chatListVC refreshDataSource];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]] && [userNames containsObject:[(ChatViewController *)viewController chatter]])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    if (chatViewContrller)
    {
        [viewControllers removeObject:chatViewContrller];
        [self.navigationController setViewControllers:viewControllers animated:YES];
    }
    //[self showHint:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"delete", @"delete"), userNames[0]]];
}

- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{
    if (!isAdd)
    {
        NSMutableArray *deletedBuddies = [NSMutableArray array];
        for (EMBuddy *buddy in changedBuddies)
        {
            if ([buddy.username length])
            {
                [deletedBuddies addObject:buddy.username];
            }
        }
        if (![deletedBuddies count])
        {
            return;
        }
        
        [self _removeBuddies:deletedBuddies];
    } else {
        // clear conversation
        NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
        NSMutableArray *deleteConversations = [NSMutableArray arrayWithArray:conversations];
        NSMutableDictionary *buddyDic = [NSMutableDictionary dictionary];
        for (EMBuddy *buddy in buddyList) {
            if ([buddy.username length]) {
                [buddyDic setObject:buddy forKey:buddy.username];
            }
        }
        for (EMConversation *conversation in conversations) {
            if (conversation.conversationType == eConversationTypeChat) {
                if ([buddyDic objectForKey:conversation.chatter]) {
                    [deleteConversations removeObject:conversation];
                }
            } else {
                [deleteConversations removeObject:conversation];
            }
        }
        if ([deleteConversations count] > 0) {
            NSMutableArray *deletedBuddies = [NSMutableArray array];
            //for (EMConversation *conversation in deleteConversations) {
//                if (![[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
//                    [deletedBuddies addObject:conversation.chatter];
//                }
            //}
            if ([deletedBuddies count] > 0) {
                [self _removeBuddies:deletedBuddies];
            }
        }
    }
    //[_contactsVC reloadDataSource];
}

- (void)didRemovedByBuddy:(NSString *)username
{    //停止删除好友提示
    //[self _removeBuddies:@[username]];
    //[_contactsVC reloadDataSource];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
    //[_contactsVC reloadDataSource];
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"you are shameless refused by '%@'"), username];
    TTAlertNoTitle(message);
}

- (void)didAcceptBuddySucceed:(NSString *)username
{
    //_contactsVC reloadDataSource];
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
#endif
    
   // [_contactsVC reloadGroupView];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!error) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
        
        //[_contactsVC reloadGroupView];
    }
}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"you are shameless refused by '%@'"), username];
    TTAlertNoTitle(message);
}


- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId
                               groupname:(NSString *)groupname
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed to join the group of \'%@\'"), groupname];
          [self showHint:message];
}

#pragma mark - IChatManagerDelegate 收到聊天室邀请

- (void)didReceiveChatroomInvitationFrom:(NSString *)chatroomId
                                 inviter:(NSString *)username
                                 message:(NSString *)message
{
    message = [NSString stringWithFormat:NSLocalizedString(@"chatroom.somebodyInvite", @"%@ invite you to join chatroom \'%@\'"), username, chatroomId];
    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

- (void)didServersChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)didAppkeyChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }else{
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}

#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    if (callSession.status == eCallSessionStatusConnected)
    {
        EMError *error = nil;
        do {
            BOOL isShowPicker = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowPicker"] boolValue];
            if (isShowPicker) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
            if (![self canRecord]) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
#warning 在后台不能进行视频通话
//            if(callSession.type == eCallSessionTypeVideo && ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive || ![CallViewController canVideo])){
//                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
//                break;
//            }
            
            if (!isShowPicker){
                [[EaseMob sharedInstance].callManager removeDelegate:self];
//                CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:YES];
//                callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
//                [self presentViewController:callController animated:NO completion:nil];
//                if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]])
//                {
//                    ChatViewController *chatVc = (ChatViewController *)self.navigationController.topViewController;
//                    chatVc.isInvisible = YES;
//                }
            }
        } while (0);
        
        if (error) {
            [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReasonHangup];
            return;
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if (buttonIndex != [alertView cancelButtonIndex]) {
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                //[[ApplyViewController shareController] clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            } onQueue:nil];
        }
    }
    else if (alertView.tag == 100) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    } else if (alertView.tag == 101) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }else if (alertView.tag==200){
        //同意好友添加请求
        if (buttonIndex==1) {
            NSString *userId = [GlobalConst shareInstance].loginInfo.iD;
            NSInteger user_type = [GlobalConst shareInstance].loginInfo.user_type;
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
            [dic setObject:userId forKey:@"userId"];
            [dic setObject:[self userFriendName]forKey:@"friendname"];
            [dic setObject:@"true" forKey:@"agreed"];
            if (user_type==1) {
                [dic setObject:@"true" forKey:@"isDoct"];
            }else{
                [dic setObject:@"false" forKey:@"isDoct"];
            }
            [[GRNetworkAgent sharedInstance] requestUrl:contactAgreed param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
                EMError *error = nil;
                BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:[self userFriendName] error:&error];
                if (isSuccess && !error) {
                    NSLog(@"发送同意成功");
                }
            } failure:^(GRBaseRequest *request, NSError *error) {
            } withTag:0];
        }else{
            [[EaseMob sharedInstance].chatManager rejectBuddyRequest:[self userFriendName] reason:nil error:nil];
        }

    }else if (alertView.tag==900){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[BaseEntity sign:nil]];
        [dic setObject:_msgId forKey:@"id"];
        [[GRNetworkAgent sharedInstance] requestUrl:checkTreatment param:dic baseUrl:BASEURL withRequestMethod:GRRequestMethodPost withCompletionBlockWithSuccess:^(GRBaseRequest *request, id reponeObject) {
            EMError *error = nil;
            BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:[self userFriendName] error:&error];
            if (isSuccess && !error) {
                NSLog(@"发送同意成功");
            }
        } failure:^(GRBaseRequest *request, NSError *error) {
        } withTag:0];
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.chatter isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMMessageType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        switch (messageType) {
                            case eMessageTypeGroupChat:
                            {
                                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                                for (EMGroup *group in groupArray) {
                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                        chatViewController.title = group.groupSubject;
                                        break;
                                    }
                                }
                            }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = (ChatViewController *)obj;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMMessageType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case eMessageTypeGroupChat:
                    {
                        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.groupSubject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}


@end
