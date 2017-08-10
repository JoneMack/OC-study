//
//  ResponeEntity.h
//  DrAssistant
//
//  Created by xubojoy on 15/10/22.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponeEntity : BaseEntity
@property (nonatomic,assign,readwrite) NSInteger timestmp;
@property (nonatomic,strong,readwrite) NSDictionary *dataDic;

+ (ResponeEntity *)entityOfDic:(NSDictionary *)dic;
@end
