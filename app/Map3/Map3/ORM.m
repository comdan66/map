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
static NSString *sqlName = @"maps";

- (id)initWithId:(long) id {
    self = [super init];
    if (self) {
        [self setId:id];
    }
    return self;
}
- (id)initWithId:(long) id params:(NSDictionary *)params{
    self = [super init];
    if (self) {
        [self setId:id];

        for (NSString *key in params)
            if ([self respondsToSelector:NSSelectorFromString(key)])
                [self setValue:[params objectForKey:key] forKey:key];
    }
    return self;
}
- (id)init:(NSDictionary *)params{
    self = [super init];
    if (self)
        for (NSString *key in params)
            if ([self respondsToSelector:NSSelectorFromString(key)])
                [self setValue:[params objectForKey:key] forKey:key];
    return self;
}

+ (NSArray *)findAll:(NSDictionary *)conditions {
    if (!db) return nil;
    NSString *tableName = [[NSStringFromClass([self class]) lowercaseString] pluralizeString];
    
    NSMutableArray *select;// = [NSMutableArray new];
    conditions = [[NSMutableDictionary alloc] initWithDictionary:conditions copyItems:YES];
    
    if (![conditions objectForKey:@"select"]) {
        unsigned int count;
        select = [NSMutableArray new];
        Ivar *vars = class_copyIvarList([ORM class], &count);
        for (NSUInteger i=0; i<count; i++)
            [select addObject:[[NSString stringWithFormat:@"%s", ivar_getName(vars[i])] find:@"_" replace:@""]];
        
        
        vars = class_copyIvarList([self class], &count);
        for (NSUInteger i=0; i<count; i++)
            [select addObject:[[NSString stringWithFormat:@"%s", ivar_getName(vars[i])] find:@"_" replace:@""]];
        
        [conditions setValue:[select componentsJoinedByString:@", "] forKey:@"select"];
    } else {
        select = (NSMutableArray *)[[[conditions objectForKey:@"select"] find:@", *" replace:@","] componentsSeparatedByString:@","];
    }
    
    if ([conditions objectForKey:@"limit"] && [conditions objectForKey:@"offset"])
        [conditions setValue:[NSString stringWithFormat:@"%@,%@", [conditions objectForKey:@"offset"], [conditions objectForKey:@"limit"]] forKey:@"limit"];
    else if ([conditions objectForKey:@"limit"])
        [conditions setValue:[NSString stringWithFormat:@"%@", [conditions objectForKey:@"limit"]] forKey:@"limit"];
    else
        [conditions setValue:nil forKey:@"limit"];

    const char *selectSql = [[NSString stringWithFormat:@"SELECT %@ FROM %@%@%@%@%@%@",
                              [conditions objectForKey:@"select"] ? [conditions objectForKey:@"select"] : @"*",
                              tableName,
                              [conditions objectForKey:@"where"] ? [NSString stringWithFormat:@" WHERE %@", [conditions objectForKey:@"where"]] : @"",
                              [conditions objectForKey:@"group"] ? [NSString stringWithFormat:@" GROUP BY %@", [conditions objectForKey:@"group"]] : @"",
                              [conditions objectForKey:@"having"] ? [NSString stringWithFormat:@" HAVING %@", [conditions objectForKey:@"having"]] : @"",
                              [conditions objectForKey:@"order"] ? [NSString stringWithFormat:@" ORDER BY %@", [conditions objectForKey:@"order"]] : @"",
                              [conditions objectForKey:@"limit"] ? [NSString stringWithFormat:@" LIMIT %@", [conditions objectForKey:@"limit"]] : @""
                              ] cStringUsingEncoding:NSASCIIStringEncoding];
    
    sqlite3_stmt *statement;

    sqlite3_prepare(db, selectSql, -1, &statement, NULL);

    NSMutableArray *row = [NSMutableArray new];
    for (int i = 0; sqlite3_step(statement) == SQLITE_ROW; i++) {
        NSMutableDictionary *column = [NSMutableDictionary new];
        for (int j = 0; j < [select count]; j++) {
            [column setValue:[NSString stringWithCString:(char *)sqlite3_column_text(statement, j) encoding:NSUTF8StringEncoding] forKey:[select objectAtIndex:j]];
        }
        [row addObject:[[self alloc] init:[NSDictionary dictionaryWithDictionary:column]]];
    }
    sqlite3_finalize(statement);
    return row;
}
+ (NSArray *)findAll {
    return [self findAll:nil];
}

+ (id)find:(NSString *)type conditions:(NSDictionary *)conditions {
    if ([type isEqualToString:@"all"]) {
        return [self findAll:conditions];
    }
    return nil;
}
+ (id)find:(NSString *)type {
    if ([type isEqualToString:@"all"]) {
        return [self findAll];
    }
    return nil;
}
+ (id)create: (NSDictionary *)params {
    if (!db) return nil;
    NSString *tableName = [[NSStringFromClass([self class]) lowercaseString] pluralizeString];

    NSString *keyFields = [NSString stringWithFormat:@"'%@'", [[params allKeys] componentsJoinedByString:@"', '"]];
    NSString *valueFields = [NSString stringWithFormat:@"'%@'", [[params allValues] componentsJoinedByString:@"', '"]];

    sqlite3_stmt *statement;

    const char *sql = [[NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)", tableName, keyFields, valueFields] cStringUsingEncoding:NSASCIIStringEncoding];
    sqlite3_prepare(db, sql, -1, &statement, NULL);

    if (sqlite3_step(statement) != SQLITE_DONE)
        return nil;
    
    
    sqlite3_finalize(statement);
    
    return [[self alloc] initWithId:sqlite3_last_insert_rowid(db) params: params];
}
+ (BOOL)closeDB {
    if (!db) return YES;
    
    sqlite3_close(db);
    db = nil;
    
    if (!db) return YES;
    else return NO;
}
+ (BOOL)initDB {
    if (db) return YES;

    NSFileManager *fm = [NSFileManager new];
    NSString *src = [[NSBundle mainBundle] pathForResource:sqlName ofType:@"sqlite"];
    NSString *dst = [NSString stringWithFormat:@"%@/Documents/%@.sqlite", NSHomeDirectory(), sqlName];
    
    if ([fm fileExistsAtPath:dst])
        [fm removeItemAtPath:dst error:nil];
    
    [fm copyItemAtPath:src toPath:dst error:nil];
    
    if (![fm fileExistsAtPath:dst]) return NO;
    if (sqlite3_open([dst UTF8String], &db) != SQLITE_OK) db = nil;

    return YES;
}
@end
