//
//  Brand.h
//  styler
//
//  Created by System Administrator on 14-2-14.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Organization.h"

@protocol Brand
@end

@interface Brand : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, strong) NSArray<Organization, Optional> *organizations;
@property int stylistCount;

-(void) clearNoStylistOrganization;

@end
