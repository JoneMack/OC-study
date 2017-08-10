//
//  MapFindHouseController.m
//  xiangyu
//
//  Created by xubojoy on 16/6/15.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "MapFindHouseController.h"
#import "AppDelegate.h"
#import "MapFindCommunityListController.h"
#import "MapHouseSearchStore.h"
#import "MapHouseDetailListViewController.h"
@interface MapFindHouseController ()

@end

@implementation MapFindHouseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self initHeaderView];
    [self initBaiDuMapView];
    [self initMapViewWithPage:curPage];
}

- (void)initHeaderView{
    self.headerView = [[HeaderView alloc] initWithTitle:@"地图找房" navigationController:self.navigationController];
    self.headerView.frame = CGRectMake(0, 0, screen_width, 64);
    [self.view addSubview:self.headerView];
}

- (void)initBaiDuMapView{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height+splite_line_height, screen_width, screen_height)];
    // 设置地图级别
    [_mapView setZoomLevel:16];
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.showMapScaleBar = YES;
    _mapView.mapScaleBarPosition = CGPointMake(20, self.view.frame.size.height - 100);
    [self.view addSubview:_mapView];
    
    NSLog(@"进入普通定位态");
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    //当前屏幕中心点的经纬度
//    CGFloat centerLongitude = _mapView.region.center.longitude;
//    CGFloat centerLatitude = _mapView.region.center.latitude;
//    NSLog(@"\n 中心   %f,%f",centerLongitude,centerLatitude);
    
//    CGFloat centerWidth = _mapView.visibleMapRect.size.width;
//    
//    CGFloat centerHeight =_mapView.visibleMapRect.size.height;
//    
//    
//    //当前屏幕显示范围的经纬度
//    CLLocationDegrees pointssLongitudeDelta = _mapView.region.span.longitudeDelta;
//    CLLocationDegrees pointssLatitudeDelta = _mapView.region.span.latitudeDelta;
//    //左上角
//    CGFloat leftUpLong = centerLongitude - pointssLongitudeDelta/2.0;
//    CGFloat leftUpLati = centerLatitude - pointssLatitudeDelta/2.0;
//    //右上角
//    CGFloat rightUpLong = centerLongitude + pointssLongitudeDelta/2.0;
//    CGFloat rightUpLati = centerLatitude - pointssLatitudeDelta/2.0;
//    //左下角
//    CGFloat leftDownLong = centerLongitude - pointssLongitudeDelta/2.0;
//    CGFloat leftDownlati = centerLatitude + pointssLatitudeDelta/2.0;
//    //右下角
//    CGFloat rightDownLong = centerLongitude + pointssLongitudeDelta/2.0;
//    CGFloat rightDownLati = centerLatitude + pointssLatitudeDelta/2.0;
//    NSLog(@"\n 左上   %f,%f---------\n 右上   %f,%f-------\n 左下  %f,%f----- \n 右下  %f,%f----------%f,%f",leftUpLong,leftUpLati,rightUpLong,rightUpLati,leftDownLong,leftDownlati,rightDownLong,rightDownLati,centerWidth,centerHeight);
    
    [self initMapViewWithPage:curPage];
}

//加载完毕先调取一次检索
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
    leftBottomPoint = [_mapView convertPoint:CGPointMake(0,_mapView.frame.size.height) toCoordinateFromView:mapView];  // //西南角（左下角） 屏幕坐标转地理经纬度
    rightBottomPoint = [_mapView convertPoint:CGPointMake(_mapView.frame.size.width,0) toCoordinateFromView:mapView];  //东南角（右下角）同上
//    [self initMapViewWithPage:curPage];
    
}
- (void)initMapViewWithPage:(int)currentPageNo{
    NSLog(@">>>>>>>>>>>currentPageNo>>>>>>>>>%d",currentPageNo);
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    
    BMKBoundSearchOption*boundSearchOption = [[BMKBoundSearchOption alloc]init];
    boundSearchOption.pageIndex = 0;
    boundSearchOption.pageCapacity = 10;
    boundSearchOption.keyword = @"小区";
    boundSearchOption.leftBottom =leftBottomPoint;
    boundSearchOption.rightTop =rightBottomPoint;
    
    BOOL flag = [_poisearch poiSearchInbounds:boundSearchOption];
    if(flag)
    {
        NSLog(@"范围内检索发送成功");
    }
    else
    {
        NSLog(@"范围内检索发送失败");
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    self.drawerController = [(AppDelegate*)[UIApplication sharedApplication].delegate drawerController];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _poisearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}
#pragma mark -
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        //在此处理正常结果
//        NSMutableArray *nameArray = [NSMutableArray new];
        for (int i = 0; i < result.poiInfoList.count; i++)
        {
        
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            NSLog(@">>>>>>>>>poi.name>>>>>>>>>>%@",poi.name);
            
//            NSString *poiStr = [NSString stringWithFormat:@"%f,%f",poi.pt.latitude,poi.pt.longitude];
//            NSLog(@">>>>>>>>>poi.name>>>%@>>>%f>>>>%f",poiStr,poi.pt.latitude,poi.pt.longitude);

            [self addAnimatedAnnotationWithName:poi.name withAddress:poi.pt];
//            if ([NSStringUtils isNotBlank:poi.name]) {
//                [nameArray addObject:poi.name];
//            }
        }
        
//        NSString *namesStr = [nameArray componentsJoinedByString:@","];
//        NSLog(@">>>>>>>>>namesStrnamesStrnamesStr>>>>>>>>>>%@",namesStr);
//        [self loadDataByNames:namesStr];
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}
// 添加动画Annotation
- (void)addAnimatedAnnotationWithName:(NSString *)name withAddress:(CLLocationCoordinate2D)coor {
        [MapHouseSearchStore getHouseMapSearchByprojectnames:^(NSDictionary *dict, NSError *err) {
            NSLog(@">>>>请求返回的房源>>>>>>>>%@",dict);
            if (dict != nil) {
                NSMutableArray *animatedAnnotationArray = [NSMutableArray new];
                for (NSDictionary *houseDic in dict.allValues) {
                    self.mapHouse = [[MapHouse alloc] initWithDictionary:houseDic error:nil];
                    if (self.mapHouse != nil) {
//                        CLLocationCoordinate2D coordin = CLLocationCoordinate2DMake([self.mapHouse.y doubleValue],[self.mapHouse.x doubleValue]);
//                        if (self.mapHouse.forRentCount !=0) {
                            BMKPointAnnotation*animatedAnnotation = [[BMKPointAnnotation alloc]init];
                            animatedAnnotation.coordinate = coor;
                            animatedAnnotation.title = [NSString stringWithFormat:@"%@/%d套",name,self.mapHouse.forRentCount];
                            //                        [_mapView addAnnotation:animatedAnnotation];
                            [animatedAnnotationArray addObject:animatedAnnotation];
//                        }
                       
                    }
                }
                [_mapView addAnnotations:animatedAnnotationArray];
            }
        } projectnames:name];
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
//    NSLog(@"点击标注------------%@",view.annotation.title);
//    MapFindCommunityListController *vc = [[MapFindCommunityListController alloc] initWithTitle:view.annotation.title];
//    [self.navigationController pushViewController:vc animated:YES];
    
    NSArray *array = [view.annotation.title componentsSeparatedByString:@"/"];
//    NSString *countStr = array[1];
    MapHouseDetailListViewController *areaFindHousesViewController = [[MapHouseDetailListViewController alloc] init];
    areaFindHousesViewController.searchStr = array[0];
    [self.navigationController pushViewController:areaFindHousesViewController animated:YES];
    
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}


#pragma mark implement BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param mapView 地图View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        //                ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = NO;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    NSLog(@"++++++++++++++++++%@",annotation.title);
    NSArray *array = [annotation.title componentsSeparatedByString:@"/"];
    NSString *countStr = array[1];
    int count = [[countStr substringToIndex:countStr.length-1] intValue];
    NSLog(@"++++++++++++count++++++%d",count);
//    if (count != 0) {
//        
//    }
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:22]};
    CGSize retSize = [annotation.title boundingRectWithSize:CGSizeMake(screen_width, 0)
                                                    options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                                 attributes:attribute
                                                    context:nil].size;
    self.customAnnotationView = [[CustomAnnotationView alloc] initWithFrame:CGRectMake(0, 0, retSize.width+20, 50+15) withTitle:annotation.title];
    self.customAnnotationView.backgroundColor = [UIColor clearColor];
    annotationView.image=[self getImageFromView:self.customAnnotationView];
    
    return annotationView;
}

-(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    //当前屏幕中心点的经纬度
//    CGFloat centerLongitude = _mapView.region.center.longitude;
//    CGFloat centerLatitude = _mapView.region.center.latitude;
//    NSLog(@"\n 改变中心   %f,%f",centerLongitude,centerLatitude);
//    CGPoint centerPoint = [_mapView convertCoordinate:_mapView.region.center toPointToView:mapView];
    
    leftBottomPoint = [_mapView convertPoint:CGPointMake(0,_mapView.frame.size.height) toCoordinateFromView:mapView];  // //西南角（左下角） 屏幕坐标转地理经纬度
    rightBottomPoint = [_mapView convertPoint:CGPointMake(_mapView.frame.size.width,0) toCoordinateFromView:mapView];  //东南角（右下角）同上
    [self initMapViewWithPage:curPage];
    
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    //    NSLog(@"heading is %@",userLocation.heading);
    
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
