//
//  GPS.m
//  Maps
//
//  Created by OA Wu on 2015/12/30.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "GPS.h"

@implementation GPS

static GPS *gps;

+ (BOOL)initGPS {
    if (gps) return YES;

    gps = [[GPS alloc] initWithLocationManager];
    
    return YES;
}
+ (void)start {
    if (!gps) return;
    
    [gps start];
}
+ (void)stop {
    if (!gps) return;
    
    [gps stop];
}
- (void)start {
    [self.locationManager startUpdatingLocation];
}

- (void)stop {
    [self.locationManager stopUpdatingLocation];
}
- (id) initWithLocationManager {
    self = [super init];
    if (self) {
        self.locationManager = [CLLocationManager new];
        [self.locationManager setDelegate:self];
        [self.locationManager setDistanceFilter:0];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        [self.locationManager requestAlwaysAuthorization];
    }
    return self;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations firstObject];
    NSLog(@"------>%@", [NSString stringWithFormat:@"%f", location.coordinate.latitude]);
}
@end
