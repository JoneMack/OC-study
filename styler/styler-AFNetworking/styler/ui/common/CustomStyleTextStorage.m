//
//  CustomStyleTextStorage.m
//  styler
//
//  Created by System Administrator on 14-4-3.
//  Copyright (c) 2014年 mlzj. All rights reserved.
//

#import "CustomStyleTextStorage.h"

@implementation CustomStyleTextStorage
{
    NSMutableAttributedString *_backingStore;
    NSDictionary *_replacements;
}

-(id)init
{
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
        [self createStylePatterns];
    }
    return self;
}

- (void)createStylePatterns
{
    //NSDictionary *normalAttrs = @{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    
    //普通黑色文本
    NSDictionary *normalBlack = [self createAttributes:[UIFont systemFontOfSize:default_font_size] color:[ColorUtils colorWithHexString:black_text_color] strikeThrough:NO];
    
    //普通粗体黑色文本
    NSDictionary *boldBlack = [self createAttributes:[UIFont boldSystemFontOfSize:default_font_size] color:[ColorUtils colorWithHexString:black_text_color] strikeThrough:NO];

    _replacements = @{
                      @"(-nb(.)*nb-)": normalBlack,
                      @"(-bb(.)*bb-)": boldBlack
                      };
    
    _replacements = @{
                      @"(\\*\\w+(\\s\\w+)*\\*)\\s" : normalBlack,
                      @"(_\\w+(\\s\\w+)*_)\\s" : boldBlack
                      };
}

-(void) applyStylesToRange:(NSRange)searchRange
{
    NSDictionary* normalAttrs = @{NSFontAttributeName:
                                      [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    
    for (NSString *key in _replacements) {
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:key options:0 error:nil];
        
        NSDictionary *attrs = _replacements[key];
        
        [regex enumerateMatchesInString:[_backingStore string]
                                options:0 range:searchRange usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                                    NSRange matchRange = [match rangeAtIndex:1];
                                    [self addAttributes:attrs range:matchRange];
                                    
                                    if (NSMaxRange(matchRange)+1 < self.length) {
                                        [self addAttributes:normalAttrs
                                                      range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
                                    }
                                }];
    }

}

- (NSDictionary *)createAttributes:(UIFont *)font
                             color:(UIColor *)color
                     strikeThrough:(BOOL)strikeThrough{
    if (strikeThrough) {
        return @{NSFontAttributeName: font,
          NSForegroundColorAttributeName: color,
          NSStrikethroughColorAttributeName: @1};
    }
    return @{NSFontAttributeName: font, NSForegroundColorAttributeName: color};
}

-(void) performReplacementForCharacterChangeInRange:(NSRange)changedRange
{
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    [self applyStylesToRange:extendedRange];
}

#pragma mark - NSTextStorage 可选实现的方法
-(void)processEditing
{
    [self performReplacementForCharacterChangeInRange:[self editedRange]];
}

#pragma mark - NSTextStorage 必须实现的方法
- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range
                      withString:(NSString *)str{
    [self beginEditing];
    
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedAttributes|NSTextStorageEditedCharacters range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs
                range:(NSRange)range
{
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

@end
