//
//  FileOP.m
//  mobile
//
//  Created by user2 on 14-9-11.
//  Copyright (c) 2014年 Wal-Mart. All rights reserved.
//

#import "FileOP.h"

@implementation FileOP

+ (NSString *)getFilePath: (NSString *)filePath {
    
    //指向文件目录
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentDirectories[0];
    
    //NSString *fileDirectory = [documentDirectory stringByAppendingPathComponent:fileDir];
    //NSString *filePath = [fileDirectory stringByAppendingPathComponent:fileName];
    filePath = [documentDirectory stringByAppendingPathComponent:filePath];
    
    return filePath;
}

+ (BOOL)isFileExist: (NSString *)filePath {
    
    BOOL bFlag = false;
    
    filePath = [self getFilePath:filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL existed = [fileManager fileExistsAtPath:filePath];
    if ( existed == YES ) {
        bFlag = true;
    }
    
    return bFlag;
}

+ (BOOL)createFileDir: (NSString *)fileDir {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
        return true;
    }
    
    return false;
}

+ (BOOL)save: (NSString *)filePath contentArray:(NSMutableArray *)arr {
    filePath = [self getFilePath:filePath];
    if ( [NSKeyedArchiver archiveRootObject:arr toFile:filePath] ) {
        return true;
    }
    return false;
}

+ (id)read: (NSString *)filePath {
    filePath = [self getFilePath:filePath];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (NSString *)saveFileToDocuments:(NSString *)url {
    
    NSString *fileName = [url lastPathComponent];
    NSString *resultFilePath = @"";
    
    if (url.length > 7) {
        NSString *destFolderPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"map"];
        NSString *destFilePath = [destFolderPath stringByAppendingPathComponent:fileName];
        
        if (! [[NSFileManager defaultManager] fileExistsAtPath:destFolderPath]) { // check the directory exist or not
            [[NSFileManager defaultManager] createDirectoryAtPath:destFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:destFilePath]) { //check the file exist or not
            resultFilePath = destFilePath;
        } else {
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if ([imageData writeToFile:destFilePath atomically:YES]) {
                resultFilePath = destFilePath;
            } else {
                resultFilePath = destFilePath;
            }
        }
    }
    
    return resultFilePath;
}

+ (NSString*)UTF8_To_GB2312:(NSString*)utf8string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [utf8string dataUsingEncoding:encoding];

    return [[NSString alloc] initWithData:gb2312data encoding:encoding];
}

@end
