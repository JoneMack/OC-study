//
//  Position.h
//  jingduoduo
//
//  Created by mac on 15/2/13.
//  Copyright (c) 2015年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
@interface Position : NSObject<CLLocationManagerDelegate>
@property(nonatomic,strong)NSString * ip;
@property(nonatomic,strong)NSString * address;
@property(nonatomic,strong)CLLocationManager * location;
@property(nonatomic,strong)NSString * latitude; //纬度
@property(nonatomic,strong)NSString * longitude;////经度
@property(nonatomic,strong)CLGeocoder *geocoder;
-(id)initMyPosition;
@end
