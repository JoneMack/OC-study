//
//  SelectSpecialOfferListOrderTypeView.h
//  styler
//
//  Created by 冯聪智 on 14-9-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrganizationFilter;

@interface SpecialOfferListOrderType : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *value;

-(instancetype)initWithNameAndValue:(NSString *)name value:(NSString *)value;

@end


@protocol SpecialOfferListOrderTypeDelegate <NSObject>

@optional
-(void) specialOfferListOrderTypeSelectedOrderType:(SpecialOfferListOrderType *)orderType;

@end



@interface SelectSpecialOfferListOrderTypeView : UIView <UITableViewDataSource , UITableViewDelegate , UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *orderTypeView;
@property (nonatomic, strong) OrganizationFilter *organizationFilter;
@property (nonatomic, strong) id<SpecialOfferListOrderTypeDelegate> delegate;

-(id) initWithOrganizationFilter:(OrganizationFilter *)organizationFilter;

@end




@interface SelectSpecialOfferListOrderTypeCellView : UITableViewCell

@property (nonatomic, strong) UIView *remindView;
@property (nonatomic, strong) UIView *separatorLine;


-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end