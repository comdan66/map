//
//  GradientPolylineOverlay.h
//  Maps
//
//  Created by OA Wu on 2016/1/5.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GradientPolylineOverlay : NSObject <MKOverlay>{
    MKMapPoint *points;
    NSUInteger pointCount;
    NSUInteger pointSpace;
    
    MKMapRect boundingMapRect;
    pthread_rwlock_t rwLock;
}
-(id) initWithCenterCoordinate:(CLLocationCoordinate2D)coord;

-(id) initWithPoints:(CLLocationCoordinate2D*)_points velocity:(float*)_velocity count:(NSUInteger)_count;
-(MKMapRect)addCoordinate:(CLLocationCoordinate2D)coord;

-(void) lockForReading;
@property (assign) MKMapPoint *points;
@property (readonly) NSUInteger pointCount;
@property (assign) float *velocity;

-(void) unlockForReading;

@end
