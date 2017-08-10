//
//  OrganizationStore.m
//  styler
//
//  Created by System Administrator on 14-2-14.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//


#import "Store.h"
#import "OrganizationStore.h"
#import "Brand.h"
#import "OrganizationFilter.h"

@implementation OrganizationStore

+(void) getBrands:(void (^)(NSArray *, NSError *))completionCallback pageNo:(int)pageNo pageSize:(int)pageSize
{
    NSString *urlStr = [NSString stringWithFormat:@"/brands/all?pageNo=%d&pageSize=%d&includeOrganization=false", pageNo, pageSize];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *dict = [json objectFromJSONString];
            NSArray *brands = [Brand arrayOfModelsFromDictionaries:[dict objectForKey:@"items"]];
            completionCallback(brands, nil);
        }else{
            NSLog(@"获取品牌列表失败");
        }
        
    } refresh:YES useCacheIfNetworkFail:YES];
}

+(void)getOrganizationByUrl:(void (^)(Page *, NSError *))completionCallback url:(NSString *)url{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *organizations = [Organization arrayOfModelsFromDictionaries:[jsonDict objectForKey:@"items"]];
            page.items = organizations;
            completionCallback(page, nil);
        }else{
            NSLog(@"获取商户列表失败");
        }
    } refresh:YES useCacheIfNetworkFail:YES];
}

+(void)getOrganizationById:(void (^)(Organization *, NSError *))completionCallback
            organizationId:(int)organizationId
               hasStylists:(BOOL)hasStylists
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/organizations/ids,%d?hasStylist=%d" , organizationId , hasStylists];
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSArray *organizations = [Organization arrayOfModelsFromDictionaries:[json objectFromJSONString]];
            if (organizations.count == 0){
                completionCallback(nil, nil);
            }else{
                Organization *organization = organizations[0];
                completionCallback(organization, nil);
            }
        }else{
            NSLog(@"获取商户列表失败");
        }
    } refresh:YES useCacheIfNetworkFail:YES];
}

+(void)getOrganizationsWithOrganizationFilter:(void (^)(Page *, NSError *))completionCallback
                        organizationFilter:(OrganizationFilter *)organizationFilter{
     AppStatus *as = [AppStatus sharedInstance];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *urlStr = [NSString stringWithFormat:@"/organizations?hdcType=%d&businessCirclesName=%@&currentPOI=%f,%f&orderType=%@&pageNo=%d" ,  organizationFilter.selectedHdcTypeId ,
                         [organizationFilter.selectedBusinessCircleName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                        [as getLastLat],
                        [as getLastLng],
                         organizationFilter.selectedOrderTypeValue ,
                         organizationFilter.pageNo ];
    if ([NSStringUtils isNotBlank:organizationFilter.brandName]) {
        NSString *str = [organizationFilter.brandName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableString *escaped = [NSMutableString stringWithString:str];
        [escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
        urlStr = [NSString stringWithFormat:@"%@&brandName=%@&pageSize=%d" ,urlStr ,escaped,organizationFilter.pageSize];
    }else if([organizationFilter.selectedBusinessCircleName isEqualToString:@"附近"]){
        urlStr = [NSString stringWithFormat:@"%@&pageSize=%d", urlStr, 20]; //如果是附近，默认20个
    }else{
        urlStr = [NSString stringWithFormat:@"%@&pageSize=%d" , urlStr ,organizationFilter.pageSize ];
    }
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].searcherUrl, urlStr]];
//    NSLog(@">>>>根据商圈和美发卡类型查商户:%@" , url);
    
    [requestFacade doGet:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *organizations = [Organization arrayOfModelsFromDictionaries:[jsonDict objectForKey:@"items"]];
            page.items = organizations;
            completionCallback(page, nil);
        }else{
            NSLog(@"获取商户列表失败了。。。");
            completionCallback(nil, err);
        }
    } refresh:YES useCacheIfNetworkFail:YES];
}

+(NSString *)getRequestUrlWithBrandName:(NSString *)brandName{
    NSString *urlStr = [[NSString stringWithFormat:@"/organizations/searcher?brandName=%@", brandName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *escaped = [NSMutableString stringWithString:urlStr];
    [escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
    return escaped;
}

+(NSString *)getRequestUrlWithContentSortId:(int)contentSortId{
    NSString *urlStr = [[NSString stringWithFormat:@"/contentSorts/%d/contentList", contentSortId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlStr;
}

+(NSString *)getRequestUrlWithOrganizationIds:(NSString *)orgIds{
    NSString *urlStr = [[NSString stringWithFormat:@"/organizations/searcher?organizationIds=%@&status=-1", orgIds] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlStr;
}

+ (OrganizationStore *) sharedStore{
    static OrganizationStore *organizationStore = nil;
    if(!organizationStore){
        organizationStore = [[super allocWithZone:nil] init];
    }
    return organizationStore;
}
@end
