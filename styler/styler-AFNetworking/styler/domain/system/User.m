//
//  User.m
//  styler
//
//  Created by System Administrator on 13-5-15.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//


#import "User.h"
@implementation User

-(NSString *)genderTxt{
    if(self.gender == gender_male){
        return @"男";
    }
    return @"女";
}

-(void) addFavStylist:(int)id{
    if(self.favStylistIds == nil){
        self.favStylistIds = [[NSMutableSet alloc] init];
    }
    NSMutableSet *stylistIds = [[NSMutableSet alloc] initWithSet:self.favStylistIds];
    [stylistIds addObject:@(id)];
    self.favStylistIds = stylistIds;
}

-(void) removeFavStylist:(int)id{
    
    NSMutableSet *stylistIds = [[NSMutableSet alloc] init];
    for (NSNumber *favId in self.favStylistIds) {
        if([favId intValue] != id){
            [stylistIds addObject:favId];
        }
    }
    self.favStylistIds = stylistIds;
}

-(BOOL) hasAddFavStylist:(int)stylistId{
    if(self.favStylistIds != nil){
        for (NSNumber *favId in self.favStylistIds) {
            if([favId intValue] == stylistId){
                return YES;
            }
        }
    }
    return NO;
}

-(void) addFavWork:(int)workId{
    if(self.favWorksIds == nil){
        self.favWorksIds = [[NSMutableSet alloc] init];
    }
    NSMutableSet *worksIds = [[NSMutableSet alloc] initWithSet:self.favWorksIds];
    [worksIds addObject:@(workId)];
    self.favWorksIds = worksIds;
}

-(void) removeFavWork:(int)workId{
   if(self.favWorksIds != nil)
       [self.favWorksIds removeObject:@(workId)];
}

-(BOOL) hasAddFavWork:(int)workId{
    if(self.favWorksIds != nil ){
        for (NSNumber *favId in self.favWorksIds) {
            if ((NSNull*)favId == [NSNull null]) {
                continue;
            }
            if([favId intValue] == workId){
                return YES;
            }
        }
    }
    return NO;
}
-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.idStr forKey:@"id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInt:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
    [aCoder encodeObject:self.loginMobileNo forKey:@"loginMobileNo"];
    [aCoder encodeObject:self.easemobUserUuid forKey:@"easemobUserUuid"];
    [aCoder encodeObject:self.userCode forKey:@"userCode"];
    [aCoder encodeInt:self.evaluationCount forKey:@"evaluationCount"];
    [aCoder encodeInt:self.unevaluateCount forKey:@"unEvaluatingCount"];
    if(self.favStylistIds != nil)
        [aCoder encodeObject:self.favStylistIds forKey:@"favExpertIds"];
    
    if(self.favWorksIds != nil){
        [aCoder encodeObject:self.favWorksIds forKey:@"favWorksIds"];
    }
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    if(self){
        self.idStr = [aDecoder decodeObjectForKey:@"id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.gender = [aDecoder decodeIntForKey:@"gender"];
        self.avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
        self.accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
        self.loginMobileNo = [aDecoder decodeObjectForKey:@"loginMobileNo"];
        self.easemobUserUuid = [aDecoder decodeObjectForKey:@"easemobUserUuid"];
        self.userCode = [aDecoder decodeObjectForKey:@"userCode"];
        self.favStylistIds = [aDecoder decodeObjectForKey:@"favExpertIds"];
        self.favWorksIds = [aDecoder decodeObjectForKey:@"favWorksIds"];
        self.evaluationCount = [aDecoder decodeIntForKey:@"evaluationCount"];
        self.unevaluateCount = [aDecoder decodeIntForKey:@"unEvaluatingCount"];
    }
    
    return self;
}

- (void) readFromJSONDictionary:(NSDictionary *)jsonDict{
    [self setIdStr:[jsonDict objectForKey:@"id"]];
    [self setName:[jsonDict objectForKey:@"name"]];
    [self setGender:[[jsonDict objectForKey:@"userGender"] intValue]];
    [self setAccessToken:[jsonDict objectForKey:@"accessToken"]];
    [self setLoginMobileNo:[jsonDict objectForKey:@"loginMobileNo"]];
    [self setEasemobUserUuid:[jsonDict objectForKey:@"easemobUserUuid"]];
    [self setUserCode:[jsonDict objectForKey:@"userCode"]];
    [self setAvatarUrl:[jsonDict objectForKey:@"avatarUrl"]];
    [self setFavStylistIds:[[NSMutableSet alloc] initWithArray:[jsonDict objectForKey:@"collectedExpertIds"]]];
    [self setFavWorksIds:[[NSMutableSet alloc]initWithArray:[jsonDict objectForKey:@"favWorksIds"]] ];
    [self setEvaluationCount:[[jsonDict objectForKey:@"evaluationCount"] intValue]];
    [self setUnevaluateCount:[[jsonDict objectForKey:@"unEvaluatingCount"] intValue]];
}

-(User *) copyWithZone:(NSZone *)zone{
    User *user = [[User allocWithZone:zone] init];
    
    user.idStr = self.idStr;
    user.name = self.name;
    user.gender = self.gender;
    user.accessToken = self.accessToken;
    user.loginMobileNo = self.loginMobileNo;
    user.easemobUserUuid = self.easemobUserUuid;
    user.userCode = self.userCode;
    user.avatarUrl = self.avatarUrl;
    user.favStylistIds = self.favStylistIds;
    user.favWorksIds = self.favWorksIds;
    user.evaluationCount = self.evaluationCount;
    user.unevaluateCount = self.unevaluateCount;
    
    return user;
}


-(NSString *) description{
    return [NSString stringWithFormat:@"id:%@, name:%@, accessToken:%@, moblieNo:%@, favExpertIds:%@, favWorksIds:%@ ,evaluations:%d , unevaluate :%d", self.idStr, self.name, self.accessToken, self.loginMobileNo, self.favStylistIds, self.favWorksIds,self.evaluationCount,self.unevaluateCount];
}

@end
