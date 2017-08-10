//
//  OrganizationMapController.m
//  styler
//
//  Created by System Administrator on 13-5-13.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import "OrganizationMapController.h"
#import "Toast+UIView.h"
#import "UIViewController+Custom.h"

@interface OrganizationMapController ()

@end

@implementation OrganizationMapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithOrganization:(Organization *)organization
{
    self = [self init];
    self.organization = organization;
    return self;
}

-(void) initHeader:(NSString *)title{
    self.header = [[HeaderView alloc]initWithTitle:nil navigationController:self.navigationController];
    self.header.title.font = [UIFont systemFontOfSize:big_font_size];
    self.header.title.numberOfLines = 0;
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(272, self.header.frame.size.height - (navigation_height -30)/2 - 30, 45, 30);
    [btn setTitle:@"导航" forState:UIControlStateNormal];
    [btn setTitleColor:[ColorUtils colorWithHexString:black_text_color] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(viewRoute:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = [ColorUtils colorWithHexString:splite_line_color].CGColor;
    [self.header addSubview:btn];
    [self.view addSubview:self.header];
}

-(void)initMapView
{
    CGRect mapViewFrame = CGRectMake(0, self.header.frame.size.height + splite_line_height, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-self.header.frame.size.height);
    self.mapView = [[MAMapView alloc] initWithFrame:mapViewFrame];
    self.mapView.delegate = self;
    
    //self.mapView.showsUserLocation = YES;
    self.mapView.mapType = MAMapTypeStandard;
    NSMutableArray *annotations = [NSMutableArray array];
    
    NSArray *poi = [self.organization.poi componentsSeparatedByString:@","];
    
    CLLocationCoordinate2D coordinate;
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *lat = [f numberFromString:[poi objectAtIndex:0]];
    NSNumber *lng = [f numberFromString:[poi objectAtIndex:1]];
    coordinate.latitude = lat.floatValue;
    coordinate.longitude = lng.floatValue;
    
    self.organizationAnno = [[MAPointAnnotation alloc] init];
    self.organizationAnno.coordinate = coordinate;
    self.organizationAnno.title  = self.organization.name;
    self.organizationAnno.subtitle = self.organization.poiAddress;
    [annotations insertObject:self.organizationAnno atIndex:0];
    
    AppStatus *as = [AppStatus sharedInstance];
    if (as.lastLat > 0 && as.lastLng > 0) {
        CLLocationCoordinate2D myCoordinate;
        myCoordinate.latitude = as.lastLat;
        myCoordinate.longitude = as.lastLng;
        
        self.myAnno = [[MAPointAnnotation alloc] init];
        self.myAnno.coordinate = myCoordinate;
        self.myAnno.title  = @"当前位置";
        [annotations insertObject:self.myAnno atIndex:1];
    }
    [self.mapView addAnnotations:annotations];
    
//    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    [self.mapView setRegion:MACoordinateRegionMake(coordinate, MACoordinateSpanMake(0.006, 0.006)) animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightSwipeGestureAndAdaptive];
    [self initHeader:self.organization.address];
    [self initMapView];
}


-(NSString*)keyForMap{
    return gaode_map_key;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
    if ([annotation isKindOfClass:[MAPointAnnotation class]] && annotation == self.organizationAnno){
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil){
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.canShowCallout            = YES;
            annotationView.animatesDrop              = YES;
            annotationView.draggable                 = YES;
            annotationView.pinColor = MAPinAnnotationColorRed;
            [annotationView sizeToFit];
        }else{
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }else if([annotation isKindOfClass:[MAPointAnnotation class]] && annotation == self.myAnno){
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil){
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.canShowCallout            = YES;
            annotationView.animatesDrop              = YES;
            annotationView.draggable                 = YES;
            annotationView.pinColor = MAPinAnnotationColorGreen;
            [annotationView sizeToFit];
        }else{
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    
    return nil;
}




- (IBAction)viewRoute:(id)sender {
    if ([[AppStatus sharedInstance] iosVersion] < 6) {
        NSString *theString = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@", [AppStatus sharedInstance].currentLocation, self.organization.poiAddress];
        theString =  [theString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc] initWithString:theString];
        [[UIApplication sharedApplication] openURL:url];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:nil otherButtonTitles:@"使用苹果自带地图导航", @"使用Google Maps导航",@"使用高德地图导航", nil];
        [actionSheet showInView:self.view];
    }
    [MobClick event:log_event_name_choose_map_navigation];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(![[AppStatus sharedInstance] isConnetInternet]){
        [self.view makeToast:network_unconnect_note duration:2.0 position:[NSValue valueWithCGPoint:self.view.center]];
        return ;
    }
    
    if(buttonIndex == 0){
        NSString *theString = [NSString stringWithFormat:@"maps://maps.google.com/maps?saddr=%@&daddr=%@", [AppStatus sharedInstance].currentLocation, self.organization.poiAddress];
        theString =  [theString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc] initWithString:theString];
        [[UIApplication sharedApplication] openURL:url];
    }else if(buttonIndex == 1){
        NSString* url = [NSString stringWithFormat: @"comgooglemaps://?saddr=%@&daddr=%@",
                         [[AppStatus sharedInstance].currentLocation stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                         [self.organization.poiAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:url]];
    }else if(buttonIndex == 2)
    {
        NSString * url = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=applicationName&backScheme=applicationScheme&lat=%f&lon=%f&dev=1&style=2",self.organization.lat,self.organization.lng];
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:url]];
    }
}

# pragma mark -System method
-(BOOL) shouldAutorotate{
    return NO;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_organization_map;
}


@end
