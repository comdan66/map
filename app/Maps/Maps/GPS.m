//
//  GPS.m
//  Maps
//
//  Created by OA Wu on 2015/12/30.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "GPS.h"

@implementation GPS

static id gps;

+ (BOOL)initGPS {
    if (gps) return YES;

    gps = [[[self class] alloc] initWithLocationManager];
    
    return YES;
}
+ (id)gps {
    return gps;
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

//
//
@end
