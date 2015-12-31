//
//  PathGPS.h
//  Maps
//
//  Created by OA Wu on 2015/12/30.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "GPS.h"
#import "Header.h"
#import "AFHTTPRequestOperationManager.h"
#import "Path.h"

@interface PathGPS : GPS

@property NSString *polylineId;
@property NSTimer *timer;
@property BOOL isUploadPaths;

+ (void)start:(void (^)())finish failure:(void (^)())failure;
+ (void)stop:(void (^)())finish;

//- (void)stop:(NSString *) polylineId;

@end
