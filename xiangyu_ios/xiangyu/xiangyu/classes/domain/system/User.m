//
//  UserStore.h
//  Golf
//
//  Created by xubojoy on 15/3/30.
//  Copyright (c) 2015年 xubojoy. All rights reserved.
//
#import "User.h"
@implementation User


-(void) encodeWithCoder:(NSCoder *)aCoder{
    NSLog(@"user encodeWithCoder");
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.communityId forKey:@"communityId"];
    [aCoder encodeObject:self.communityName forKey:@"communityName"];
    [aCoder encodeObject:self.buildingNo forKey:@"buildingNo"];
    [aCoder encodeObject:self.houseNo forKey:@"houseNo"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.weibo forKey:@"weibo"];

    [aCoder encodeObject:self.houseCode forKey:@"houseCode"];
    [aCoder encodeObject:self.houseId forKey:@"houseId"];
    [aCoder encodeObject:self.headPic forKey:@"headPic"];
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.idNo forKey:@"idNo"];
    [aCoder encodeObject:self.headPicMidium forKey:@"headPicMidium"];
    [aCoder encodeObject:self.currentCommunityId forKey:@"currentCommunityId"];
    
    [aCoder encodeObject:self.headPicPrimary forKey:@"headPicPrimary"];
    [aCoder encodeObject:self.projectName forKey:@"projectName"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.verifycode forKey:@"verifycode"];
    [aCoder encodeObject:self.projectNames forKey:@"projectNames"];
    [aCoder encodeObject:self.userPwd forKey:@"userPwd"];
    [aCoder encodeObject:self.photo forKey:@"photo"];
    [aCoder encodeObject:self.mobileFirstLogin forKey:@"mobileFirstLogin"];
    [aCoder encodeObject:self.mobileFirstDate forKey:@"mobileFirstDate"];
    
}


-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    NSLog(@"user initWithCoder");
    if(self){
        
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        self.headPic = [aDecoder decodeObjectForKey:@"headPic"];
        self.houseId = [aDecoder decodeObjectForKey:@"houseId"];
        self.houseCode = [aDecoder decodeObjectForKey:@"houseCode"];
        self.weibo = [aDecoder decodeObjectForKey:@"weibo"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.houseNo = [aDecoder decodeObjectForKey:@"houseNo"];
        self.unitNo = [aDecoder decodeObjectForKey:@"unitNo"];
        self.buildingNo = [aDecoder decodeObjectForKey:@"buildingNo"];
        self.communityName = [aDecoder decodeObjectForKey:@"communityName"];
        self.communityId = [aDecoder decodeObjectForKey:@"communityId"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        
        self.mobileFirstDate = [aDecoder decodeObjectForKey:@"mobileFirstDate"];
        self.mobileFirstLogin = [aDecoder decodeObjectForKey:@"mobileFirstLogin"];
        self.photo = [aDecoder decodeObjectForKey:@"photo"];
        self.userPwd = [aDecoder decodeObjectForKey:@"userPwd"];
        self.projectNames = [aDecoder decodeObjectForKey:@"projectNames"];
        self.verifycode = [aDecoder decodeObjectForKey:@"verifycode"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.projectName = [aDecoder decodeObjectForKey:@"projectName"];
        self.headPicPrimary = [aDecoder decodeObjectForKey:@"headPicPrimary"];
        self.currentCommunityId = [aDecoder decodeObjectForKey:@"currentCommunityId"];
        self.headPicMidium = [aDecoder decodeObjectForKey:@"headPicMidium"];
        self.idNo = [aDecoder decodeObjectForKey:@"idNo"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        
    }
    
    return self;
}


- (void) readFromJSONDictionary:(NSDictionary *)jsonDict{
    [self setMobileFirstDate:[jsonDict objectForKey:@"mobileFirstDate"]];
    [self setMobileFirstLogin:[jsonDict objectForKey:@"mobileFirstLogin"]];
    [self setPhoto:[jsonDict objectForKey:@"photo"]];
    
    [self setProjectNames:[jsonDict objectForKey:@"projectNames"]];
    [self setVerifycode:[jsonDict objectForKey:@"verifycode"]];
    [self setToken:[jsonDict objectForKey:@"token"]];
    [self setMobile:[jsonDict objectForKey:@"mobile"]];
    [self setBirthday:[jsonDict objectForKey:@"birthday"]];
    [self setProjectName:[jsonDict objectForKey:@"projectName"]];
    [self setHeadPicPrimary:[jsonDict objectForKey:@"headPicPrimary"]];
    [self setCurrentCommunityId:[jsonDict objectForKey:@"currentCommunityId"]];
    [self setHeadPicMidium:[jsonDict objectForKey:@"headPicMidium"]];
    [self setIdNo:[jsonDict objectForKey:@"idNo"]];
    [self setCityName:[jsonDict objectForKey:@"cityName"]];
    [self setCityId:[jsonDict objectForKey:@"cityId"]];
    [self setHeadPic:[jsonDict objectForKey:@"headPic"]];
    [self setHouseId:[jsonDict objectForKey:@"houseId"]];
    [self setHouseCode:[jsonDict objectForKey:@"houseCode"]];
    [self setWeibo:[jsonDict objectForKey:@"weibo"]];
    [self setStatus:[jsonDict objectForKey:@"status"]];
    [self setAddress:[jsonDict objectForKey:@"address"]];
    [self setAge:[jsonDict objectForKey:@"age"]];
    [self setEmail:[jsonDict objectForKey:@"email"]];
    [self setGender:[jsonDict objectForKey:@"gender"]];
    [self setHouseNo:[jsonDict objectForKey:@"houseNo"]];
    [self setUnitNo:[jsonDict objectForKey:@"unitNo"]];
    [self setBuildingNo:[jsonDict objectForKey:@"buildingNo"]];
    [self setCommunityName:[jsonDict objectForKey:@"communityName"]];
    [self setCommunityId:[jsonDict objectForKey:@"communityId"]];
    [self setPassword:[jsonDict objectForKey:@"password"]];
    
    [self setUserName:[jsonDict objectForKey:@"userName"]];
    [self setUserId:[jsonDict objectForKey:@"userId"]];
    [self setNickname:[jsonDict objectForKey:@"nickname"]];
    [self setId:[jsonDict objectForKey:@"id"]];
    
}


-(User *) copyWithZone:(NSZone *)zone{
    NSLog(@"user copyWithZone");
    User *user = [[User allocWithZone:zone] init];
    user.mobileFirstDate = self.mobileFirstDate;
    user.mobileFirstLogin = self.mobileFirstLogin;
    user.photo = self.photo;
    user.userPwd = self.userPwd;
    
    user.projectNames = self.projectNames;
    user.verifycode = self.verifycode;
    user.token = self.token;
    user.mobile = self.mobile;
    user.birthday = self.birthday;
    user.projectName = self.projectName;
    user.headPicPrimary = self.headPicPrimary;
    user.currentCommunityId = self.currentCommunityId;
    user.headPicMidium = self.headPicMidium;
    user.idNo = self.idNo;
    
    user.cityName = self.cityName;
    user.cityId = self.cityId;
    user.headPic = self.headPic;
    user.houseId = self.houseId;
    user.houseCode = self.houseCode;
    user.weibo = self.weibo;
    user.status = self.status;
    user.address = self.address;
    user.age = self.age;
    user.email = self.email;
    user.gender = self.gender;
    user.houseNo = self.houseNo;
    user.unitNo = self.unitNo;
    user.buildingNo = self.buildingNo;
    user.communityName = self.communityName;
    user.communityId = self.communityId;
    user.password = self.password;
    user.userName = self.userName;
    user.userId = self.userId;
    user.nickname = self.nickname;
    user.id = self.id;
    
    return user;
}
-(NSString *) description
{
    return [NSString stringWithFormat:@"user name%@ , user mobile:%@" , self.userName , self.mobile ];
}
@end
