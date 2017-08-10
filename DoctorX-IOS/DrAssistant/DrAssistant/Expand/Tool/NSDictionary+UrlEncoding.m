

#import "NSDictionary+UrlEncoding.h"

static NSString *urlEncode(id object) {
    NSString *string = [object description];
    return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@implementation NSDictionary (UrlEncoding)

- (NSString *)urlEncodedString {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in self) {
        id value = [self objectForKey:key];
        NSString *part = [NSString stringWithFormat:@"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject:part];
    }
    return [parts componentsJoinedByString:@"&"];
}

+ (instancetype)dictionaryWithQueryString:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        if (kv.count == 2) {
            NSString *val =[kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dictionary setObject:val forKey:kv[0]];
        }
    }
    
    return dictionary;
}

@end