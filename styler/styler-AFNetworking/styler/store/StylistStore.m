//
//  ExpertStore.m
//  iUser
//
//  Created by System Administrator on 13-4-11.
//  Copyright (c) 2013年 珠元玉睿ray. All rights reserved.
//
#import "StylistStore.h"
#import "Tag.h"
#import "SortType.h"
#import "StylistWork.h"
#import "NSString+stringPlus.h"


@implementation StylistStore
-(void) findStylistWork:(void (^)(NSArray *experWorkList, NSError *err))completionBlock
                             tagIds:(NSArray *)tagIds
                          orderType:(int)orderType
                                lng:(double)lng
                                lat:(double)lat
                             pageNo:(int)pageNo
                            refresh:(BOOL)refresh{
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendFormat:@"/expertWork/filter?cityExpertTypeId=%d&pageNo=%d&pageSize=%d&orderType=%d&lng=%@&lat=%@", 5, pageNo, work_list_page_size, orderType, [NSNumber numberWithDouble:lng].stringValue, [NSNumber numberWithDouble:lat].stringValue];
    for (int i = 0; i < tagIds.count; i++) {
        NSNumber *tagId = (NSNumber *)tagIds[i];
        
        if (tagId.intValue > 0)
            [urlStr appendFormat:@"&tagId=%d", tagId.intValue];
    }

    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if(err == nil){
            NSArray *jsonArray = [json objectFromJSONString];
            //NSLog(@">>>>>> 作品个数:%d, 当前页数：%d", [jsonArray count], pageNo);
            NSArray *stylistWorkArray = [Stylist arrayOfModelsFromDictionaries:jsonArray];
            completionBlock(stylistWorkArray, nil);
        }else{
            completionBlock(nil, err);
        }
    } refresh:refresh useCacheIfNetworkFail:NO];
}

-(void) getStylist:(void(^)(Stylist *stylist, NSError *err))completionBlock
             stylistId:(int)stylistId
              refresh:(BOOL) refresh{
    NSString *urlStr = [NSString stringWithFormat:@"/stylists/%d", stylistId];
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            NSError *jsonErr;
            Stylist *stylist = [[Stylist alloc] initWithDictionary:jsonDict error:&jsonErr];
            if (err != nil) {
                NSLog(@">>>> 发型师反序列化失败:%@", jsonErr);
            }
            completionBlock(stylist, nil);
        }else{
            completionBlock(nil, err);
        }
    } refresh:refresh useCacheIfNetworkFail:YES];
    
}

-(void) checkLatestPublishWorkCount:(void(^)(int count, NSError *err))completionBlock{
    AppStatus *as = [AppStatus sharedInstance];
    if (as.latestWorkPublishTime == nil) {
        return ;
    }
    NSString *urlStr = [NSString stringWithFormat:@"/expertWork/latestPublishWork/count?fromDate=%.0f", [[as latestWorkPublishTime] timeIntervalSince1970]*1000];
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *str, NSError *err) {
        if (str != nil) {
            NSLog(@"%.0f,%@:有%@个新发布作品",[[as latestWorkPublishTime] timeIntervalSince1970]*1000, [as latestWorkPublishTime], str);
            completionBlock(str.intValue, nil);
        }else{
            completionBlock(0, err);
        }
    } refresh:YES useCacheIfNetworkFail:NO];
}

-(void)getStylist:(void(^)(Page *page, NSError *err))completionBlock
              uriStr:(NSString *)urlStr
             refresh:(BOOL) refresh
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:urlStr completionBlock:^(NSString *json, NSError *err) {
        if (json != nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *stylists = [Stylist arrayOfModelsFromDictionaries:[jsonDict objectForKey:@"items"]];
            page.items = stylists;
            completionBlock(page, nil);
        }else{
            completionBlock(nil, err);
        }
    } refresh:refresh useCacheIfNetworkFail:YES];
}

+(NSString *)getUriForStylistsContentSort:(int)contentSortId
{
    NSString * uriStr = [NSString stringWithFormat:@"/contentSorts/%d/contentList?pageSize=%d", contentSortId, stylist_list_page_size];
    return uriStr;
}

+(NSString *)getUriForStylistsFromFav:(NSString *)userId
{
    NSString * uriStr = [NSString stringWithFormat:@"/users/%@/stylistCollections/page?pageSize=%d",userId,stylist_list_page_size];
    return uriStr;
}

+(NSString *)getUriForSameOrganizationStylist:(NSString *)organizationName
{
    NSString *uri = [NSString stringWithFormat:@"/stylists?organizationName=%@&pageSize=%d&dataStatus=2", [organizationName urlEncode], stylist_list_page_size];
    return uri;
}

+(NSString *)getUriByOrganizationId:(int)organizationId{
    NSString *uri = [NSString stringWithFormat:@"/stylists?organizationId=%d&dataStatus=2", organizationId];
    return uri;
}

+(NSString *)getUriByStylistIds:(NSString *)stylistIds{
    NSString *uri = [NSString stringWithFormat:@"/stylists?stylistIds=%@&dataStatus=2", stylistIds];
    return uri;
}

+(NSString *)getUriForBusinessCirclesStylist:(NSString *)businessCirclesName cityName:(NSString *)cityName{
    NSString *uri = [NSString stringWithFormat:@"/stylists/searcher?cityName=%@&businessCirclesName=%@&pageSize=%d&dataStatus=2", [cityName urlEncode], [businessCirclesName urlEncode], stylist_list_page_size];
    return uri;
}

-(void)updateViewStylist:(void(^)(NSError *err))completionBlock
               stylistId:(int)stylistId
                refresh:(BOOL) refresh
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    
    [requestFacade post:[NSString stringWithFormat: @"/experts/%d/updateViewCount", stylistId] completionBlock:^(NSString *json, NSError *err) {
        completionBlock(err);
    } params:nil];
}


-(void) getStylistPriceList:(void(^)(StylistPriceList *priceList, NSError *err))completionBlock stylistId:(int)stylistId{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/priceList/%d/priceList", stylistId];
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *dic = [json objectFromJSONString];
            NSError *err;
            StylistPriceList *priceList = [[StylistPriceList alloc] initWithDictionary:dic error:&err];
            if (err != nil) {
                NSLog(@">> 解析错误:%@", err);
            }
            [priceList cleanNoSupportServiceItem];
            completionBlock(priceList, nil);
        }else{
            completionBlock(nil, err);
        }
    } refresh:YES useCacheIfNetworkFail:NO];
}

-(void)getStylistServicePackage:(void (^)(NSArray *servicePackages, NSError *err))completionBlock stylistId:(int)stylistId
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/priceList/%d/stylistServicePackages", stylistId];
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSArray *arr = [json objectFromJSONString];
            NSArray *servicePackage = [StylistServicePackage arrayOfModelsFromDictionaries:arr];
            completionBlock(servicePackage, nil);
        }else{
            completionBlock(nil, err);
        }
    } refresh:YES useCacheIfNetworkFail:NO];
}

-(void) caculateTargetServiceItems:(void(^)(TargetServiceItems *targetServiceItems, NSError *err))completionBlock
                         stylistId:(int)stylistId
                targetServiceItems:(TargetServiceItems *)targetServiceItems{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/priceList/%d/targetServiceItemCaculator?targetServiceItems=%@", stylistId, [[targetServiceItems toJSONString]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if(err == nil){
            NSError *jsonErr;
            TargetServiceItems *newTargetServiceItems = [[TargetServiceItems alloc] initWithDictionary:[json objectFromJSONString] error:&jsonErr];
            completionBlock(newTargetServiceItems, nil);
        }else{
            completionBlock(nil, err);
        }
    } refresh:YES useCacheIfNetworkFail:NO];
}

+ (StylistStore *) sharedStore
{
    static StylistStore *stylistStore = nil;
    if(!stylistStore){
        stylistStore = [[StylistStore alloc] init];
    }
    return stylistStore;
}
@end
