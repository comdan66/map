//
//  GPS.h
//  Maps
//
//  Created by OA Wu on 2015/12/30.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface GPS : CLLocation<CLLocationManagerDelegate>

@property CLLocationManager *locationManager;

+ (BOOL)initGPS;
+ (void)start;
+ (void)stop;
- (id) initWithLocationManager;
- (void)start;
- (void)stop;
@end
