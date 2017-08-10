//  Created by 郭煜 on 13-7-20.
//  Copyright (c) 2013年 郭煜. All rights reserved.

#import "TKHelper.h"

void TKAssertSelectorNilOrImplementedWithArgs(id obj, SEL sel, ...) {
    
    // verify that the object's selector is implemented with the proper
    // number and type of arguments
#if DEBUG
    va_list argList;
    va_start(argList, sel);
    
    if (obj && sel) {
        // check that the selector is implemented
        if (![obj respondsToSelector:sel]) {
            NSLog(@"\"%@\" selector \"%@\" is unimplemented or misnamed",
                  NSStringFromClass([obj class]),
                  NSStringFromSelector(sel));
            NSCAssert(0, @"callback selector unimplemented or misnamed");
        } else {
            const char *expectedArgType;
            unsigned int argCount = 2; // skip self and _cmd
            NSMethodSignature *sig = [obj methodSignatureForSelector:sel];
            
            // check that each expected argument is present and of the correct type
            while ((expectedArgType = va_arg(argList, const char*)) != 0) {
                
                if ([sig numberOfArguments] > argCount) {
                    const char *foundArgType = [sig getArgumentTypeAtIndex:argCount];
                    
                    if(0 != strncmp(foundArgType, expectedArgType, strlen(expectedArgType))) {
                        NSLog(@"\"%@\" selector \"%@\" argument %d should be type %s",
                              NSStringFromClass([obj class]),
                              NSStringFromSelector(sel), (argCount - 2), expectedArgType);
                        NSCAssert(0, @"callback selector argument type mistake");
                    }
                }
                argCount++;
            }
            
            // check that the proper number of arguments are present in the selector
            if (argCount != [sig numberOfArguments]) {
                NSLog( @"\"%@\" selector \"%@\" should have %d arguments",
                      NSStringFromClass([obj class]),
                      NSStringFromSelector(sel), (argCount - 2));
                NSCAssert(0, @"callback selector arguments incorrect");
            }
        }
    }
    
    va_end(argList);
#endif
}


NSString * TKGenerateUUID(void)
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef theString = CFUUIDCreateString(NULL, theUUID);
	NSString *unique = [NSString stringWithString:(TK_BRIDGE id)theString];
	CFRelease(theString);
    CFRelease(theUUID);
    
	return unique;
}

NSString * TKGetiOSDocumentDirectoryPath(void)
{
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,
                                                                  YES);
	return [documentsPaths objectAtIndex:0];
}

NSString * TKGetiOSCacheDirectoryPath(void)
{
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,
                                                                  YES);
	return [documentsPaths objectAtIndex:0];
}

NSString * TKGetiOSAppDirectoryPath(void)
{
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,
                                                                  YES);
	return [[documentsPaths objectAtIndex:0] stringByDeletingLastPathComponent];
}

