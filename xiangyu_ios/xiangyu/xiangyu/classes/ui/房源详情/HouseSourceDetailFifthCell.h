//
//  HouseSourceDetailFifthCell.h
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import "AroundSearchViewCollectionCell.h"
#import "HouseInfo.h"
@interface HouseSourceDetailFifthCell : UITableViewCell<BMKGeoCodeSearchDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,UICollectionViewDataSource , UICollectionViewDelegate>
{
    BMKMapView* _mapView;
    BMKGeoCodeSearch* _searcher;
    BMKLocationService* _locService;
    BMKPoiSearch *_busSearcher;
}

@property (nonatomic , strong) UICollectionView *aroundSearchView;
@property (nonatomic ,strong) HouseInfo *houseInfo;

@property (nonatomic ,strong) NSMutableArray *searchArray;

- (void)initSearchViewWithHouseInfo:(HouseInfo *)houseInfo;

@end
