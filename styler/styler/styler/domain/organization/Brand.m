//
//  Brand.m
//  styler
//
//  Created by System Administrator on 14-2-14.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "Brand.h"

@implementation Brand

-(void) clearNoStylistOrganization{
    NSMutableArray *orgs = [[NSMutableArray alloc] init];
    if (self.organizations == nil || self.organizations.count == 0) {
        return ;
    }
    for(Organization *org in self.organizations){
        if(org.expertCount > 0){
            [orgs addObject:org];
        }
    }
    self.organizations = (NSArray<Organization, Optional>*)orgs;
}

@end
