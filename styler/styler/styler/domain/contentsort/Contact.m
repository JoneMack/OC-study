//
//  Contacts.m
//  Golf
//
//  Created by xubojoy on 15/4/8.
//  Copyright (c) 2015年 xubojoy. All rights reserved.
//

#import "Contact.h"
#import "Store.h"
@implementation Contact


-(NSString *)getJsonString
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(self.userId) forKey:@"userId"];
    [params setObject:self.name forKey:@"name"];
    [params setObject:self.phone forKey:@"phone"];
    [params setObject:@(self.userGender) forKey:@"userGender"];
    [params setObject:@(self.contactsType) forKey:@"contactsType"];
    return [params JSONString];
}


@end
