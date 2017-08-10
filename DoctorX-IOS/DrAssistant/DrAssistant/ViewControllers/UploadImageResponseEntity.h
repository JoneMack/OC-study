//
//  UploadImageResponseEntity.h
//  DrAssistant
//
//  Created by taller on 15/9/25.
//  Copyright © 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface UploadImageResponseEntity : BaseEntity
@property (nonatomic,strong) NSString *dataDic;
+ (UploadImageResponseEntity *)entityOfDic:(NSDictionary *)dic;

@end
