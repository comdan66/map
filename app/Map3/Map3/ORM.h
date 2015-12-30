//
//  ORM.h
//  Maps
//
//  Created by OA Wu on 2015/12/28.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "NSString+ActiveSupportInflector.h"
#import <objc/runtime.h>

@interface ORM : NSObject

//@property sqlite3 *db;

@property long id;

+ (BOOL)initDB;
+ (BOOL)closeDB;
+ (id)create: (NSDictionary *)params;

+ (BOOL)updateAll:(NSDictionary *) params where:(NSString *) where;
+ (BOOL)updateAll:(NSDictionary *) params;

+ (NSArray *)findAll:(NSDictionary *)conditions;
+ (NSArray *)findAll;
- (BOOL)save;

+ (id)findOne;
+ (id)findOne:(NSDictionary *)conditions;

+ (id)find:(NSDictionary *)conditions;
+ (id)find:(NSString *)type conditions:(NSDictionary *)conditions;

+ (NSMutableArray *)varList:(Class)c;

- (id)initWithId:(long) id;
- (id)init:(NSDictionary *)params;

+ (BOOL)deleteAll:(NSString *)where;
+ (BOOL)deleteAll;
- (BOOL)delete;

@end
