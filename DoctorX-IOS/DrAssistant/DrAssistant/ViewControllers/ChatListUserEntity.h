//
//  ChatListUserEntity.h
//  DrAssistant
//
//  Created by xubojoy on 15/9/29.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListUserEntity : BaseEntity
@property (nonatomic,strong) NSString* account;
@property (nonatomic,assign,readwrite) NSInteger timestmp;
@property (nonatomic,strong,readwrite) NSDictionary *dataDic;


- (NSDictionary *)dictionaryOfEntity;

/*response*/
+ (ChatListUserEntity *)entityOfDic:(NSDictionary *)dic;

@end
