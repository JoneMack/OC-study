//
//  MapFindHouseController.h
//  xiangyu
//
//  Created by xubojoy on 16/6/15.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "CustomAnnotationView.h"
#import "MMDrawerController.h"
#import "MapHouse.h"

@interface MapFindHouseController : UIViewController<BMKMapViewDelegate, BMKPoiSearchDelegate,BMKLocationServiceDelegate>
{
    BMKMapView* _mapView;
    BMKPoiSearch* _poisearch;
    int curPage;
    BMKLocationService* _locService;
    
    CLLocationCoordinate2D leftBottomPoint;
    CLLocationCoordinate2D rightBottomPoint;

}
@property (nonatomic , strong) HeaderView *headerView;
@property (nonatomic ,strong) CustomAnnotationView *customAnnotationView;
@property (nonatomic ,strong) MMDrawerController *drawerController;
@property (nonatomic ,strong) MapHouse *mapHouse;
//@property (nonatomic ,strong) NSMutableArray *mapHouseArray;
//@property (nonatomic ,strong) NSMutableDictionary *maphouseDict;
//@property (nonatomic ,strong) NSMutableDictionary *maphouseFinalDict;

@end
