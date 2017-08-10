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

#import "MessageModelManager.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "MessageModel.h"

@implementation MessageModelManager

+ (id)modelWithMessage:(EMMessage *)message
{
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:kSDKUsername];
    NSString *sender = (message.messageType == eMessageTypeChat) ? message.from : message.groupSenderName;
   
    
#warning  原来的

//    BOOL isSender = [login isEqualToString:sender] ? YES : NO;
    
    
#warning  更改的地方，你自己测试一下，这儿判断左右显示聊天的和区分web是否
    
    BOOL isSender = nil;
    
    if ([@"webim" isEqualToString:message.ext[@"msg_type"]]) {
        
        isSender =  [@"webim" isEqualToString:message.ext[@"msg_type"]] ? YES : NO;
    }else{
        isSender = [login isEqualToString:sender] ? YES : NO;
        
    }

#warning  更改的地方，你自己测试一下，这儿判断左右显示聊天的和区分web是否、、、、、、、、、、、结束

    
    
    
    MessageModel *model = [[MessageModel alloc] init];
    model.isRead = message.isRead;
    model.messageBody = messageBody;
    model.message = message;
    model.type = messageBody.messageBodyType;
    model.msg_type = message.ext[@"msg_type"];
    model.isSender = isSender;
    model.isPlaying = NO;
    model.messageType = message.messageType;
    if (model.messageType != eMessageTypeChat) {
        model.username = message.groupSenderName;
    }
    else{
        model.username = message.from;
    }

    /*
    if (isSender) {
        model.headImageURL = nil;
    }
    else{
        model.headImageURL = nil;
    }
     */
    
    switch (messageBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 表情映射。
            NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                        convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
            if ([model.msg_type isEqualToString:@"webim"]) {
                model.content = [NSString stringWithFormat:@"%@【助理】",didReceiveText];
            }else{
                model.content = didReceiveText;
            }
        }
            break;
        case eMessageBodyType_Image:
        {
            EMImageMessageBody *imgMessageBody = (EMImageMessageBody*)messageBody;
            model.thumbnailSize = imgMessageBody.thumbnailSize;
            model.size = imgMessageBody.size;
            model.localPath = imgMessageBody.localPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            if (isSender)
            {
                model.image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            }else {
                model.imageRemoteURL = [NSURL URLWithString:imgMessageBody.remotePath];
            }
        }
            break;
        case eMessageBodyType_Location:
        {
            model.address = ((EMLocationMessageBody *)messageBody).address;
            model.latitude = ((EMLocationMessageBody *)messageBody).latitude;
            model.longitude = ((EMLocationMessageBody *)messageBody).longitude;
        }
            break;
        case eMessageBodyType_Voice:
        {
            model.time = ((EMVoiceMessageBody *)messageBody).duration;
            model.chatVoice = (EMChatVoice *)((EMVoiceMessageBody *)messageBody).chatObject;
            if (message.ext) {
                NSDictionary *dict = message.ext;
                BOOL isPlayed = [[dict objectForKey:@"isPlayed"] boolValue];
                model.isPlayed = isPlayed;
            }else {
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@NO,@"isPlayed", nil];
                message.ext = dict;
                [message updateMessageExtToDB];
            }
            // 本地音频路径
            model.localPath = ((EMVoiceMessageBody *)messageBody).localPath;
            model.remotePath = ((EMVoiceMessageBody *)messageBody).remotePath;
        }
            break;
        case eMessageBodyType_Video:{
            EMVideoMessageBody *videoMessageBody = (EMVideoMessageBody*)messageBody;
            model.thumbnailSize = videoMessageBody.size;
            model.size = videoMessageBody.size;
            model.localPath = videoMessageBody.thumbnailLocalPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:videoMessageBody.thumbnailLocalPath];
            model.image = model.thumbnailImage;
        }
            break;
        default:
            break;
    }
    
    NSLog(@">>>>>>>>>>>传递的model是>>>>>>>>>>>>>>>%@----------%@",model.msg_type,model.content);
    return model;
}

@end
