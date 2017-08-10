//
//  URLDispatcher.m
//  styler
//
//  Created by System Administrator on 14-2-15.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "URLDispatcher.h"
#import "StylistWorkStore.h"
#import "StylistProfileController.h"
#import "StylistStore.h"
#import "ContentSortStore.h"
#import "WorkListController.h"
#import "AllBrandController.h"
#import "AllHairStyleController.h"
#import "AllBusinessCirclesController.h"
#import "StylistListController.h"
#import "WebContainerController.h"
#import "OrganizationListController.h"
#import "OrganizationDetailInfoController.h"
#import "OrganizationMapController.h"
#import "OrganizationEvaluationController.h"
#import "OrganizationSpecialOfferListViewController.h"
#import "StylistListController.h"
#import "ConfirmHdcOrderController.h"
#import "AlipayProcessor.h"
#import "UserLoginController.h"
#import "UserHdcRefundController.h"
#import "ShareEnableWebController.h"
#import "WorkDetailController.h"
#import "AppDelegate.h"
#import "Stylist.h"
#import "StylerTabbar.h"
#import "OrganizationFilter.h"

@implementation URLDispatcher

+(BOOL) dispatch:(NSURL *)url nav:(UINavigationController *)nav
{
    NSString *path = [url path];
    NSString *params = [url query];
    NSString *host = [url host];
    if ([host isEqualToString:@"styler.meilizhuanjia.cn"] || [host isEqualToString:@"styler.shishangmao.cn"]) {
        
        if([path rangeOfString:@"/index"].location < path.length)
        {
            [SVProgressHUD dismiss];
            StylerTabbar *tabBar = [(AppDelegate*)[UIApplication sharedApplication].delegate tabbar];
            [tabBar setSelectedIndex:0];
            UINavigationController *targetNav = (UINavigationController *)[tabBar getSelectedViewController];
            [targetNav popToRootViewControllerAnimated:YES];
        }
        else if([path rangeOfString:@"/evaluations/"].location < path.length)
        {
            NSRange evluationRange = [path rangeOfString:@"/evaluations/"];
            
            NSString *stylistId = [path substringFromIndex:(evluationRange.location+evluationRange.length)];
            StylistStore * es = [StylistStore sharedStore];
            [es getStylist:^(Stylist *stylist, NSError *err) {
                [SVProgressHUD dismiss];
                StylistProfileController *spc = [[StylistProfileController alloc] init];
                spc.stylist = stylist;
                [nav pushViewController:spc animated:YES];
            } stylistId:[stylistId intValue] refresh:YES];
        }
        else if([path rangeOfString:@"/stylists/"].location < path.length)
        {
            NSRange stylistRange = [path rangeOfString:@"/stylists/"];
            NSString *stylistId = [path substringFromIndex:(stylistRange.location+stylistRange.length)];
            
//            通过A发型师进入1号商户后再选择A发型师应该是返回，若选择其他不同发型师的话则push到相应发型师主页
            if(nav.viewControllers.count >= 2 && [nav.viewControllers[nav.viewControllers.count-2] isKindOfClass:[StylistProfileController class]] && stylistId.intValue == [nav.viewControllers[nav.viewControllers.count-2] stylist].id){
                [nav popToViewController:nav.viewControllers[nav.viewControllers.count-2] animated:YES];
            }else{
                StylistProfileController *spc = [[StylistProfileController alloc] initWithStylistId:stylistId.intValue];
                [nav pushViewController:spc animated:YES];
            }
        }
        else if([path rangeOfString:@"/works/"].location < path.length)
        {
            NSRange worksRange = [path rangeOfString:@"/works/"];
            NSString *workId = [path substringFromIndex:(worksRange.location+worksRange.length)];
            WorkDetailController *wdc = [[WorkDetailController alloc] initWithWorkId:workId.intValue];
//            [wdc.collectBtn setImage:[UIImage imageNamed:@"collect_icon"] forState:UIControlStateNormal];
            //StylistProfileController *spc = [[StylistProfileController alloc] initWithStylistId:stylistId.intValue];
            [nav pushViewController:wdc animated:YES];
        }
        else if([path rangeOfString:@"/stylistList/"].location < path.length){
            NSRange stylistListRange = [path rangeOfString:@"/stylistList/"];
            NSString *stylistIds = [path substringFromIndex:(stylistListRange.location+stylistListRange.length)];
            NSString *url = [StylistStore getUriByStylistIds:stylistIds];
            StylistListController *slc = [[StylistListController alloc] initWithRequestUrl:url title:@"适用发型师" type:common_styler_type];
            [nav pushViewController:slc animated:YES];
            
            [MobClick event:log_event_name_view_suitable_stylist];
        }
        else if([path rangeOfString:@"/contentSorts/"].location < path.length){
            //栏目id
            int contentSortId = [[path substringFromIndex:[path rangeOfString:@"/contentSorts/"].length] intValue];
            NSString *nameStr = [params substringFromIndex:5];
            NSRange range = [nameStr rangeOfString:@"&"];
            //栏目名称
            NSString *contentSortName = [[nameStr substringToIndex:range.location] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSRange range2 = [nameStr rangeOfString:@"="];
            //内容类型
            int contentModeType = [[nameStr substringFromIndex:range2.location + 1] intValue];
            NSString *str = [NSString stringWithFormat:@"%d&extendParam=",contentModeType];
            //扩展参数
            NSString *extendParam = [nameStr substringFromIndex:range2.location + 1 +str.length];
            extendParam = [extendParam stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
            return [self dispatchWithContentSort:contentSortId contentSortName:contentSortName extendParam:extendParam contentModeType:contentModeType nav:nav];
        }else if([path rangeOfString:@"/allHairStyle"].location < path.length){
            [SVProgressHUD dismiss];
            [nav pushViewController:[[AllHairStyleController alloc] init] animated:YES];
        }
//        else if([path rangeOfString:@"/allBrands"].location < path.length){
//            [SVProgressHUD dismiss];
//            [nav pushViewController:[[AllBrandController alloc] init] animated:YES];
//        }
        else if([path rangeOfString:@"/allBusinessCircles"].location < path.length){
            [SVProgressHUD dismiss];
            [nav pushViewController:[[AllBusinessCirclesController alloc] init] animated:YES];
        }else if([path rangeOfString:@"/organizations"].location < path.length){
            NSString *str = @"/organizations/";
            int organizationId = [[path substringFromIndex:str.length] intValue];
            if ([path rangeOfString:@"/map"].location < path.length) {
                NSString *jsonStr = [[params substringFromIndex:5] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                Organization *organization = [[Organization alloc] initWithString:jsonStr error:nil];
                OrganizationMapController *omc = [[OrganizationMapController alloc] initWithOrganization:organization];
                [nav pushViewController:omc animated:YES];
                
                [MobClick event:log_event_name_view_org_map attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(organizationId), @"沙龙id",nil]];
                return YES;
            }else if([path rangeOfString:@"stylists"].location < path.length){

                
                int start = [path rangeOfString:@"organizations"].location+14;
                int end = [path rangeOfString:@"stylists"].location-1;
                organizationId = [path substringWithRange:NSMakeRange(start, end-start)].intValue;
                NSString *url = [StylistStore getUriByOrganizationId:organizationId];
                StylistListController *slc = [[StylistListController alloc] initWithRequestUrl:url title:@"可预约发型师" type:common_styler_type];
                [nav pushViewController:slc animated:YES];
                
                [MobClick event:log_event_name_view_same_org_stylist attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(organizationId), @"沙龙id",nil]];
                return YES;
            }
            
            if([path rangeOfString:@"rewardActivity"].location < path.length){  // 点击了机构详情页的奖励活动banner
                NSLog(@">>>>>>>>>>点击了奖励活动banner......");
                
                UIViewController *currentOrganizationDetailController = [nav viewControllers][nav.viewControllers.count -1];
                RewardActivityProcessor *rewardActivityProcessor = [RewardActivityProcessor sharedInstance];
                [rewardActivityProcessor tryDisplayMovement:currentOrganizationDetailController];
                
                [MobClick event:log_event_name_share_organization_reward_activity attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(organizationId), @"沙龙id" , nil]];
                return YES;
            }
            if(nav.viewControllers.count >= 2 && [nav.viewControllers[nav.viewControllers.count-2] isKindOfClass:[OrganizationDetailInfoController class]]){
                [nav popToViewController:nav.viewControllers[nav.viewControllers.count-2] animated:YES];
                return YES;
            }
            OrganizationDetailInfoController *odic = [[OrganizationDetailInfoController alloc] initWithOrganizationId:organizationId];
            [nav pushViewController:odic animated:YES];
            return YES;
        }else if ([path rangeOfString:@"/list"].location < path.length){
            if([path hasPrefix:@"/preferential"]){
                NSMutableArray *paramKeys = [[NSMutableArray alloc] init];
                NSMutableArray *paramValues = [[NSMutableArray alloc] init];
                for (NSString *param in [params componentsSeparatedByString:@"&"]) {
                    NSArray *keyValue = [param componentsSeparatedByString:@"="];
                    [paramKeys addObject:keyValue[0]];
                    [paramValues addObject:keyValue[1]];
                }
                
                OrganizationFilter *organizationFilter = [[OrganizationFilter alloc] init];
                if ([paramKeys containsObject:@"hdcType"]) {
                    int hdcType = [[paramValues objectAtIndex:[paramKeys indexOfObject:@"hdcType"]] intValue];
                    organizationFilter.selectedHdcTypeValue = hdcType;
                    if ([paramKeys containsObject:@"hdcTypeName"]) {
                        NSString *hdcTypeName = [paramValues objectAtIndex:[paramKeys indexOfObject:@"hdcTypeName"]];
                        organizationFilter.selectedHdcTypeName = hdcTypeName;
                    }
                    OrganizationSpecialOfferListViewController *osov = [[OrganizationSpecialOfferListViewController alloc] initWithOrganizationFilter:organizationFilter];
                    [nav pushViewController:osov animated:YES];
                    [MobClick event:log_event_name_hdc_type attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(hdcType), @"美发卡类型", nil]];
                }else if ([paramKeys containsObject:@"brandName"]){
                    organizationFilter.brandName = [[paramValues objectAtIndex:[paramKeys indexOfObject:@"brandName"]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    OrganizationSpecialOfferListViewController *osov = [[OrganizationSpecialOfferListViewController alloc] initWithOrganizationFilter:organizationFilter];
                    [nav pushViewController:osov animated:YES];
                    [MobClick event:log_event_name_organization_brand attributes:[NSDictionary dictionaryWithObjectsAndKeys:organizationFilter.brandName, @"美发卡类型", nil]];
                }else{
                    OrganizationSpecialOfferListViewController *osov = [[OrganizationSpecialOfferListViewController alloc]initWithOrganizationFilter:organizationFilter];
                    [nav pushViewController:osov animated:YES];
                }
            }
        }
        else if ([path rangeOfString:@"/brands/"].location < path.length){
            [nav pushViewController:[[AllBrandController alloc] init] animated:YES];
        }
        else if([path rangeOfString:@"/hairDressingCards/"].location < path.length){
            NSArray *array = [params componentsSeparatedByString:@"="];
            NSString *from = [array objectAtIndex:1];
            
            NSString *str = @"/hairDressingCards/";
            int cardId = [[path substringFromIndex:str.length] intValue];
            AppStatus *as = [AppStatus sharedInstance];
            NSString *url = [NSString stringWithFormat:@"%@/app/hairDressingCards/%d?from=%@", as.webPageUrl, cardId, from];
            ShareEnableWebController *hdc = [[ShareEnableWebController alloc] initWithUrl:url title:@"" shareable:YES];
            
            [nav pushViewController:hdc animated:YES];
            
            [MobClick event:log_event_name_view_hdc_in_organization attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(cardId), @"美发卡id",nil]];
        }else if([path rangeOfString:@"/buyCard"].location < path.length){
            AppStatus *as = [AppStatus sharedInstance];
            if (![as logined]) {
                UserLoginController *ulc = [[UserLoginController alloc] initWithFrom:account_session_from_buy_card];
                [nav pushViewController:ulc animated:YES];
                return YES;
            }
            
            NSArray *array = [params componentsSeparatedByString:@"="];
            int cardId = [[array objectAtIndex:1] intValue];
            NSString *from = [array objectAtIndex:2];
            int stylistId = [[array objectAtIndex:3] intValue];

            ConfirmHdcOrderController *choc = [[ConfirmHdcOrderController alloc] init];
            choc.payModel = pay_model_hdc;
            choc.cardId = cardId;
            choc.from = from;
            choc.stylistId = stylistId;
            [nav pushViewController:choc animated:YES];
            
            [MobClick event:log_event_name_buy_hdc attributes:[NSDictionary dictionaryWithObjectsAndKeys:@(cardId), @"美发卡id",nil]];
        }else if([path rangeOfString:@"/buyUserCard"].location < path.length){
            NSArray *array = [params componentsSeparatedByString:@"="];
            NSString *userHdcNum = [array objectAtIndex:1];
            ConfirmHdcOrderController *choc = [[ConfirmHdcOrderController alloc] init];
            choc.payModel = pay_model_user_hdc;
            choc.userHdcNum = userHdcNum;
            [nav pushViewController:choc animated:YES];
            
            [MobClick event:log_event_name_buy_user_hdc];
        }else if ([path rangeOfString:@"/redirect"].location < path.length){
            if ([params rangeOfString:@"/list"].location < params.length) {
                NSArray *arr = [params componentsSeparatedByString:@"="];
                NSString *urlStr = [arr objectAtIndex:1];
                if([urlStr rangeOfString:@"http:"].location != 0){
                    AppStatus *as = [AppStatus sharedInstance];
                    urlStr = [NSString stringWithFormat:@"%@%@", as.webPageUrl, urlStr];
                }
                WebContainerController *wcc = [[WebContainerController alloc] initWithUrl:urlStr title:@"全部"];
                [nav pushViewController:wcc animated:YES];
                
            }else{
                NSArray *arr = [params componentsSeparatedByString:@"&"];
                NSString *str1 = [arr objectAtIndex:0];
                NSRange range1 = [str1 rangeOfString:@"to="];
                NSString *urlStr = [str1 substringFromIndex:range1.location+3];
                NSString *str2 = [arr objectAtIndex:1];
                NSRange range2 = [str2 rangeOfString:@"title="];
                NSString *titleStr = [[str2 substringFromIndex:range2.location+6] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                if([urlStr rangeOfString:@"http:"].location != 0){
                    AppStatus *as = [AppStatus sharedInstance];
                    urlStr = [NSString stringWithFormat:@"%@%@", as.webPageUrl, urlStr];
                }
                WebContainerController *wcc = [[WebContainerController alloc] initWithUrl:urlStr title:titleStr];
                [nav pushViewController:wcc animated:YES];
            }
        return YES;
     
        }else if ([path rangeOfString:@"/refund"].location < path.length){
            
            if ([path hasPrefix:@"/userHdcs/"]) {
                NSArray *arr = [path componentsSeparatedByString:@"/"];
                NSString *userHdcNum = [arr objectAtIndex:2];

                UserHdcRefundController *urc = [[UserHdcRefundController alloc] init];
                urc.userHdcNum = userHdcNum;
                [nav pushViewController:urc animated:YES];
                
                [MobClick event:log_event_name_refund_user_hdc];
            }
            else{
                NSArray *arr = [path componentsSeparatedByString:@"/"];
                int cardId = [[arr objectAtIndex:2] intValue];
                
                UserHdcRefundController *urc = [[UserHdcRefundController alloc] init];
                urc.cardId = cardId;
                [nav pushViewController:urc animated:YES];
                
                [MobClick event:log_event_name_refund_hdc];
            }
        }
        return YES;
    }else if([host isEqualToString:@"safepay"]){
        [[AlipayProcessor sharedInstance] processPaymentResultFromApp:[url query] nav:nav];
        return YES;
    }else if([host isEqualToString:@"webAlipay"]){
        NSLog(@">>>>>> web alipay back:%@, path:%@, query:%@", url, [url path], [url query]);
        [[AlipayProcessor sharedInstance] processPaymentResultFromWeb:[url query] nav:nav];
        return YES;
    }
     return NO;
}

+(BOOL) dispatchWithContentSort:(int)contentSortId
                contentSortName:(NSString *)contentSortName
                     extendParam:(NSString *)extendParam
                contentModeType:(int)contentModeType
                            nav:(UINavigationController *)nav{
    //NSLog(@"contentSortId:%d, name:%@, extendParam:%@, modeType:%d", contentSortId, contentSortName, extendParam, contentModeType);
    [MobClick event:log_event_name_select_businesscirlces attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentSortName, @"子栏目名", nil]];
    WorkListController *wclc = nil;
    StylistProfileController *spc = nil;
    WebContainerController *wcc = nil;
    StylistListController *slc = nil;
    NSString *url = nil;
    OrganizationListController *olc = nil;
    
    switch (contentModeType) {
        case 1://标签作品；
            url = [StylistWorkStore getUrlForContentSortWorks:contentSortId];
            wclc = [[WorkListController alloc] initWithRequestURL:url title:contentSortName type:tag_name_work];
            [nav pushViewController:wclc animated:YES];
            break;
        case 2://指定作品
            url = [StylistWorkStore getUrlForContentSortWorks:contentSortId];
            
            wclc = [[WorkListController alloc] initWithRequestURL:url title:contentSortName type:tag_name_work];
            [nav pushViewController:wclc animated:YES];
            break;
        case 3://指定发型师
            url = [StylistStore getUriForStylistsContentSort:contentSortId];
            slc = [[StylistListController alloc] initWithRequestUrl:url title:contentSortName type:common_styler_type];
            [nav pushViewController:slc animated:YES];
            break;
        case 4://预约排行榜
            break;
        case 5://机构发型师
            url = [StylistStore getUriForStylistsContentSort:contentSortId];
            slc = [[StylistListController alloc] initWithRequestUrl:url title:contentSortName type:common_styler_type];
            [nav pushViewController:slc animated:YES];
            break;
        case 6://商圈发型师
            slc = [[StylistListController alloc] initWithRequestUrl:[StylistStore getUriForBusinessCirclesStylist:contentSortName cityName:@"北京"] title:contentSortName type:common_styler_type];
            [nav pushViewController:slc animated:YES];
            break;
        case 7://推荐发型师
            spc = [[StylistProfileController alloc] initWithStylistId:[extendParam intValue]];
            [nav pushViewController:spc animated:YES];
            break;
        case 8://网页url
            wcc = [[WebContainerController alloc] initWithUrl:extendParam title:contentSortName];
            [nav pushViewController:wcc animated:YES];
            break;
        case 9://指定机构
            url = [OrganizationStore getRequestUrlWithContentSortId:contentSortId];
            olc = [[OrganizationListController alloc] initWithUrl:url title:contentSortName];
            olc.orderType = organization_order_by_distance;
            [nav pushViewController:olc animated:YES];
            break;
        case 10://品牌机构
            url = [OrganizationStore getRequestUrlWithContentSortId:contentSortId];
            olc = [[OrganizationListController alloc] initWithUrl:url title:contentSortName];
            olc.orderType = organization_order_by_distance;
            [nav pushViewController:olc animated:YES];
            break;
        case 11://商圈机构；
            url = [OrganizationStore getRequestUrlWithContentSortId:contentSortId];
            olc = [[OrganizationListController alloc] initWithUrl:url title:contentSortName];
            olc.orderType = organization_order_by_business_circle;
            [nav pushViewController:olc animated:YES];
            break;
        case 12://身边机构
            url = [OrganizationStore getRequestUrlWithContentSortId:contentSortId];
            olc = [[OrganizationListController alloc] initWithUrl:url title:contentSortName];
            olc.orderType = organization_order_by_distance;
            [nav pushViewController:olc animated:YES];
            break;
        default:
            return NO;
    }
    return YES;
}

@end
