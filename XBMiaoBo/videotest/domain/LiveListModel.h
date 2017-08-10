//
//  LiveListModel.h
//  videotest
//
//  Created by xubojoy on 16/9/12.
//  Copyright © 2016年 xubojoy. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol LiveListModel
@end
@interface LiveListModel : JSONModel
@property (nonatomic ,assign) int allnum;
@property (nonatomic ,strong) NSString<Optional> *bigpic;
@property (nonatomic ,strong) NSString<Optional> *familyName;
@property (nonatomic ,strong) NSString<Optional> *flv;
@property (nonatomic ,assign) int gender;
@property (nonatomic ,strong) NSString<Optional> *gps;
@property (nonatomic ,assign) int grade;
@property (nonatomic ,assign) int level;
@property (nonatomic ,strong) NSString<Optional> *myname;
@property (nonatomic ,assign) int roomid;
@property (nonatomic ,assign) int serverid;
@property (nonatomic ,strong) NSString<Optional> *signatures;
@property (nonatomic ,strong) NSString<Optional> *smallpic;
@property (nonatomic ,assign) int starlevel;
@property (nonatomic ,strong) NSString *userId;
@property (nonatomic ,assign) int useridx;


@end
