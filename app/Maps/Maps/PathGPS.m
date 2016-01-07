//
//  PathGPS.m
//  Maps
//
//  Created by OA Wu on 2015/12/30.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "PathGPS.h"

@implementation PathGPS

+ (void)start:(CLLocationCoordinate2D)coordinate success:(void (^)())finish failure:(void (^)())failure gps:(GPSViewController *)gpsCtr {
    if (DEV) NSLog(@"------->start!");
//    [Path clean];

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"name"];
    [data setValue:[NSString stringWithFormat:@"%f", coordinate.latitude] forKey:@"lat"];
    [data setValue:[NSString stringWithFormat:@"%f", coordinate.longitude] forKey:@"lng"];
    [data setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"ct"];

    if (DEV) NSLog(@"------->create polyline!");
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager POST:[NSString stringWithFormat:API_POST_USER_CREATE_POLYLINE, USER_ID]
           parameters:data
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [super start];
                  
                  PathGPS *gps = [super gps];
                  [gps setPolylineId:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"id"]]];
                  gps.gpsControler = gpsCtr;
                  
                  if (gps.timer) {
                      [gps.timer invalidate];
                      gps.timer = nil;
                      gps.isUploadPaths = NO;
                  }
                  
                  gps.timer = [NSTimer scheduledTimerWithTimeInterval:UPLOAD_PATHS_TIMER target:gps selector:@selector(fetch) userInfo:nil repeats:YES];
                  
                  finish();
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (failure) failure();
              }
     ];
}

- (void)fetch {
    [self uploadPaths:nil];
}
- (void) uploadPaths:(void (^)())finish {
    if (self.isUploadPaths) {
        if (finish) finish();
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
                  if (DEV) NSLog(@"=======>Success!");

                  if ((int)[(NSArray *)[responseObject objectForKey:@"ids"] count] > 0)
                      [Path deleteAll:[NSString stringWithFormat:@"id IN (%@)", [[responseObject objectForKey:@"ids"] componentsJoinedByString:@", "]]];
                  
                      [((GPSViewController *)self.gpsControler) rotateSpinningView];
                  
                  if (finish) finish();
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  self.isUploadPaths = NO;
                  if (DEV) NSLog(@"=======>Failure!Error:%@", [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]);
                  
                  if (finish) finish();
              }
     ];
}
- (void) finish:(void (^)())finish {
    if (DEV) NSLog(@"=======>Finish!");
    if (!self.polylineId) return finish();
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager POST:[NSString stringWithFormat:API_POST_USER_FINISH_POLYLINE, USER_ID, (int)[self.polylineId integerValue]]
           parameters:[NSMutableDictionary new]
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (DEV) NSLog(@"=======>Finish success!");
                  if (finish) finish();
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (DEV) NSLog(@"=======>Finish failure!Error:%@", [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding]);
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
    
    [((GPSViewController *)self.gpsControler).lngLable setText:[NSString stringWithFormat:@"經度：%.5f", location.coordinate.latitude]];
    [((GPSViewController *)self.gpsControler).latLable setText:[NSString stringWithFormat:@"緯度：%.5f", location.coordinate.longitude]];
    [((GPSViewController *)self.gpsControler).speedLabel setText:[NSString stringWithFormat:@"速度：%.3f Km/H", location.speed]];
    [((GPSViewController *)self.gpsControler).accuracyLabel setText:[NSString stringWithFormat:@"準度：%.1f 公尺", location.horizontalAccuracy]];
    [((GPSViewController *)self.gpsControler).mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.02, 0.02)) animated:YES];
}
@end
