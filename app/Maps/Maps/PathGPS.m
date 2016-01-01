//
//  PathGPS.m
//  Maps
//
//  Created by OA Wu on 2015/12/30.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "PathGPS.h"

@implementation PathGPS

- (void)fetch {
    [self uploadPaths:nil];
}
- (void) uploadPaths:(void (^)())finish {
    if (self.isUploadPaths) {
        if (![finish isKindOfClass:[NSTimer class]] && finish) finish();
        return;
    }
    self.isUploadPaths = YES;

    if (DEV) NSLog(@"=======>uploadPaths!");

    NSArray *paths = [Path findAll: @{
         @"limit": @"30"
     }];
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    int i = 0;
    for (Path* path in paths)
        [parameters setValue:[path toDictionary] forKey:[NSString stringWithFormat:@"%d", i++]];

    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setValue:parameters forKey:@"paths"];
    if (DEV) NSLog(@"=======>url:%@", [NSString stringWithFormat:API_POST_POLYLINES_PAYHS, (int)[self.polylineId integerValue]]);
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager POST:[NSString stringWithFormat:API_POST_POLYLINES_PAYHS, (int)[self.polylineId integerValue]]
           parameters:data
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  self.isUploadPaths = NO;
                  if ([[responseObject objectForKey:@"status"] boolValue])
                      if ((int)[(NSArray *)[responseObject objectForKey:@"ids"] count] > 0)
                          [Path deleteAll:[NSString stringWithFormat:@"id IN (%@)", [[responseObject objectForKey:@"ids"] componentsJoinedByString:@", "]]];
                  if (DEV) NSLog(@"=======>Success!");
                  if (![finish isKindOfClass:[NSTimer class]] && finish) finish();
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  self.isUploadPaths = NO;
                  if (DEV) NSLog(@"=======>Failure!Error:%@", [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]);
                  if (![finish isKindOfClass:[NSTimer class]] && finish) finish();
              }
     ];
}
- (void) finish:(void (^)())finish {
    if (!self.polylineId)
        return finish();
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager POST:[NSString stringWithFormat:API_GET_USER_FINISH_POLYLINE, USER_ID, (int)[self.polylineId integerValue]]
           parameters:[NSMutableDictionary new]
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (finish) finish();
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (finish) finish();
              }
     ];
}
+ (void)start:(void (^)())finish failure:(void (^)())failure {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"name"];

    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager POST:[NSString stringWithFormat:API_GET_USER_CREATE_POLYLINE, USER_ID]
          parameters:data
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (![[responseObject objectForKey:@"status"] boolValue])
                     return failure();

                 [super start];
                 
                 PathGPS *gps = [super gps];
                 [gps setPolylineId:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"id"]]];
                 
                 if (gps.timer) {
                     [gps.timer invalidate];
                     gps.timer = nil;
                     gps.isUploadPaths = NO;
                 }

                 gps.timer = [NSTimer scheduledTimerWithTimeInterval:UPLOAD_PATHS_TIMER target:gps selector:@selector(fetch) userInfo:nil repeats:YES];
                 
                 finish();
             }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (finish) finish();
              }
     ];
}
+ (void)stop:(void (^)()) finish {
    [super stop];
    PathGPS *gps = [super gps];

    if (gps.timer) {
        [gps.timer invalidate];
        gps.timer = nil;
        gps.isUploadPaths = NO;
    }

    [gps uploadPaths:^{
        [gps finish:finish];
    }];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations firstObject];

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    [Path create:@{
                   @"lat": [NSString stringWithFormat:@"%f", location.coordinate.latitude],
                   @"lng": [NSString stringWithFormat:@"%f", location.coordinate.longitude],
                   @"al": [NSString stringWithFormat:@"%f", location.altitude],
                   @"ah": [NSString stringWithFormat:@"%f", location.horizontalAccuracy],
                   @"av": [NSString stringWithFormat:@"%f", location.verticalAccuracy],
                   @"sd": [NSString stringWithFormat:@"%f", location.speed],
                   @"ct": [dateFormatter stringFromDate:[NSDate date]]
                   }];
    if (DEV) NSLog(@"=======>Location: %@, %@", [NSString stringWithFormat:@"%f", location.coordinate.latitude], [NSString stringWithFormat:@"%f", location.coordinate.longitude]);
}
@end
