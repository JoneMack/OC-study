#import "UIColor+Expanded.h"

/*
 
 Thanks to Poltras, Millenomi, Eridius, Nownot, WhatAHam, jberry,
 and everyone else who helped out but whose name is inadvertantly omitted
 
*/

/* Static cache of looked up color names. Used with +colorWithName: */

@interface UIColor (Expanded_Private)

@end

@implementation UIColor (Expanded)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
	
	int r = (hex >> 16) & 0xFF;
	int g = (hex >> 8) & 0xFF;
	int b = (hex) & 0xFF;
	
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {

	if ([stringToConvert hasPrefix:@"#"]) {
		stringToConvert = [stringToConvert substringFromIndex:1];
	}
	
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	
	if (![scanner scanHexInt:&hexNum]) {
		return nil;
	}
	
	return [UIColor colorWithRGBHex:hexNum];
}

@end
