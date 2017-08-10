//
//  BaiDuMapProcessor.m
//  xiangyu
//
//  Created by xubojoy on 16/6/22.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "BaiDuMapProcessor.h"

@implementation BaiDuMapProcessor

-(void) startLocation{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.distanceFilter = 2000;
    //启动LocationService
    [_locService startUserLocationService];
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [AppStatus sharedInstance].lastLat = userLocation.location.coordinate.latitude;
    [AppStatus sharedInstance].lastLng = userLocation.location.coordinate.longitude;
    [AppStatus saveAppStatus];
    
    NSLog(@"danwian lat %f,long %f",[AppStatus sharedInstance].lastLat,[AppStatus sharedInstance].lastLng);
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil && [placemarks count] > 0) {
            //这时的placemarks数组里面只有一个元素
            CLPlacemark * placemark = [placemarks firstObject];
            NSDictionary *dictionary = [placemark addressDictionary];
            
            NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@",dictionary[@"City"]];
            [AppStatus sharedInstance].cityName = mutableString;
            [AppStatus saveAppStatus];
            NSLog(@">>>>>>>>>>>保存的省份>>>>>%@",[AppStatus sharedInstance].cityName);
        }
    }];
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[AppStatus sharedInstance].lastLat, [AppStatus sharedInstance].lastLng};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
    }
    else
    {
      NSLog(@"反geo检索发送失败");
    }
    
    if(userLocation.location.coordinate.latitude != 0 && userLocation.location.coordinate.longitude != 0 ){
        [[NSNotificationCenter defaultCenter] postNotificationName:notification_name_user_poi_has_update object:nil];
    }
    
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      //在此处理正常结果
      NSLog(@"处理正常结果--------->%@",result.address);
      [AppStatus sharedInstance].currentLocation = result.address;
      NSLog(@">>>>>>>>>>>当前地址>>>>>>>>>>%@",[AppStatus sharedInstance].currentLocation );
      [AppStatus saveAppStatus];
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}

+ (BaiDuMapProcessor *) sharedInstance{
    static BaiDuMapProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[BaiDuMapProcessor alloc] init];
    }
    return sharedInstance;
}

@end
