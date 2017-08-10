//
//  BaiduMapProcessor.h
//  styler
//
//  Created by System Administrator on 13-7-16.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

@interface BaiduMapProcessor : NSObject<BMKSearchDelegate, BMKMapViewDelegate>

@property (nonatomic, retain) BMKMapManager *mapManager;
@property (nonatomic, retain) BMKSearch *bmkSearch;
@property (nonatomic, retain) BMKMapView *mapView;
@property (nonatomic, retain) BMKUserLocation *userLocation;

-(void) startBMKManager;
+ (BaiduMapProcessor *) sharedInstance;

@end
