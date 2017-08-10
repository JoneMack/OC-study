//
//  SelectCityDistrict.m
//  styler
//
//  Created by 冯聪智 on 14-9-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define city_district_content_margin_left    15
#define city_district_cell_height 37
#define city_district_width_percent    0.4375
#define remind_block_view_width 5

#import "SelectCityDistrictView.h"
#import "OrganizationFilter.h"
#import "CityDistrict.h"


@implementation SelectCityDistrictView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


-(id) initWithOrganizationFilter:(OrganizationFilter *)organizationFilter{
    self = [super init];
    if (self) {
        self.organizationFilter = organizationFilter;
        _defaultCityDistrict = [[CityDistrict alloc] init];
        _defaultCityDistrict.name = self.organizationFilter.selectedCityDistrictName;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        self.cityDistrictsTableView = [[UITableView alloc] init];
        float cityDistrictViewWidth =screen_width * city_district_width_percent;
        self.cityDistrictsTableView.frame = CGRectMake( 0 , 0 , cityDistrictViewWidth , city_district_cell_height*9);
        self.cityDistrictsTableView.dataSource = self;
        self.cityDistrictsTableView.delegate = self;
        self.cityDistrictsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 不显默认的分隔线
        self.cityDistrictsTableView.userInteractionEnabled = YES;
        
        float selfHeight = window.frame.size.height - navigation_height - 33;
        self.frame = CGRectMake(0, 0, cityDistrictViewWidth, selfHeight);
        self.backgroundColor = [ColorUtils colorWithHexString:gray_text_color alpha:0.4];
        [self addSubview:self.cityDistrictsTableView];

        // 设置边线
        UIView *downSpeliteLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-0.5, 0, splite_line_height, self.cityDistrictsTableView.frame.size.height)];
        downSpeliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [self addSubview:downSpeliteLine];
        
        // 添加手势
        UIGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideThisView)];
        [self addGestureRecognizer:singleRecognizer];
        singleRecognizer.delegate = self;

    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![[self.organizationFilter.allCityDistricts[0] name] isEqualToString:self.defaultCityDistrict.name]) {
        NSMutableArray *tempAllCityDistricts = [self.organizationFilter.allCityDistricts mutableCopy];
        [tempAllCityDistricts insertObject:self.defaultCityDistrict atIndex:0];
        self.organizationFilter.allCityDistricts = tempAllCityDistricts;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.organizationFilter.allCityDistricts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CityDistrict *cityDistrict = self.organizationFilter.allCityDistricts[indexPath.row];
    
    static NSString *cityDistrictFilter = @"cityDistrictFilter";
    SelectCityDistrictCellView *cell = [tableView dequeueReusableCellWithIdentifier:cityDistrictFilter];
    if (cell == nil) {
        cell = [[SelectCityDistrictCellView alloc] initWithCityDistrictName:cityDistrict.name reuseIdentifier:cityDistrictFilter];
    }
    
    cell.textLabel.text = cityDistrict.name;
    
    // 标记上次被选中的城区
    OrganizationFilter *organizationFilter = self.organizationFilter;
    if ([organizationFilter.selectedCityDistrictName isEqualToString:cityDistrict.name]){
        [self showCellRemindView:cell];
        organizationFilter.selectedCityDistrictRowId = indexPath.row;
    }else{
        [self hideCellRemindView:cell];
    }

    // 处理最后一个分隔线
    if ([[[self.organizationFilter.allCityDistricts lastObject] name] isEqualToString:cell.textLabel.text]) {
        [cell.separatorLine setHidden:YES];
    }else{
        [cell.separatorLine setHidden:NO];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return city_district_cell_height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 先处理旧的cell
    OrganizationFilter *organizationFilter = self.organizationFilter;
    if (organizationFilter.selectedCityDistrictRowId >= 0) {
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:organizationFilter.selectedCityDistrictRowId inSection:0];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
        [self hideCellRemindView:oldCell];
        organizationFilter.selectedCityDistrictRowId = -1;
    }
    
    // 显示新选择的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self showCellRemindView:cell];
    
    CityDistrict *cityDistrict = self.organizationFilter.allCityDistricts[indexPath.row];
    
    [MobClick event:log_event_name_selected_city_district
         attributes:[NSDictionary dictionaryWithObjectsAndKeys:cityDistrict.name, log_event_name_selected_city_district,nil]];
    
    if ([self.delegate respondsToSelector:@selector(cityDistrictSelected:)]) {
        [self.delegate cityDistrictSelected:cityDistrict];
    }
}

-(void) hideThisView{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(cityDistrictSelected:)]) {
        [self.delegate cityDistrictSelected:nil];
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
    
    OrganizationFilter *organizationFilter = self.organizationFilter;
    [organizationFilter.clickedCityDistricts removeLastObject];
}


-(void) showCellRemindView:(UITableViewCell *)cell{
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
    ((SelectCityDistrictCellView *)cell).remindView.hidden = NO;
}

-(void) hideCellRemindView:(UITableViewCell *)cell{
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    ((SelectCityDistrictCellView *)cell).remindView.hidden = YES;

}

@end




@implementation SelectCityDistrictCellView

-(id)initWithCityDistrictName:(NSString *)cityDistrictName reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake( 0 , 0 , screen_width*city_district_width_percent , city_district_cell_height);
        
        self.textLabel.text = cityDistrictName;
        self.textLabel.font = [UIFont systemFontOfSize:small_font_size];
        [self setBackgroundColor:[ColorUtils colorWithHexString:light_gray_color]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.remindView = [[UIView alloc] init];
        CGRect remindViewFrame = CGRectMake(0, 0, remind_block_view_width, city_district_cell_height);
        self.remindView.frame = remindViewFrame;
        self.remindView.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
        [self addSubview:self.remindView];
        
        // 城区分隔线
        self.separatorLine = [[UIView alloc] init];
        self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        self.separatorLine.frame = CGRectMake( city_district_content_margin_left, self.frame.size.height-0.5 , self.frame.size.width-city_district_content_margin_left,  splite_line_height);
        [self addSubview:self.separatorLine];
    }
    return self;
}

@end
