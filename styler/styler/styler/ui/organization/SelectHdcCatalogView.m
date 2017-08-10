//
//  SelectHdcCatalogView.m
//  styler
//
//  Created by 冯聪智 on 14/11/3.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define hdc_catalog_content_margin_left    15
#define hdc_catalog_cell_height 37
#define hdc_catalog_width_percent    0.4375
#define remind_block_view_width 5

#import "SelectHdcCatalogView.h"

@implementation SelectHdcCatalogView

-(id) initWithOrganizationFilter:(OrganizationFilter *)organizationFilter{
    self = [super init];
    if (self) {
        self.organizationFilter = organizationFilter;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        float cityDistrictViewWidth =screen_width * hdc_catalog_width_percent;
        self.hdcCatalogsTableView = [[UITableView alloc] init];
        self.hdcCatalogsTableView.frame = CGRectMake( 0 , 0 , cityDistrictViewWidth , hdc_catalog_cell_height*6);
        self.hdcCatalogsTableView.dataSource = self;
        self.hdcCatalogsTableView.delegate = self;
        self.hdcCatalogsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;  // 不显默认的分隔线
        self.hdcCatalogsTableView.userInteractionEnabled = YES;
        [self.hdcCatalogsTableView setBackgroundColor:[ColorUtils colorWithHexString:light_gray_color]];
        
        float selfHeight = window.frame.size.height - navigation_height - 33;
        self.frame = CGRectMake(0, 0, cityDistrictViewWidth, selfHeight);
        [self setBackgroundColor:[ColorUtils colorWithHexString:gray_text_color alpha:0.4]];
        [self addSubview:self.hdcCatalogsTableView];
        
        // 设置边线
        UIView *downSpeliteLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width-0.5, 0, splite_line_height, self.hdcCatalogsTableView.frame.size.height)];
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
    if (![[self.organizationFilter.hdcCatalogs[0] name] isEqualToString:@"全部"]) {
        NSMutableArray *tempHdcCatalogs = [self.organizationFilter.hdcCatalogs mutableCopy];
        self.defaultHdcCatalog = [[HdcCatalog alloc] init];
        self.defaultHdcCatalog.name = @"全部";
        [tempHdcCatalogs insertObject:self.defaultHdcCatalog atIndex:0];
        self.organizationFilter.hdcCatalogs = tempHdcCatalogs;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.organizationFilter.hdcCatalogs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *hdcCatalogsFilter = @"hdcCatalogsFilter";
    SelectHdcCatalogCellView *cell = [tableView dequeueReusableCellWithIdentifier:hdcCatalogsFilter];
    if (cell == nil) {
        cell = [[SelectHdcCatalogCellView alloc] initWithReuseIdentifier:hdcCatalogsFilter];
    }
    // 美发卡类型名
    HdcCatalog *hdcCatalog = self.organizationFilter.hdcCatalogs[indexPath.row];
    cell.textLabel.text = hdcCatalog.name;
    
    // 处理被选中的状态
    if ([self.organizationFilter.selectedHdcCatalogName isEqualToString:cell.textLabel.text]) {
        [self showSelectedRemindBlock:cell];
    }else{
        [self hideSelectedRemindBlock:cell];
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return hdc_catalog_cell_height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HdcCatalog *hdcCatalog = self.organizationFilter.hdcCatalogs[indexPath.row];
    
    // 先处理旧的cell
    NSIndexPath *oldIndexPath = [self getLastIndexPath];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    [self hideSelectedRemindBlock:oldCell];
    
    // 显示新选择的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self showSelectedRemindBlock:cell];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(hdcCatalogSelected:)]) {
        [self.delegate hdcCatalogSelected:hdcCatalog];
    }
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self hideSelectedRemindBlock:cell];
}

- (void) showSelectedRemindBlock:(UITableViewCell *)cell{
    // 渲染之前选中的美发卡类型
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
    ((SelectHdcCatalogCellView *)cell).remindView.hidden = NO;
}

-(void) hideSelectedRemindBlock:(UITableViewCell *)cell{
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    ((SelectHdcCatalogCellView *)cell).remindView.hidden = YES;
}

-(NSIndexPath *) getLastIndexPath{
    NSArray *hdcCatalogs = self.organizationFilter.hdcCatalogs;
    NSString *filterName = self.organizationFilter.clickedHdcCatalog != nil
                            ? self.organizationFilter.clickedHdcCatalog.name : self.organizationFilter.selectedHdcCatalogName ;
    
    for (int i=0 ; i< self.organizationFilter.hdcCatalogs.count ; i++) {
        if ([[hdcCatalogs[i] name] isEqualToString:filterName]) {
            return [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    
    return nil;
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
    if ([self.delegate respondsToSelector:@selector(hdcCatalogSelected:)]) {
        [self.delegate hdcCatalogSelected:nil];
    }
}

@end



@implementation SelectHdcCatalogCellView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake( 0 , 0 , screen_width*hdc_catalog_width_percent , hdc_catalog_cell_height);
        [self.textLabel setFont:[UIFont systemFontOfSize:small_font_size]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[ColorUtils colorWithHexString:light_gray_color]];
        
        CGRect remindViewFrame = CGRectMake(0, 0, remind_block_view_width, hdc_catalog_cell_height);
        self.remindView = [[UIView alloc] init];
        self.remindView.frame = remindViewFrame;
        self.remindView.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
        [self addSubview:self.remindView];
        
        // 城区分隔线
        self.separatorLine = [[UIView alloc] init];
        self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        self.separatorLine.frame = CGRectMake( hdc_catalog_content_margin_left                      ,  self.frame.size.height-0.5 ,
                                               self.frame.size.width-hdc_catalog_content_margin_left,  splite_line_height);
        [self addSubview:self.separatorLine];
    }
    return self;
}

@end


