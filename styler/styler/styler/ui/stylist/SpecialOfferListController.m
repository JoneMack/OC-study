//
//  SpecialOfferListController.m
//  styler
//
//  Created by System Administrator on 14-1-22.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "SpecialOfferListController.h"
#import "StylistSpecialOffer.h"
#import "CommonItemTxt.h"
#import "UIView+Custom.h"
#import "UIViewController+Custom.h"

#define special_offer_name_height 26
#define service_item_name_height 17
#define service_item_name_width 60
#define special_offer_description_width 280
#define special_offer_name_margin 10
#import "MobClick.h"

@interface SpecialOfferListController ()

@end

@implementation SpecialOfferListController

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
    [self initView];
    [self initHeader];
    [self renderSpecialOfferList];
}

-(void) initView{
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor = [ColorUtils colorWithHexString:backgroud_color];
    self.view.autoresizesSubviews = NO;
}

-(void) initHeader{
    self.header = [[HeaderView alloc] initWithTitle:page_name_special_offers navigationController:self.navigationController];
    [self.view addSubview:self.header];
}

-(void) renderSpecialOfferList
{
    [self.specialOfferListTable setDelegate:self];
    [self.specialOfferListTable setDataSource:self];
    [self.specialOfferListTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    int height = self.view.frame.size.height-self.header.frame.size.height;

    self.specialOfferListTable.frame = CGRectMake(0, self.header.frame.size.height, self.view.frame.size.width, height);
    self.specialOffersCommonItemTxtArray = [self.priceList getSpecialOffersCommonItemTxtArray];
    [self.specialOfferListTable reloadData];
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.specialOffersCommonItemTxtArray.count;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommonItemTxt *specialOffer = ((CommonItemTxt*)self.specialOffersCommonItemTxtArray[indexPath.row]);
    return [self judgeCellHeight:specialOffer];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"specialOfferCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
        CommonItemTxt *specialOffer = ((CommonItemTxt*)self.specialOffersCommonItemTxtArray[indexPath.row]);
        
        
        UILabel *specialOfferName = [[UILabel alloc] init];
        [specialOfferName setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
        specialOfferName.textAlignment = NSTextAlignmentLeft;
        [specialOfferName setText:specialOffer.title];
        [specialOfferName setFont:[UIFont boldSystemFontOfSize:default_font_size]];
        
        specialOfferName.frame = CGRectMake(special_offer_name_margin, special_offer_name_margin, 200, special_offer_name_height);
        [cell addSubview:specialOfferName];
        
        NSArray *serviceItems = [specialOffer.content componentsSeparatedByString:@"\n"];
        float x = special_offer_name_margin;
        float y = 2*special_offer_name_margin+service_item_name_height;
        for (NSString *serviceItem in serviceItems) {
            NSArray *serviceItemInfoArray = [serviceItem componentsSeparatedByString:@"::"];
            
            UILabel *serviceItemName = [UILabel new];
            serviceItemName.backgroundColor = [UIColor clearColor];
            serviceItemName.textAlignment = NSTextAlignmentRight;
            [serviceItemName setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
            [serviceItemName setFont:[UIFont systemFontOfSize:default_font_size]];
            serviceItemName.text = serviceItemInfoArray[0];
            serviceItemName.frame = CGRectMake(x, y, service_item_name_width, (serviceItemName.text.length>4?2:1)*service_item_name_height);
            serviceItemName.numberOfLines = 0;
            [cell.contentView addSubview:serviceItemName];
            
            UILabel *specialOfferDescription = [UILabel new];
            [specialOfferDescription setTextColor:[ColorUtils colorWithHexString:gray_text_color]];
            [specialOfferDescription setFont:[UIFont systemFontOfSize:default_font_size]];
            specialOfferDescription.text = serviceItemInfoArray[1];
            [specialOfferDescription setNumberOfLines:0];
            
            CGSize specialOfferDescriptionSize = [specialOfferDescription.text sizeWithFont:specialOfferDescription.font constrainedToSize:CGSizeMake(self.view.frame.size.width-[serviceItemName rightX]-2*special_offer_name_margin, 300) lineBreakMode:NSLineBreakByCharWrapping];
            
            specialOfferDescription.frame = CGRectMake([serviceItemName rightX]+special_offer_name_margin, y, specialOfferDescriptionSize.width, specialOfferDescriptionSize.height);
            [cell.contentView addSubview:specialOfferDescription];
            
            CGSize serviceItemNameSize = [serviceItemInfoArray[0] sizeWithFont:[UIFont systemFontOfSize:default_font_size] constrainedToSize:CGSizeMake(service_item_name_width, 300) lineBreakMode:NSLineBreakByCharWrapping];
            if (serviceItemNameSize.height > specialOfferDescriptionSize.height) {
                y = y + serviceItemNameSize.height + general_padding;
            }else{
                y = y + specialOfferDescriptionSize.height + general_padding;
            }
        }
        
        UIView *spliteLine = [[UIView alloc] initWithFrame:CGRectMake(general_padding, y-1, self.view.frame.size.width, 0.5)];
        spliteLine.backgroundColor = [ColorUtils colorWithHexString:splite_line_color];
        [cell addSubview:spliteLine];
   
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}



-(float) judgeCellHeight:(CommonItemTxt *)specialOffer{
    NSArray *serviceItems = [specialOffer.content componentsSeparatedByString:@"\n"];
    float height = 2*special_offer_name_margin+service_item_name_height;
    for (NSString *serviceItem in serviceItems) {
        NSArray *serviceItemInfoArray = [serviceItem componentsSeparatedByString:@"::"];
        CGSize specialOfferDescriptionSize = [serviceItemInfoArray[1] sizeWithFont:[UIFont systemFontOfSize:default_font_size] constrainedToSize:CGSizeMake(self.view.frame.size.width-3*special_offer_name_margin-service_item_name_width, 300) lineBreakMode:NSLineBreakByCharWrapping];
        
        CGSize serviceItemNameSize = [serviceItemInfoArray[0] sizeWithFont:[UIFont systemFontOfSize:default_font_size] constrainedToSize:CGSizeMake(service_item_name_width, 300) lineBreakMode:NSLineBreakByCharWrapping];
        if (serviceItemNameSize.height > specialOfferDescriptionSize.height) {
            height += serviceItemNameSize.height + general_padding;
        }else{
            height += specialOfferDescriptionSize.height + general_padding;
        }
    }
    return height;
}

-(NSString *)getPageName{
    return page_name_special_offers;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:page_name_stylist_special_offer_list];
//}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:page_name_stylist_special_offer_list];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
