//
//  SelectBusinessCircleView.h
//  styler
//
//  Created by 冯聪智 on 14-9-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//
#define select_business_circle_cell_height 37

#import <UIKit/UIKit.h>
@class OrganizationFilter , BusinessCircles;


@protocol SelectBusinessCircleViewDelegate <NSObject>

-(void) businessCircleSelected:(BusinessCircles *)businessCircle;

@end


@interface SelectBusinessCircleView : UIView <UITableViewDelegate , UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *businessCircleView;
@property (nonatomic, strong) OrganizationFilter *organizationFilter;
@property (nonatomic, strong) id<SelectBusinessCircleViewDelegate> delegate;

- (id)initWithOrganizationFilter:(OrganizationFilter *)organizationFilter;

-(void) reloadBusinessCircles;
@end


@interface SelectBusinessCircleCellView : UITableViewCell

@property (nonatomic, strong) UIView *separatorLine;

-(id)initWithBusinessCircleName:(NSString *)businessCircleName reuseIdentifier:(NSString *)reuseIdentifier;

@end