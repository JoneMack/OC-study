//
//  SelectBusinessCircleView.m
//  styler
//
//  Created by 冯聪智 on 14-9-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define remind_block_view_width             5
#define business_cicle_width_percent        0.5625
#define business_circle_cell_height         37
#define business_circle_content_margin_left 15
#define special_offer_list_business_circle  1

#import "SelectBusinessCircleView.h"
#import "OrganizationFilter.h"
#import "BusinessCircles.h"

@implementation SelectBusinessCircleView
{
    NSArray *currentBusinessCircles;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithOrganizationFilter:(OrganizationFilter *)organizationFilter{
    self = [super init];
    if (self) {
        self.organizationFilter = organizationFilter;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        float selfHeight = window.frame.size.height - navigation_height - 33;
        self.businessCircleView = [[UITableView alloc] init];
        float businessCirclesViewWidth = screen_width * business_cicle_width_percent;
        CGRect frame = CGRectMake( 0 , 0, businessCirclesViewWidth , select_business_circle_cell_height*9);
        self.businessCircleView.frame = frame;
        self.businessCircleView.dataSource = self;
        self.businessCircleView.delegate = self;
        self.frame = CGRectMake(0, 0, self.businessCircleView.frame.size.width, selfHeight);
        self.backgroundColor = [ColorUtils colorWithHexString:gray_text_color alpha:0.4];
        [self addSubview:self.businessCircleView];
        
        // 添加手势
        UIGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideThisView)];
        [self addGestureRecognizer:singleRecognizer];
        singleRecognizer.delegate = self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSString *cityDistrictName = self.organizationFilter.selectedCityDistrictName;
    if (self.organizationFilter.clickedCityDistricts!= nil && self.organizationFilter.clickedCityDistricts.count>0) {
        cityDistrictName = [self.organizationFilter.clickedCityDistricts lastObject];
    }
    
    currentBusinessCircles = [self.organizationFilter getBusinessCirclesByCityDistrictName:cityDistrictName];
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return currentBusinessCircles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BusinessCircles *businessCircle = currentBusinessCircles[indexPath.row];
    static NSString *businessCircleFilter = @"businessCircleFilter";
    SelectBusinessCircleCellView *cell = [tableView dequeueReusableCellWithIdentifier:businessCircleFilter];
    if (cell == nil) {
        cell = [[SelectBusinessCircleCellView alloc] initWithBusinessCircleName:UITableViewCellStyleDefault reuseIdentifier:businessCircleFilter];
    }
    cell.textLabel.text = businessCircle.name;
    
    if ([self.organizationFilter.selectedBusinessCircleName isEqualToString:businessCircle.name]
        || self.organizationFilter.selectedBusinessCircleId == businessCircle.id) {
        [self showCellRemindView:cell];
    }else{
        [self hideCellRemindView:cell];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return select_business_circle_cell_height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 获取cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
    
    BusinessCircles *businessCircle = currentBusinessCircles[indexPath.row];
    
    [MobClick event:log_event_name_selected_business_circles
         attributes:[NSDictionary dictionaryWithObjectsAndKeys:businessCircle.name, log_event_name_selected_business_circles,nil]];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(businessCircleSelected:)]) {
        [self.delegate businessCircleSelected:businessCircle];
    }
}

-(void) hideThisView{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(businessCircleSelected:)]) {
        [self.delegate businessCircleSelected:nil];
    }
}

/**
 * 阻止事件传递。
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchLocation = [touch locationInView:self];
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(view.frame, touchLocation)){
            return NO;
        }
    }
    return YES;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self hideCellRemindView:cell];
}


-(void) showCellRemindView:(UITableViewCell *)cell{
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
}

-(void) hideCellRemindView:(UITableViewCell *)cell{
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:black_text_color]];
}

-(void) reloadBusinessCircles{
    NSString *selectedCityDistictName = [self.organizationFilter.clickedCityDistricts lastObject];
    currentBusinessCircles = [self.organizationFilter getBusinessCirclesByCityDistrictName:selectedCityDistictName];
    [self.businessCircleView reloadData];
}

@end


@implementation SelectBusinessCircleCellView


-(id)initWithBusinessCircleName:(NSString *)businessCircleName reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake( 0 , 0 , screen_width*business_cicle_width_percent , business_circle_cell_height);
        self.textLabel.font = [UIFont systemFontOfSize:small_font_size];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.text = businessCircleName;
        self.textLabel.font = [UIFont systemFontOfSize:small_font_size];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 城区分隔线
        self.separatorLine = [[UIView alloc] init];
        self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        self.separatorLine.frame = CGRectMake( business_circle_content_margin_left, self.frame.size.height-0.5 , self.frame.size.width-business_circle_content_margin_left,  splite_line_height);
        [self addSubview:self.separatorLine];
    }
    return self;
    
}

@end
