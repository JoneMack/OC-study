//
//  ContractInfoList.h
//  xiangyu
//
//  Created by xubojoy on 16/9/26.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ContractInfoList
@end
@interface ContractInfoList : JSONModel

@property (nonatomic ,strong) NSArray *historyInfoList;
@property (nonatomic ,strong) NSString<Optional> *houseAdminAddress;
@property (nonatomic ,strong) NSDictionary<Optional> *houseConfigure;
@property (nonatomic ,strong) NSString<Optional> *houseFmpica;
@property (nonatomic ,strong) NSDictionary<Optional> *rentType;

@end
