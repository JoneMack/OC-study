//
//  ChooseServiceConditionsController.m
//  styler
//
//  Created by wangwanggy820 on 14-4-2.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "ChooseServiceConditionsController.h"
#import "PriceView.h"
#import "TargetServiceItem.h"
#import "UIView+Custom.h"
#import "OptionValueDescription.h"
#import "CustomStyleTextStorage.h"
#import "PriceCollectionViewCell.h"
#import "ChooseOrderTimeController.h"
#import "StylistStore.h"
#import "WebContainerController.h"
#import "UIViewController+Custom.h"

#define text_line_height 21
@interface ChooseServiceConditionsController ()

@end

@implementation ChooseServiceConditionsController
{
    TargetServiceItems *targetServiceItems;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightSwipeGestureAndAdaptive];
 
    targetServiceItems = self.servicePackage.targetServiceItemSuite;
    [self initView];
    [self renderUI];
    
}
//设置整个view的背景
-(void)initView{
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    
    [self initHeader];
    [self initOrderNavigationBar];
    [self initOrderPriceView];
    [self initOrderServiceWrapperView];
    [self initScrollView];
}

-(void)renderUI{
    [self renderOrderPriceView];
    [self renderOrderDetailInfo];
    
    //通过组合标的服务项目中的价格渲染
    [self performSelector:@selector(updateChoosedPriceCell) withObject:nil afterDelay:0.2];
}

#pragma mark --初始化头部--
-(void)initHeader{
    self.header = [[HeaderView alloc]initWithTitle:page_name_choose_service_condition navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

#pragma mark -----渲染头部下面的bar
-(void)initOrderNavigationBar{
    CGRect frame =  CGRectMake(0,self.header.frame.size.height + splite_line_height, screen_width, order_navigation_bar_height);
    self.orderBar = [[OrderNavigationBar alloc] initWithFrame:frame currentIndex:0];
    [self.view addSubview:self.orderBar];
}

#pragma mark -----设置预计金额-------
-(void)initOrderPriceView{
    self.priceOfOrderWrapperView.backgroundColor = [UIColor whiteColor];
    self.priceOfOrderWrapperView.frame = CGRectMake(0, self.header.frame.size.height + order_navigation_bar_height + general_padding, screen_width, 60);
    UITapGestureRecognizer *tapOrderAmountView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewServiceCare:)];
    [self.priceOfOrderWrapperView addGestureRecognizer:tapOrderAmountView];
    
    //设置cell的外框
    CALayer *layer = [self.priceOfOrderWrapperView layer];
    //是否设置边框被遮住
    [layer setMasksToBounds:YES];
    //设置边框线的宽
    [layer setBorderWidth:splite_line_height];
    //设置边框线的颜色
    [layer setBorderColor:[[ColorUtils colorWithHexString:splite_line_color] CGColor]];
    
    //预计金额label
    self.priceOfOrder.textColor = [ColorUtils colorWithHexString:black_text_color];
    self.priceOfOrder.font = [UIFont systemFontOfSize:big_font_size];
    //价格
    self.priceOfOrderInfo.textColor = [ColorUtils colorWithHexString:orange_text_color];
    self.priceOfOrderInfo.font = [UIFont systemFontOfSize:big_font_size];

    //提示信息
    self.reminderInformation.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.reminderInformation.font = [UIFont systemFontOfSize:small_font_size];
    
    //重做提示
    self.cutAgainReminderInformation.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.cutAgainReminderInformation.font = [UIFont systemFontOfSize:small_font_size];
}

//预计金额介绍
-(void) viewServiceCare:(id)sender{
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppStatus sharedInstance].webPageUrl, @"/app/serviceCare"];
    WebContainerController *wcc = [[WebContainerController alloc] initWithUrl:url title:@"时尚猫 美丽无忧"];
    [self.navigationController pushViewController:wcc animated:YES];
}

-(void)renderOrderPriceView{
    self.priceOfOrderInfo.text = [NSString stringWithFormat:@"￥%d", targetServiceItems.specialOfferPrice];
}
#pragma mark --------scrollView ------
-(void)initScrollView{
    self.scrollView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.scrollView.frame = CGRectMake(0, [self.priceOfOrderWrapperView bottomY], screen_width, self.orderServiceWrapperView.frame.origin.y - [self.priceOfOrderWrapperView bottomY]);
    [self initPriceListView];
    [self initOrderDetailInfo];
    self.scrollView.contentSize = CGSizeMake(screen_width, self.priceListView.frame.size.height + self.serviceinformation.frame.size.height +3*general_margin);
}

#pragma mark ---价目表------
-(void)initPriceListView{
    //根据标的服务项目中的服务名称找出对应的发型师服务项目数组，以及当前选中的单元格序号
    int currentCellIndex[self.servicePackage.targetServiceItemSuite.targetServiceItems.count];
    self.stylistServiceItems = [[NSMutableArray alloc] init];
    self.selectedStylistServiceItemPrice = [[NSMutableArray alloc] initWithCapacity:targetServiceItems.targetServiceItems.count];
    for (int i = 0; i < targetServiceItems.targetServiceItems.count; i++) {
        TargetServiceItem *targetServiceItem = targetServiceItems.targetServiceItems[i];
        for (StylistServiceItem *stylistServiceItem in self.priceList.stylistServiceItems) {
            if ([stylistServiceItem.name isEqualToString:targetServiceItem.name]) {
                [self.stylistServiceItems addObject:stylistServiceItem];
                currentCellIndex[i] = [stylistServiceItem minPriceIndex];
                self.selectedStylistServiceItemPrice[i] = stylistServiceItem.serviceItemPrices[currentCellIndex[i]];
            }
        }
    }
    
    //根据发型师服务项目组合创建服务项目价格视图
    float y = 0;
    for (int i = 0; i < self.stylistServiceItems.count; i++) {
        StylistServiceItem *serviceItem = self.stylistServiceItems[i];
        
        float height = [PriceView judgeHeight:serviceItem];
        CGRect frame = CGRectMake(0, y, self.view.frame.size.width, height);
        
        PriceView *priceView = [[PriceView alloc] initWithFrame:frame];
        priceView.priceCollectionView.delegate = self;
        priceView.priceCollectionView.tag = 1000+i;
        [self.priceListView addSubview:priceView];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentCellIndex[i] inSection:0];
        [priceView renderUI:serviceItem currentSelectedIndexPath:indexPath];
        y += height;
    }
    CGRect frame = self.priceListView.frame;
    frame.origin.y = 0;
    frame.size.height = y;
    self.priceListView.frame = frame;
    
    
    frame = self.serviceinformation.frame;
    frame.origin.y = [self.priceListView bottomY];
    self.serviceinformation.frame = frame;
}

//根据当前组合标的服务项目中的服务价格更新单元格中的价格
-(void)updateChoosedPriceCell{
    for (int i = 0; i < self.priceListView.subviews.count; i++) {
        //找到新的价格
        TargetServiceItem *targetServiceItem = (TargetServiceItem *)targetServiceItems.targetServiceItems[i];
        
        //更新新的价格
        PriceView *priceView = self.priceListView.subviews[i];
        [priceView updateSelectedPrice:targetServiceItem.price specialOfferPrice:targetServiceItem.specialOfferPrice];
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int collectionIndex = collectionView.tag - 1000;
    StylistServiceItem *stylistServiceItem = self.stylistServiceItems[collectionIndex];
    ((PriceView*)self.priceListView.subviews[collectionIndex]).currentIndexPath = indexPath;
    
    //如果当前选中的是否同上一次选中的服务价格一致，则不请求接口
    StylistServiceItemPrice *lastStylistServiceItemPrice = self.selectedStylistServiceItemPrice[collectionIndex];
    StylistServiceItemPrice *currentStylistServiceItemPrice = stylistServiceItem.serviceItemPrices[indexPath.item];
    if (lastStylistServiceItemPrice == currentStylistServiceItemPrice) {
        return ;
    }
    
    self.selectedStylistServiceItemPrice[collectionIndex] = stylistServiceItem.serviceItemPrices[indexPath.item];
    for (int i = 0; i < targetServiceItems.targetServiceItems.count; i++) {
        StylistServiceItemPrice *stylistServiceItemPrice = self.selectedStylistServiceItemPrice[i];
        TargetServiceItem *targetServiceItem = (TargetServiceItem *)targetServiceItems.targetServiceItems[i];
        targetServiceItem.serviceConditions = stylistServiceItemPrice.serviceConditions;
    }
    
    StylistStore *stylistStore = [StylistStore sharedStore];
    self.orderServiceBtn.enabled = NO;
    [stylistStore caculateTargetServiceItems:^(TargetServiceItems *newTargetServiceItems, NSError *err) {
        targetServiceItems = newTargetServiceItems;
    
        [self renderUI];
        self.orderServiceBtn.enabled = YES;
    } stylistId:self.stylist.id targetServiceItems:targetServiceItems];
    
}


#pragma mark --------订单详情------
-(void)initOrderDetailInfo{
    //设置优惠详情
    self.specialOffer.backgroundColor = [UIColor clearColor];
    self.specialOffer.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.specialOffer.font = [UIFont systemFontOfSize:default_font_size];

    self.specialOfferDescriptions.backgroundColor = [UIColor clearColor];
    self.specialOfferDescriptions.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.specialOfferDescriptions.font = [UIFont systemFontOfSize:default_font_size];

    //设置服务说明
    self.service.backgroundColor = [UIColor clearColor];
    self.service.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.service.font = [UIFont systemFontOfSize:default_font_size];

    self.serviceDescriptions.backgroundColor = [UIColor clearColor];
    self.serviceDescriptions.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.serviceDescriptions.font = [UIFont systemFontOfSize:default_font_size];

    //设置optionValue
    self.optionValue.backgroundColor = [UIColor clearColor];
    self.optionValue.textColor = [ColorUtils colorWithHexString:orange_text_color];
    self.optionValue.font = [UIFont boldSystemFontOfSize:default_font_size];

    //选项值描述
    self.optionValueDescriptions.backgroundColor = [UIColor clearColor];
    self.optionValueDescriptions.textColor = [ColorUtils colorWithHexString:orange_text_color];
    self.optionValueDescriptions.font = [UIFont boldSystemFontOfSize:default_font_size];

    //设置时长
    self.serviceTime.backgroundColor = [UIColor clearColor];
    self.serviceTime.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.serviceTime.font = [UIFont systemFontOfSize:default_font_size];

    self.serviceTimeDescriptions.backgroundColor = [UIColor clearColor];
    self.serviceTimeDescriptions.textColor = [ColorUtils colorWithHexString:gray_text_color];
    self.serviceTimeDescriptions.font = [UIFont systemFontOfSize:default_font_size];
}

-(void)renderOrderDetailInfo{
    //设置整个serviceinformation
    CGRect frame = self.serviceinformation.frame;
    frame.origin.y = [self.priceListView bottomY];
    self.serviceinformation.frame = frame;
    
    //设置optionValue
    NSArray *option = targetServiceItems.optionValueDescriptions;
    for (OptionValueDescription *optionValue in option) {
        self.optionValue.text = optionValue.name;
    }
    frame = self.optionValue.frame;
    frame.origin.y = 0;
    frame.size.height = text_line_height;
    if (option.count == 0) {
        frame.size.height = 0;
    }
    self.optionValue.frame = frame;
    
    //选项值描述
    self.optionValueDescriptions.numberOfLines = 0;
    self.optionValueDescriptions.text = @"";
    for (int i = 0; i < option.count; i++) {
        OptionValueDescription *optionValue = option[i];
        if (i < option.count-1) {
            NSString *str = [NSString stringWithFormat:@"%@\n",optionValue.description];
            self.optionValueDescriptions.text = [self.optionValueDescriptions.text stringByAppendingString:str];
        }else{
            NSString *str = [NSString stringWithFormat:@"%@",optionValue.description];
            self.optionValueDescriptions.text = [self.optionValueDescriptions.text stringByAppendingString:str];
        }
    }
    

    
    CGSize size = [self.optionValueDescriptions.text sizeWithFont:self.optionValueDescriptions.font constrainedToSize:CGSizeMake(screen_width - [self.optionValue rightX], 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    frame = self.optionValueDescriptions.frame;
    frame.origin.y = self.optionValue.frame.origin.y+2;
    frame.size = size;
    self.optionValueDescriptions.frame = frame;
    
    //设置优惠详情
    int count = targetServiceItems.specialOfferDescriptions.count;
    frame = self.specialOffer.frame;
    frame.origin.y = (count >0)?([self.optionValueDescriptions bottomY]+general_padding/2):[self.optionValueDescriptions bottomY]-general_margin;
    frame.size.height = text_line_height;
    if (count == 0) {
        frame.size.height = 0;
    }
    self.specialOffer.frame = frame;
    
    self.specialOfferDescriptions.numberOfLines = 0;
    self.specialOfferDescriptions.text = [targetServiceItems specialOfferDescriptionsString];
    size = [self.specialOfferDescriptions.text sizeWithFont:self.specialOfferDescriptions.font constrainedToSize:CGSizeMake(screen_width - [self.specialOffer rightX], 1000) lineBreakMode:NSLineBreakByWordWrapping];
    frame = self.specialOfferDescriptions.frame;
    frame.origin.y = self.specialOffer.frame.origin.y+2;
    frame.size = size;
    self.specialOfferDescriptions.frame = frame;
    
    //设置服务说明
    count = targetServiceItems.serviceDescriptions.count;
    frame = self.service.frame;
    frame.origin.y = (count >0)?([self.specialOfferDescriptions bottomY]+general_padding/2):[self.specialOfferDescriptions bottomY];
    frame.size.height = text_line_height;
    if (count == 0) {
        frame.size.height = 0;
    }
    self.service.frame = frame;
    
    self.serviceDescriptions.numberOfLines = 0;
    self.serviceDescriptions.text = [targetServiceItems serviceDescriptionsString];
    size = [self.serviceDescriptions.text sizeWithFont:self.serviceDescriptions.font constrainedToSize:CGSizeMake(screen_width - [self.service rightX], 1000) lineBreakMode:NSLineBreakByWordWrapping];
    frame = self.serviceDescriptions.frame;
    frame.size = size;
    frame.origin.y = self.service.frame.origin.y + 2;
    self.serviceDescriptions.frame = frame;
    
    //设置时长
    frame = self.serviceTime.frame;
    frame.origin.y = [self.serviceDescriptions bottomY] + general_padding/2;
    frame.size.height = text_line_height;
    self.serviceTime.frame = frame;
    
    self.serviceTimeDescriptions.text = [NSString stringWithFormat:@"%.1f小时", targetServiceItems.serviceTime/60.0];
    frame = self.serviceTimeDescriptions.frame;
    frame.origin.y = self.serviceTime.frame.origin.y;
    self.serviceTimeDescriptions.frame = frame;
    
    //设置整个serviceinformation
    frame = self.serviceinformation.frame;
    frame.origin.y = [self.priceListView bottomY];
    frame.size.height = [self.serviceTimeDescriptions bottomY] +general_padding;
    self.serviceinformation.frame = frame;
}

#pragma  mark -----订单按钮------
-(void)initOrderServiceWrapperView{
    int y = self.view.frame.size.height - self.orderServiceWrapperView.frame.size.height;
    self.orderServiceWrapperView.frame = CGRectMake(0, y, screen_width, self.orderServiceWrapperView.frame.size.height);
    self.orderServiceWrapperView.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
}

- (IBAction)orderService:(id)sender {
    ChooseOrderTimeController *sotc = [[ChooseOrderTimeController alloc] init];
    sotc.servicePackage = self.servicePackage;
    sotc.stylist = self.stylist;
    sotc.targetServiceItems = targetServiceItems;
    [self.navigationController pushViewController:sotc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getPageName{
    return page_name_choose_service_condition;
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    CGRect frame = self.serviceinformation.frame;
//    frame.origin.y = [self.priceListView bottomY];
//    self.serviceinformation.frame = frame;
//}

@end
