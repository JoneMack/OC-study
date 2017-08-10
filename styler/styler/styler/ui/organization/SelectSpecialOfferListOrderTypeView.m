//
//  SelectSpecialOfferListOrderTypeView.m
//  styler
//
//  Created by 冯聪智 on 14-9-24.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#define order_type_cell_height                   37
#define order_type_cell_content_margin_left      15
#define remind_block_view_width                  5
#define special_offer_list_order_type            2
#define remind_view_tag_value                    8475

#import "SelectSpecialOfferListOrderTypeView.h"
#import "OrganizationFilter.h"

@implementation SpecialOfferListOrderType

-(instancetype) initWithNameAndValue:(NSString *)name value:(NSString *)value{
    self = [super init];
    _name = name;
    _value = value;
    return self;
}

@end



@implementation SelectSpecialOfferListOrderTypeView
{
    NSMutableArray *orderTypes;
}

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
        [self initOrderTypes];
        self.organizationFilter = organizationFilter;
        SpecialOfferListOrderType *orderType = orderTypes[0];
        self.organizationFilter.selectedOrderTypeName = orderType.name;
        self.organizationFilter.selectedOrderTypeValue = orderType.value;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        float selfHeight = window.frame.size.height - navigation_height - 33;
        self.frame = CGRectMake(0, 0, screen_width, selfHeight);
        self.orderTypeView = [[UITableView alloc] init];
        CGRect frame = CGRectMake( 0 , 0 , screen_width, order_type_cell_height*orderTypes.count);
        self.orderTypeView.frame = frame;
        self.orderTypeView.dataSource = self;
        self.orderTypeView.delegate = self;
        self.orderTypeView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.orderTypeView.userInteractionEnabled = YES;
        self.backgroundColor = [ColorUtils colorWithHexString:gray_text_color alpha:0.4];
        
        [self addSubview:self.orderTypeView];
        
        // 添加手势
        UIGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideThisView)];
        [self addGestureRecognizer:singleRecognizer];
        singleRecognizer.delegate = self;
        
    }
    return self;
}

-(void) initOrderTypes{
    orderTypes = [NSMutableArray new];
    [orderTypes addObject:[[SpecialOfferListOrderType alloc] initWithNameAndValue:@"推荐排序" value:@"recommend"]];
    [orderTypes addObject:[[SpecialOfferListOrderType alloc] initWithNameAndValue:@"价格低" value:@"cheap"]];
    [orderTypes addObject:[[SpecialOfferListOrderType alloc] initWithNameAndValue:@"价格高" value:@"expensive"]];
    [orderTypes addObject:[[SpecialOfferListOrderType alloc] initWithNameAndValue:@"距离近" value:@"near"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return orderTypes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *orderTypesFilter = @"orderTypesFilter";
    SelectSpecialOfferListOrderTypeCellView *cell = [tableView dequeueReusableCellWithIdentifier:orderTypesFilter];
    if (cell == nil) {
        cell = [[SelectSpecialOfferListOrderTypeCellView alloc] initWithReuseIdentifier:orderTypesFilter];
    }
    
    cell.textLabel.text = [orderTypes[indexPath.row] name];
    if ([cell.textLabel.text isEqualToString:self.organizationFilter.selectedOrderTypeName]) {
        [self showCellRemindView:cell];
    }else{
        [self hideCellRemindView:cell];
    }
    
    // 处理分隔线
    if ([[[orderTypes lastObject] name] isEqualToString:cell.textLabel.text]) {
        [cell.separatorLine setHidden:YES];
    }else{
        [cell.separatorLine setHidden:NO];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return order_type_cell_height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SpecialOfferListOrderType *orderType = orderTypes[indexPath.row];
    
    [MobClick event:log_event_name_selected_order_type
         attributes:[NSDictionary dictionaryWithObjectsAndKeys:orderType.name, log_event_name_selected_order_type,nil]];
    
    if ([self.delegate respondsToSelector:@selector(specialOfferListOrderTypeSelectedOrderType:)]) {
        [self.delegate specialOfferListOrderTypeSelectedOrderType:orderType];
    }
}

-(void) hideThisView{
    if ([self.delegate respondsToSelector:@selector(specialOfferListOrderTypeSelectedOrderType:)]) {
        [self.delegate specialOfferListOrderTypeSelectedOrderType:nil];
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

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self hideCellRemindView:cell];
}

-(void) showCellRemindView:(UITableViewCell *)cell{
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:red_default_color]];
    ((SelectSpecialOfferListOrderTypeCellView *)cell).remindView.hidden = NO;
}

-(void) hideCellRemindView:(UITableViewCell *)cell{
    [cell.textLabel setTextColor:[ColorUtils colorWithHexString:black_text_color]];
    ((SelectSpecialOfferListOrderTypeCellView *)cell).remindView.hidden = YES;
}

@end




@implementation SelectSpecialOfferListOrderTypeCellView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.frame = CGRectMake( 0 , 0 , screen_width , order_type_cell_height);
        self.textLabel.font = [UIFont systemFontOfSize:small_font_size];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.remindView = [[UIView alloc] init];
        CGRect remindViewFrame = CGRectMake(0, 0, remind_block_view_width, order_type_cell_height);
        self.remindView.frame = remindViewFrame;
        self.remindView.backgroundColor = [ColorUtils colorWithHexString:red_default_color];
        [self addSubview:self.remindView];
        
        // 城区分隔线
        self.separatorLine = [[UIView alloc] init];
        self.separatorLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        self.separatorLine.frame = CGRectMake( order_type_cell_content_margin_left, self.frame.size.height-splite_line_height , self.frame.size.width-order_type_cell_content_margin_left,  splite_line_height);
        [self addSubview:self.separatorLine];
        
    }
    return self;
    
}

@end



