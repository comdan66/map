//
//  ViewController.m
//  Map3
//
//  Created by OA Wu on 2015/12/28.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    for (int i = 0; i < 100; i++) {
        [Path create:@{@"lat": [NSString stringWithFormat:@"%d", i],
                       @"lng": @"13",
                       @"al": @"14",
                       @"ah": @"11",
                       @"av": @"23",
                       @"sd": @"42",
                       @"ct": @"2015-12-28 10:12:13"}];
    }
    
    
    NSArray *paths = [Path find:@"all" conditions:@{
                                                    @"select": @"id,lat, lng, al",
                                                    @"where": @"id > 2",
                                                    @"offset": @1,
                                                    @"limit": @"2"
                                                    }];
    
    NSLog(@"%@", paths);
    
    
//
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//    
//    
//    
//    
//    
//    sqlite3_stmt *statement;
//    
//    //    insert
//    for (int i = 0; i < 100; i++) {
//        const char *sql = [[NSString stringWithFormat:@"INSERT INTO paths ('lat', 'lng', 'al', 'ah', 'av', 'sd', 'ct') VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@')", @"12", @"13", @"14", @"100", @"20", @"10", @"2015-12-28 10:12:13"] cStringUsingEncoding:NSASCIIStringEncoding];
//        sqlite3_prepare([app getDB], sql, -1, &statement, NULL);
//        
//        if (sqlite3_step(statement) == SQLITE_DONE)
//            NSLog(@"存入資料庫成功！");
//        else
//            NSLog(@"存入資料庫失敗！");
//        
//    }
//
//    
//    
////    Count
//    const char *countSql = [[NSString stringWithFormat:@"SELECT COUNT(id) FROM paths"] cStringUsingEncoding:NSASCIIStringEncoding];
//    sqlite3_prepare([app getDB], countSql, -1, &statement, NULL);
//        
//    while (sqlite3_step(statement) == SQLITE_ROW) {
//        char *count = (char *)sqlite3_column_text(statement, 0);
//        NSLog(@"%d", (int)[[NSString stringWithCString:count encoding:NSUTF8StringEncoding] integerValue]);
//    }
//    
////    Select
//    const char *selectSql = [[NSString stringWithFormat:@"SELECT * FROM paths ORDER BY id ASC"] cStringUsingEncoding:NSASCIIStringEncoding];
//    sqlite3_prepare([app getDB], selectSql, -1, &statement, NULL);
//    
//    NSMutableArray *array = [NSMutableArray array];
////    NSMutableDictionary *data = [NSMutableDictionary new];
//    
//    for (int i = 0; sqlite3_step(statement) == SQLITE_ROW; i++) {
//        NSString *id = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
//        NSString *lat = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 1) encoding:NSUTF8StringEncoding];
//        NSString *lng = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 2) encoding:NSUTF8StringEncoding];
//        NSString *al = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding];
//        NSString *ah = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 4) encoding:NSUTF8StringEncoding];
//        NSString *av = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding];
//        NSString *sd = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding];
//        NSString *ct = [NSString stringWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding];
//
//        NSLog(@"%@", id);
//        [array addObject:@{
//                           @"id": id,
//                           @"lat": lat,
//                           @"lng": lng,
//                           @"al": al,
//                           @"ah": ah,
//                           @"av": av,
//                           @"sd": sd,
//                           @"ct": ct,
//                           }];
////        [data setValue:id forKey:[NSString stringWithFormat:@"paths[%d][id]", i]];
//    }
//    NSLog(@"=================");
//    NSLog(@"%@", array);
//    
//    sqlite3_finalize(statement);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
