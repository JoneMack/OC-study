//
//  BaiduMapProcessor.m
//  styler
//
//  Created by System Administrator on 13-7-16.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "BaiduMapProcessor.h"
#import "AppStatus.h"

@implementation BaiduMapProcessor

-(void) startBMKManager{
    self.mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"B1565217AC46F69A999641FF5B06989E845763E9" generalDelegate:nil];
    if(ret){
        NSLog(@"百度地图SDK启动完成");
        self.mapView = [[BMKMapView alloc] init];
        self.mapView.delegate = self;
        self.bmkSearch = [[BMKSearch alloc] init];
        self.bmkSearch.delegate = self;
        
        [self.mapView setShowsUserLocation:YES];
    }
    
    [AppStatus sharedInstance].bmkWorkable = ret;
}

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
		//NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        [AppStatus sharedInstance].lastLat = userLocation.location.coordinate.latitude;
        [AppStatus sharedInstance].lastLng = userLocation.location.coordinate.longitude;
        self.userLocation = userLocation;
        //NSDate *date = [NSDate date];
        //NSCalendar *cal = [NSCalendar currentCalendar];
        //NSDateComponents *components = [cal components:NSSecondCalendarUnit fromDate:date];
        //NSLog(@"current second:%d", [components second]);
        
        [self.bmkSearch reverseGeocode:userLocation.location.coordinate];
	}
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
	if (error != nil)
		NSLog(@"locate failed: %@", [error localizedDescription]);
	else {
		NSLog(@"locate failed");
	}
	
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView{
	NSLog(@"start locate");
}

-(void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error{
    //NSLog(@"当前位置:%@", result.strAddr);
    [AppStatus sharedInstance].currentLocation = result.strAddr;
}

+ (BaiduMapProcessor *) sharedInstance{
    static BaiduMapProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        sharedInstance = [[BaiduMapProcessor alloc] init];
    }
    
    return sharedInstance;
}


@end
