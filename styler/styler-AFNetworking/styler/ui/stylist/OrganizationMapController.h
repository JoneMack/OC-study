//
//  OrganizationMapController.h
//  styler
//
//  Created by System Administrator on 13-5-13.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

#import "Organization.h"
#import "Stylist.h"
#import "HeaderView.h"
#import "Organization.h"

@interface OrganizationMapController : UIViewController <MAMapViewDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) Organization *organization;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, retain) MAPointAnnotation *organizationAnno;
@property (nonatomic, retain) MAPointAnnotation *myAnno;
@property (strong, nonatomic) HeaderView *header;

- (IBAction)viewRoute:(id)sender;
-(id)initWithOrganization:(Organization *)organization;

@end
