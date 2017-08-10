//
//  Position.m
//  jingduoduo
//
//  Created by mac on 15/2/13.
//  Copyright (c) 2015年 han. All rights reserved.
//

#import "Position.h"

@implementation Position
-(id)initMyPosition{
    if (self=[super init]) {
        self=[[Position alloc]init];
        
        if([CLLocationManager locationServicesEnabled]) {
            self.location=[[CLLocationManager alloc]init];
            self.geocoder=[[CLGeocoder alloc]init];
            self.location.delegate = self;
            self.ip=[self getIPAddress];
        }else {
            //提示用户无法进行定位操作
        }
        [self.location startUpdatingLocation];
    }
    
    return self;
}
- (NSString *)getIPAddress
{
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

//#pragma mark ios6.0以下
//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation {
//    
//    //latitude和lontitude均为NSString型变量
//    //纬度
//    self.latitude = [NSString  stringWithFormat:@"%.4f", newLocation.coordinate.latitude];
//    
//    //经度
//    self.longitude = [NSString stringWithFormat:@"%.4f",                           newLocation.coordinate.longitude];
//    
//}

#pragma mark ios6.0以上
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    self.latitude =  [NSString stringWithFormat:@"%f",coor.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",coor.longitude];
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemark,NSError *error)
     {
         CLPlacemark *mark=[placemark objectAtIndex:0];
         
         self.address=[NSString stringWithFormat:@"%@",mark.name];//获取subtitle的信息
        
     } ];
    
    
    [self.location stopUpdatingLocation];
    
}
#pragma mark 获取失败位置
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}
#pragma mark 




@end
