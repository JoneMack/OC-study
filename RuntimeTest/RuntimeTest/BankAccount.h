//
//  BankAccount.h
//  RuntimeTest
//
//  Created by xubojoy on 2018/3/5.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "Transaction.h"
@interface BankAccount : NSObject
@property (nonatomic) NSNumber *currentBalance;              // An attribute
@property (nonatomic) Person *owner;                         // A to-one relation
@property (nonatomic) NSArray< Transaction* >* transactions; // A to-many relation
@end
