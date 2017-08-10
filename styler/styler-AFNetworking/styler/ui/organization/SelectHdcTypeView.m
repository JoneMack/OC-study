//
//  SelectHdcTypeView.m
//  styler
//
//  Created by 冯聪智 on 14-9-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define remind_block_view_width           5
#define hdc_type_cell_height              37
#define hdc_type_cell_content_margin_left 15
#define special_offer_list_hdc_types      0
#define default_display_cell_count        6

#import "SelectHdcTypeView.h"
#import "OrganizationFilterView.h"
#import "HdcType.h"
#import "OrganizationFilter.h"

@implementation SelectHdcTypeView


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
        // 初始化默认选项
        _defaultHdcType = [[HdcType alloc] init];
        _defaultHdcType.name = @"全部";
        _defaultHdcType.type = 0;
        
        if (!self.organizationFilter.selectedHdcTypeValue>0) {
            self.organizationFilter.selectedHdcTypeName = self.defaultHdcType.name;
            self.organizationFilter.selectedHdcTypeValue = self.defaultHdcType.type;
        }
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        float selfHeight = window.frame.size.height - navigation_height - organization_filter_menu_height;
        self.frame = CGRectMake(0, 0, screen_width, selfHeight);
        self.hdcTypesTableView = [[UITableView alloc] init];
        CGRect frame = CGRectMake( 0 , 0 , screen_width, hdc_type_cell_height*default_display_cell_count);
        self.hdcTypesTableView.frame = frame;
        self.hdcTypesTableView.dataSource = self;
        self.hdcTypesTableView.delegate = self;
        self.hdcTypesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 不显默认的分隔线
        
        self.backgroundColor = [ColorUtils colorWithHexString:gray_text_color alpha:0.4];
        [self addSubview:self.hdcTypesTableView];
        // 添加手势
        UIGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideThisView)];
        [self addGestureRecognizer:singleRecognizer];
        singleRecognizer.delegate = self;
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![[self.organizationFilter.hdcTypes[0] name] isEqualToString:self.defaultHdcType.name]) {
        NSMutableArray *tempHdcTypes = [self.organizationFilter.hdcTypes mutableCopy];
        [tempHdcTypes insertObject:self.defaultHdcType atIndex:0];
        self.organizationFilter.hdcTypes = [tempHdcTypes copy];
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.organizationFilter.hdcTypes.count; 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *hdcTypesFilter = @"hdcTypesFilter";
    SelectHdcTypeCellView *cell = [tableView dequeueReusableCellWithIdentifier:hdcTypesFilter];
    if (cell == nil) {
        cell = [[SelectHdcTypeCellView alloc] initWithReuseIdentifier:hdcTypesFilter];
    }
    
    // 美发卡类型名
    HdcType *hdcType = self.organizationFilter.hdcTypes[indexPath.row];
    cell.textLabel.text = hdcType.name;
    
    // 处理被选中的状态
    if ([self.organizationFilter.selectedHdcTypeName isEqualToString:cell.textLabel.text]
        ||self.organizationFilter.selectedHdcTypeValue == hdcType.type) {
        [self showSelectedRemindBlock:cell];
    }else{
        [self hideSelectedRemindBlock:cell];
    }
    
    // 处理分隔线
    if ([[[self.organizationFilter.hdcTypes lastObject] name] isEqualToString:cell.textLabel.text]) {
        [cell.separatorLine setHidden:YES];
    }else{
        [cell.separatorLine setHidden:NO];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hdc_type_cell_height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HdcType *hdcType = self.organizationFilter.hdcTypes[indexPath.row];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(hdcTypeSelected:)]) {
        [self.delegate hdcTypeSelected:hdcType];
    }
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self hideSelectedRemindBlock:cell];
    [MobClick event:log_event_name_selected_hdc_type
         attributes:[NSDictionary dictionaryWithObjectsAndKeys:cell.textLabel.text, log_event_name_selected_hdc_type,nil]];
}

- (void) showSelectedRemindBlock:(UITableViewCell *)cell{
    // 渲染之前选中的美发卡类型
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
    ((SelectHdcTypeCellView *)cell).remindView.hidden = NO;
}

-(void) hideSelectedRemindBlock:(UITableViewCell *)cell{
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    ((SelectHdcTypeCellView *)cell).remindView.hidden = YES;
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

@end




@implementation SelectHdcTypeCellView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake( 0 , 0 , screen_width , hdc_type_cell_height);
        self.textLabel.font = [UIFont systemFontOfSize:small_font_size];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.remindView = [[UIView alloc] init];
        CGRect remindViewFrame = CGRectMake(0, 0, remind_block_view_width, hdc_type_cell_height);
        self.remindView.frame = remindViewFrame;
        self.remindView.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
        [self addSubview:self.remindView];
        
        // 城区分隔线
        self.separatorLine = [[UIView alloc] init];
        self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        self.separatorLine.frame = CGRectMake( hdc_type_cell_content_margin_left, self.frame.size.height-0.5 , self.frame.size.width-hdc_type_cell_content_margin_left,  splite_line_height);
        [self addSubview:self.separatorLine];
        
    }
    return self;
    
}

@end
