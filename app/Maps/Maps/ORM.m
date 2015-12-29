//
//  ORM.m
//  Maps
//
//  Created by OA Wu on 2015/12/28.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "ORM.h"

@implementation ORM

static sqlite3 *db = nil;

+ (BOOL)initDB {
    if (db)
        return YES;

    NSFileManager *fm = [NSFileManager new];
    NSString *src = [[NSBundle mainBundle] pathForResource:@"Maps" ofType:@"sqlite"];
    NSString *dst = [NSString stringWithFormat:@"%@/Documents/Maps.sqlite", NSHomeDirectory()];
    
    if ([fm fileExistsAtPath:dst])
        [fm removeItemAtPath:dst error:nil];
    
    [fm copyItemAtPath:src toPath:dst error:nil];
    
    if (![fm fileExistsAtPath:dst])
        return NO;

    if (sqlite3_open([dst UTF8String], &db) != SQLITE_OK)
        db = nil;

    return YES;
}
@end
