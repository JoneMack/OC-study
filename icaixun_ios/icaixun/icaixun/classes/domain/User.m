//
//  User.m
//  icaixun
//
//  Created by 冯聪智 on 15/7/16.
//  Copyright (c) 2015年 赣州珍平投资咨询. All rights reserved.
//

#import "User.h"

@implementation User


-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInt:self.userGender forKey:@"gender"];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.loginMobileNo forKey:@"loginMobileNo"];
    [aCoder encodeObject:self.userCode forKey:@"userCode"];
    [aCoder encodeInt:self.initPwd forKey:@"initPwd"];
    [aCoder encodeObject:self.invitationCode forKey:@"invitationCode"];
    [aCoder encodeObject:self.userAccount forKey:@"userAccount"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if(self){
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.userGender = [aDecoder decodeIntForKey:@"gender"];
        self.avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.loginMobileNo = [aDecoder decodeObjectForKey:@"loginMobileNo"];
        self.userCode = [aDecoder decodeObjectForKey:@"userCode"];
        self.initPwd = [aDecoder decodeIntForKey:@"initPwd"];
        self.invitationCode = [aDecoder decodeObjectForKey:@"invitationCode"];
        self.userAccount = [aDecoder decodeObjectForKey:@"userAccount"];
    }
    
    return self;
}

- (void) readFromJSONDictionary:(NSDictionary *)jsonDict{
    [self setId:[jsonDict objectForKey:@"id"]];
    [self setName:[jsonDict objectForKey:@"name"]];
    [self setUserGender:[[jsonDict objectForKey:@"userGender"] intValue]];
    [self setAccessToken:[jsonDict objectForKey:@"accessToken"]];
    [self setLoginMobileNo:[jsonDict objectForKey:@"loginMobileNo"]];
    [self setUserCode:[jsonDict objectForKey:@"userCode"]];
    [self setAvatarUrl:[jsonDict objectForKey:@"avatarUrl"]];
    [self setInitPwd:[[jsonDict objectForKey:@"initPwd"] intValue]];
    [self setInvitationCode:[jsonDict objectForKey:@"invitationCode"]];
    [self setUserAccount:[jsonDict objectForKey:@"userAccount"]];
}

-(User *) copyWithZone:(NSZone *)zone{
    User *user = [[User allocWithZone:zone] init];
    
    user.id = self.id;
    user.name = self.name;
    user.userGender = self.userGender;
    user.accessToken = self.accessToken;
    user.loginMobileNo = self.loginMobileNo;
    user.userCode = self.userCode;
    user.avatarUrl = self.avatarUrl;
    user.initPwd = self.initPwd;
    user.invitationCode = self.invitationCode;
    user.userAccount = self.userAccount;
    return user;
}


-(NSString *) description{
    return [NSString stringWithFormat:@"id:%@, name:%@, accessToken:%@, moblieNo:%@", self.id, self.name, self.accessToken, self.loginMobileNo];
}


-(int) getUserCurrentPoint{
    return [[self.userAccount objectForKey:@"point"] intValue];
}


@end
