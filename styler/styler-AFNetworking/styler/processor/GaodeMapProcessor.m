//
//  GaodeMapProcessor.m
//  styler
//
//  Created by System Administrator on 13-7-16.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//


#import "GaodeMapProcessor.h"
#import "LBSUtils.h"

@implementation GaodeMapProcessor

-(void) startLocation{
#if TARGET_OS_IPHONE
    if (IOS8) {
        [UIApplication sharedApplication].idleTimerDisabled = TRUE;
        _locationmanager = [[CLLocationManager alloc] init];
        [_locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
        [_locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        _locationmanager.delegate = self;
    }
#endif
    self.mapView.showsUserLocation = YES;
}

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation
{
    AppStatus *as = [AppStatus sharedInstance];
    CLLocation *currentLocation = userLocation.location;
    if (currentLocation) {
        float distance = [LBSUtils latLngDist:as.lastLng lat1:as.lastLat lon2:userLocation.location.coordinate.longitude lat2:userLocation.location.coordinate.latitude];
        
        self.mapView.showsUserLocation = NO;
        
        if(distance >= 20){
            
            [AppStatus sharedInstance].lastLat = userLocation.location.coordinate.latitude;
            [AppStatus sharedInstance].lastLng = userLocation.location.coordinate.longitude;
            [AppStatus saveAppStatus];
            
            AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
            regeoRequest.searchType = AMapSearchType_ReGeocode;
            regeoRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
            regeoRequest.radius = 2000;
            regeoRequest.requireExtension = YES;
            [self.search AMapReGoecodeSearch: regeoRequest];  // 逆地理位置查询
        }
    }
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation{
    //self.locating = NO;
//    AppStatus *as = [AppStatus sharedInstance];
    if (userLocation != nil) {
//        float distance = [LBSUtils latLngDist:as.lastLng lat1:as.lastLat lon2:userLocation.location.coordinate.longitude lat2:userLocation.location.coordinate.latitude];
//
//        self.mapView.showsUserLocation = NO;
//        
//        if(distance >= 20){
//            
//            [AppStatus sharedInstance].lastLat = userLocation.location.coordinate.latitude;
//            [AppStatus sharedInstance].lastLng = userLocation.location.coordinate.longitude;
//            [AppStatus saveAppStatus];
//            
//            AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
//            regeoRequest.searchType = AMapSearchType_ReGeocode;
//            regeoRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
//            regeoRequest.radius = 2000;
//            regeoRequest.requireExtension = YES;
//            [self.search AMapReGoecodeSearch: regeoRequest];  // 逆地理位置查询
        
//        }
        
    }
}

#pragma mark --逆地理位置的查询结果回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
//    NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
//    NSLog(@"ReGeo: %@", result);
    
    AMapReGeocode *aMapReGeocode = response.regeocode;
    NSArray *pois = aMapReGeocode.pois;
    if (pois.count == 0) {
        return;
    }

    [AppStatus sharedInstance].currentLocation = [NSString stringWithFormat:@"%@%@", [pois[0] address], [pois[0] name]];
    [AppStatus saveAppStatus];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_location_change" object:nil];
//    self.mapView.showsUserLocation = NO;
}

-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
//    self.locating = NO;
    if (error != nil)
		NSLog(@"locate failed: %@", [error localizedDescription]);
	else {
		NSLog(@"locate failed");
	}
}

-(NSString*)keyForMap{
    return gaode_map_key;
}

+ (GaodeMapProcessor *) sharedInstance{
    static GaodeMapProcessor *sharedInstance = nil;
    if(sharedInstance == nil){
        [MAMapServices sharedServices].apiKey = gaode_map_key;
        
        sharedInstance = [[GaodeMapProcessor alloc] init];
        sharedInstance.mapView = [[MAMapView alloc] init];
        sharedInstance.mapView.delegate = sharedInstance;
        sharedInstance.search = [[AMapSearchAPI alloc] initWithSearchKey: gaode_map_key Delegate:sharedInstance];
    }
    return sharedInstance;
}

@end
