//
//  SelectHdcTypeView.m
//  styler
//
//  Created by 冯聪智 on 14-9-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define hdc_type_cell_height              37
#define hdc_type_cell_content_margin_left 15
#define special_offer_list_hdc_types      0
#define default_display_cell_count        6

#import "SelectHdcTypeView.h"
#import "OrganizationFilterView.h"
#import "HdcType.h"
#import "OrganizationFilter.h"

@implementation SelectHdcTypeView
{
    NSArray *currentHdcTypes;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithOrganizationFilter:(OrganizationFilter *)organizationFilter
{
    if (self= [super init]) {
        self.organizationFilter = organizationFilter;
        
        CGRect frame = CGRectMake( 0 , 0 , screen_width, hdc_type_cell_height*default_display_cell_count);
        self.hdcTypesTableView = [[UITableView alloc] init];
        self.hdcTypesTableView.frame = frame;
        self.hdcTypesTableView.dataSource = self;
        self.hdcTypesTableView.delegate = self;
        self.hdcTypesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 不显默认的分隔线
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        float selfHeight = window.frame.size.height - navigation_height - organization_filter_menu_height;
        
        [self setFrame:CGRectMake(0, 0, screen_width, selfHeight)];
        [self setBackgroundColor:[ColorUtils colorWithHexString:gray_text_color alpha:0.4]];
        [self addSubview:self.hdcTypesTableView];
        
        // 添加手势
        UIGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideThisView)];
        [self addGestureRecognizer:singleRecognizer];
        singleRecognizer.delegate = self;
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (currentHdcTypes == nil || self.organizationFilter.clickedHdcCatalog == nil) {
        currentHdcTypes = [self.organizationFilter getHdcTypesByHdcCatalogName:self.organizationFilter.selectedHdcCatalogName];
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return currentHdcTypes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *hdcTypesFilter = @"hdcTypesFilter";
    SelectHdcTypeCellView *cell = [tableView dequeueReusableCellWithIdentifier:hdcTypesFilter];
    if (cell == nil) {
        cell = [[SelectHdcTypeCellView alloc] initWithReuseIdentifier:hdcTypesFilter];
    }
    
    HdcType *hdcType = currentHdcTypes[indexPath.row];
    cell.textLabel.text = hdcType.name;
    
    if ([self.organizationFilter.selectedHdcTypeName isEqualToString:cell.textLabel.text]) {
        [self showSelectedRemindBlock:cell];
    }else{
        [self hideSelectedRemindBlock:cell];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hdc_type_cell_height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HdcType *hdcType = currentHdcTypes[indexPath.row];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(hdcTypeSelected:)]) {
        [self.delegate hdcTypeSelected:hdcType];
    }
    
    [MobClick event:log_event_name_selected_hdc_type
         attributes:[NSDictionary dictionaryWithObjectsAndKeys:hdcType.name, log_event_name_selected_hdc_type, nil]];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self hideSelectedRemindBlock:cell];
    
}

- (void) showSelectedRemindBlock:(UITableViewCell *)cell{
    // 渲染之前选中的美发卡类型
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
}

-(void) hideSelectedRemindBlock:(UITableViewCell *)cell{
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:black_text_color]];
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

-(void) hideThisView{
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(hdcTypeSelected:)]) {
        [self.delegate hdcTypeSelected:nil];
    }
}


-(void) reloadHdcTypes{
    currentHdcTypes = self.organizationFilter.clickedHdcCatalog.hdcTypes;
    [self.hdcTypesTableView reloadData];
}

@end




@implementation SelectHdcTypeCellView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake( 0 , 0 , screen_width , hdc_type_cell_height);
        self.textLabel.font = [UIFont systemFontOfSize:small_font_size];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 城区分隔线
        self.separatorLine = [[UIView alloc] init];
        self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        self.separatorLine.frame = CGRectMake( hdc_type_cell_content_margin_left, self.frame.size.height-0.5 , self.frame.size.width-hdc_type_cell_content_margin_left,  splite_line_height);
        [self addSubview:self.separatorLine];
        
    }
    return self;
    
}

@end
