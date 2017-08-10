//
//  ChatViewController.h
//  DrAssistant
//
//  Created by hi on 15/9/4.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseViewController.h"

#import "EMChatManagerDefs.h"

#define patient_to_doctor   @"患者to医生"
#define doctor_to_patient   @"huanzhe"
#define doctor_to_tong_hang  @"tonghang"

@protocol ChatViewControllerDelegate <NSObject>

@optional
- (NSString *)avatarWithChatter:(NSString *)chatter;
- (NSString *)nickNameWithChatter:(NSString *)chatter;

@end

@interface ChatViewController : BaseViewController
@property (strong, nonatomic, readonly) NSString *chatter;
@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (nonatomic) BOOL isInvisible;
@property (nonatomic, assign) id <ChatViewControllerDelegate> delelgate;
@property (strong, nonatomic) EMConversation *conversation;//会话管理者

@property (nonatomic) NSInteger friend_type;//医生 or 患者
@property (nonatomic, strong) NSString *qunGroup_type;// 患者群聊，医生群聊，会诊

@property (nonatomic, strong) NSString *chatToType;

@property (nonatomic, strong) NSString *msg_type;//webim/app
@property (nonatomic, strong) NSString *real_receive_id;//接收对象

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type;

- (void)reloadData;

- (void)hideImagePicker;

#pragma mark - sendMessage
-(void)sendTextMessage:(NSString *)textMessage;
-(void)sendImageMessage:(UIImage *)image;
-(void)sendAudioMessage:(EMChatVoice *)voice;
-(void)sendVideoMessage:(EMChatVideo *)video;
-(void)sendLocationLatitude:(double)latitude
                  longitude:(double)longitude
                 andAddress:(NSString *)address;
-(void)addMessage:(EMMessage *)message;
- (EMMessageType)messageType;
@end
