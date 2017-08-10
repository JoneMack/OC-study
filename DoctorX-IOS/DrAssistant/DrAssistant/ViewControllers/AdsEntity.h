//
//  AdsEntity.h
//  DrAssistant
//
//  Created by hi on 15/9/9.
//  Copyright (c) 2015年 Doctor. All rights reserved.
//

#import "BaseEntity.h"

@interface AdsEntity : BaseEntity

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger type;

@end
