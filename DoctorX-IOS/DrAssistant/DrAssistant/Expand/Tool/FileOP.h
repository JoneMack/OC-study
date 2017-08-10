//
//  FileOP.h
//  mobile
//
//  Created by user2 on 14-9-11.
//  Copyright (c) 2014年 Wal-Mart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOP : NSObject

+ (BOOL)isFileExist: (NSString *)filePath;

+ (BOOL)createFileDir: (NSString *)fileDir;

+ (BOOL)save: (NSString *)filePath contentArray:(NSMutableArray *)arr;

+ (id)read: (NSString *)filePath;

+ (NSString *)saveFileToDocuments:(NSString *)url;

@end
