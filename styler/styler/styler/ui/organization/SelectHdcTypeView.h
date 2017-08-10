//
//  SelectHdcTypeView.h
//  styler
//
//  Created by 冯聪智 on 14-9-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define hdc_type_cell_height     37


#import <UIKit/UIKit.h>

@class OrganizationFilter,HdcType;


@protocol SelectHdcTypeViewDelegate <NSObject>

@optional
-(void) hdcTypeSelected:(HdcType *)hdcType;

@end

@interface SelectHdcTypeView : UIView <UITableViewDataSource ,UITableViewDelegate , UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *hdcTypesTableView;
@property (nonatomic, strong) OrganizationFilter *organizationFilter;
@property (nonatomic, strong) id<SelectHdcTypeViewDelegate> delegate;


-(id) initWithOrganizationFilter:(OrganizationFilter *)organizationFilter;

-(void) reloadHdcTypes;

@end



@interface SelectHdcTypeCellView : UITableViewCell

@property (nonatomic, strong) UIView *separatorLine;


-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end