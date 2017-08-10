

#import <Foundation/Foundation.h>

@interface NSDictionary (UrlEncoding)
- (NSString *)urlEncodedString;
+ (instancetype)dictionaryWithQueryString:(NSString *)query;
@end
