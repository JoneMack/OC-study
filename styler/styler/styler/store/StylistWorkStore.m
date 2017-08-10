//
//  ExpertWorkStore.m
//  styler
//
//  Created by System Administrator on 13-9-12.
//  Copyright (c) 2013年 mlzj. All rights reserved.
//
#import "Store.h"
#import "StylistWorkStore.h"
#import "StylistStore.h"
#import "SortType.h"

@implementation StylistWorkStore

/**
 *  查找作品
 */
-(void)getStylistWorksBySearcher:(void (^)(Page *page, NSError * err))completionBlock
                      url:(NSString *)url
                  refresh:(BOOL)refresh
{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSURL *searcherUrl = [NSURL URLWithString:[NSString stringWithFormat: @"%@%@", [AppStatus sharedInstance].searcherUrl, url]];
//    NSLog(@">>>searcherUrl:%@" , searcherUrl);
    [requestFacade doGet:searcherUrl completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *works = [StylistWork arrayOfModelsFromDictionaries:[jsonDict objectForKey:@"items"]];
            page.items = works;
            if (works.count > 0) {
                [self fillStylistInfo:^{
                    completionBlock(page , nil);
                } works:works];
            }else{
                completionBlock(page, nil);
            }

        }else{
            completionBlock(nil, err);
        }
    } refresh:refresh useCacheIfNetworkFail:NO];
}

/**
 *  查找用户收藏的作品
 */
-(void) getStylistWorksByApi:(void (^)(Page *, NSError *))completionBlock
                           url:(NSString *)url
                       refresh:(BOOL)refresh{
    
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            Page *page = [[Page alloc] initWithJSONDictionary:jsonDict];
            NSArray *works = [StylistWork arrayOfModelsFromDictionaries:[jsonDict objectForKey:@"items"]];
            page.items = works;
            if (works.count > 0) {
                [self fillStylistInfo:^{
                    completionBlock(page , nil);
                } works:works];
            }else{
                completionBlock(page, nil);
            }
        }else{
            completionBlock(nil, err);
        }
    } refresh:refresh useCacheIfNetworkFail:YES];
}

/**
 *  作品渲染发型师信息
 */
-(void) fillStylistInfo:(void (^)())completionBlock works:(NSArray *)works{

    
    NSMutableArray *stylistIds = [[NSMutableArray alloc] init];
    
    for (StylistWork *work in works) {
        [stylistIds addObject:@(work.stylistId)];
    }
    
    NSString *url = [StylistStore getUriByStylistIds:[stylistIds componentsJoinedByString:@","]];
    [[StylistStore sharedStore] getStylist:^(Page *page, NSError *err) {
        for (StylistWork *work in works) {
            for (Stylist *stylist in page.items) {
                if (work.stylistId ==  stylist.id) {
                    [work setStylist:stylist];
                    break;
                }
            }
        }
        completionBlock();
    } uriStr:url refresh:YES];
}


+(void) getStylistWork:(void (^)(StylistWork *work, NSError *err))completionBlock
                workId:(int)workId
               refresh:(BOOL)refresh{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    NSString *url = [NSString stringWithFormat:@"/works?workIds=%d", workId];
    [requestFacade get:url completionBlock:^(NSString *json, NSError *err) {
        if (err == nil) {
            NSDictionary *jsonDict = [json objectFromJSONString];
            NSArray *works = [StylistWork arrayOfModelsFromDictionaries:[jsonDict objectForKey:@"items"]];
            completionBlock(works[0], nil);
        }else{
            completionBlock(nil, err);
        }
    } refresh:refresh useCacheIfNetworkFail:YES];
}

-(void)shareStylistWork:(void (^)(NSError *))completionBlock url:(NSString *)url{
    HttpRequestFacade *requestFacade = [HttpRequestFacade sharedInstance];
    [requestFacade put:url completionBlock:^(NSString *json, NSError *err) {
        NSLog(@">>>> update share work time");
    }];
}

+(NSString *)getUrlForContentSortWorks:(int)contentSortId
{
    AppStatus *as = [AppStatus sharedInstance];
    NSString * uriStr = [NSString stringWithFormat:@"/contentSorts/%d/contentList?currentPOI=%f,%f&cacheFlag=true&orderType=4", contentSortId, [as lastLng], [as lastLat]];
    return uriStr;
}

+(NSString *)getUrlForStylistWorks:(int)stylistId
{
    NSString *url = [NSString stringWithFormat:@"/works?stylistId=%d", stylistId];
    return url;
}

+(NSString *)getUrlForFavWorks:(NSString *)userId
{
    NSString *urlStr = [NSString stringWithFormat:@"/users/%@/favWorks?publishStatus=0", userId];
    return urlStr;
}


+(StylistWorkStore *)sharedStore{
    static StylistWorkStore *stylistWorkStore = nil;
    if(!stylistWorkStore){
        stylistWorkStore = [[StylistWorkStore alloc] init];
    }
    return stylistWorkStore;
}

@end
