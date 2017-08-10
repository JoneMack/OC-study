//
//  SelectHdcCatalogView.h
//  styler
//
//  Created by 冯聪智 on 14/11/3.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationFilter.h"
#import "HdcCatalog.h"

@protocol SelectHdcCatalogViewDelegate <NSObject>

@optional
-(void) hdcCatalogSelected:(HdcCatalog *)hdcCatalog;

@end

@interface SelectHdcCatalogView : UIView <UITableViewDataSource , UITableViewDelegate , UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *hdcCatalogsTableView;
@property (nonatomic, strong) OrganizationFilter *organizationFilter;
@property (nonatomic, strong) id<SelectHdcCatalogViewDelegate> delegate;
@property (nonatomic, strong) HdcCatalog *defaultHdcCatalog;

-(id) initWithOrganizationFilter:(OrganizationFilter *)organizationFilter;

@end


@interface SelectHdcCatalogCellView : UITableViewCell

@property (nonatomic, strong) UIView *remindView;
@property (nonatomic, strong) UIView *separatorLine;


-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end