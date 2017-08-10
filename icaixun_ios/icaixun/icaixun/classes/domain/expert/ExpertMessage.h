//
//  ExpertMessage.h
//  icaixun
//
//  Created by 冯聪智 on 15/7/24.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpertMessageImage.h"

/**
 *  专家发送的消息
 */

@interface ExpertMessage : JSONModel

@property (nonatomic , copy) NSString *id;
@property (nonatomic , assign) int expertId;
@property (nonatomic , copy) NSString *msg;
@property (nonatomic , assign) BOOL secret;
@property (nonatomic , assign) int praiseCount;
@property (nonatomic , assign) long long int createTime;

@property (nonatomic , strong) NSArray<Optional> *expertMassageImages;
@property (nonatomic , strong) NSString<Optional> *praiseStatus;

//渲染图片
-(void) fillPics;

// 渲染该消息是否已赞
-(void) fillPraiseStatus;

//获取赞的数量
-(NSString *) getPraiseCountStr;

@end
