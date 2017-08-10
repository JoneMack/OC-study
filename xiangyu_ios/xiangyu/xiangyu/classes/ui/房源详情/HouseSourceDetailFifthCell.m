//
//  HouseSourceDetailFifthCell.m
//  xiangyu
//
//  Created by 冯聪智 on 16/6/17.
//  Copyright © 2016年 相寓. All rights reserved.
//

#import "HouseSourceDetailFifthCell.h"
static NSString *aroundSearchViewCollectionCellIndetifier = @"aroundSearchViewCollectionCell";
@implementation HouseSourceDetailFifthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.searchArray = [NSMutableArray new];
    
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(general_padding, general_padding, screen_width-general_space, 350/2)];
    // 设置地图级别
    [_mapView setZoomLevel:19];
    _mapView.delegate = self;
    _mapView.isSelectedAnnotationViewFront = YES;
    
    [self.contentView addSubview:_mapView];
    NSLog(@"进入普通定位态");
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    [self initAroundSearchView];
}


- (void)initSearchViewWithHouseInfo:(HouseInfo *)houseInfo{
    self.houseInfo = houseInfo;
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[houseInfo.y doubleValue], [houseInfo.x doubleValue]};
    [_mapView setCenterCoordinate:pt];
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
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

    [_mapView setCenterCoordinate:pt animated:YES];
    
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //      在此处理正常结
        NSLog(@">>>>>>>>>result.address>>>>>>>>>>%@",result.address);
        [self addAnimatedAnnotationWithName:result.address withAddress:result.location];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}

// 添加动画Annotation
- (void)addAnimatedAnnotationWithName:(NSString *)name withAddress:(CLLocationCoordinate2D)coor {
        BMKPointAnnotation*animatedAnnotation = [[BMKPointAnnotation alloc]init];
        animatedAnnotation.coordinate = coor;
        animatedAnnotation.title = name;
        [_mapView addAnnotation:animatedAnnotation];
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
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
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    //    NSLog(@">>>>>>>>>点击了>>>>>>>>>>%@",annotation.title);
    return annotationView;
}



- (void)initAroundSearchView{
    // 推荐专家
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0.0;//item间距(最小值)
    flowLayout.minimumLineSpacing = 0.0;//行间距(最小值)
    self.aroundSearchView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,(350/2)+20, screen_width, 60)
                                               collectionViewLayout:flowLayout];
    self.aroundSearchView.delegate = self;
    self.aroundSearchView.dataSource = self;
    self.aroundSearchView.showsHorizontalScrollIndicator = NO;
    
    self.aroundSearchView.backgroundColor = [UIColor whiteColor];
    
    UINib *nib = [UINib nibWithNibName:@"AroundSearchViewCollectionCell" bundle: nil];
    [self.aroundSearchView registerNib:nib
            forCellWithReuseIdentifier:aroundSearchViewCollectionCellIndetifier];
    
    [self.contentView addSubview:self.aroundSearchView];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
    
}


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AroundSearchViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:aroundSearchViewCollectionCellIndetifier
                                                                           forIndexPath:indexPath];
    if (indexPath.item == 0) {
        [cell renderAroundSearchViewCollectionCellWithIcon:@"icons_05" titleStr:@"交通" contentStr:@"步行10分钟内公交地铁设施2个" showLine:YES];
    }else if (indexPath.item == 1){
        [cell renderAroundSearchViewCollectionCellWithIcon:@"icons_09" titleStr:@"医疗" contentStr:@"5公里范围内医疗机构3个" showLine:YES];
    }else if (indexPath.item == 2){
        [cell renderAroundSearchViewCollectionCellWithIcon:@"icons_12" titleStr:@"教育" contentStr:@"2公里范围内教育机构2个" showLine:YES];
    }else{
        [cell renderAroundSearchViewCollectionCellWithIcon:@"icons_14" titleStr:@"商业" contentStr:@"2公里范围内教育机构2个" showLine:NO];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((screen_width)/4, 60);
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchArray removeAllObjects];
    if (indexPath.item == 0) {
        [self initBusLineSearchResult:@"地铁" radius:8000];
        [self initBusLineSearchResult:@"公交" radius:8000];
    }else if (indexPath.item == 1){
        [self initBusLineSearchResult:@"医疗" radius:2000];
    }else if (indexPath.item == 2){
        [self initBusLineSearchResult:@"教育" radius:2000];
    }else{
        [self initBusLineSearchResult:@"商业" radius:2000];
    }
}

- (void)initBusLineSearchResult:(NSString *)keyword radius:(int)radius{
    [_mapView setZoomLevel:15];
    //初始化检索对象
    
    //发起检索
    _busSearcher =[[BMKPoiSearch alloc] init];
    _busSearcher.delegate = self;
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 5;
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    option.radius = radius;
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[self.houseInfo.y doubleValue], [self.houseInfo.x doubleValue]};
    option.location = pt;
    option.keyword = keyword;
    BOOL flag = [_busSearcher poiSearchNearBy:option];
    
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
        [_mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:_mapView.overlays];
        [_mapView removeOverlays:array];
        [self.searchArray addObjectsFromArray:poiResultList.poiInfoList];
        //在此处理正常结果
        for (int i = 0; i < self.searchArray.count; i++)
        {
            BMKPoiInfo* poi = [self.searchArray objectAtIndex:i];
            NSLog(@">>>>>>>>>poi.name>>>>>>>>>>%@",poi.name);
            [self addAnimatedAnnotationWithName:poi.name withAddress:poi.pt];
        }
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
