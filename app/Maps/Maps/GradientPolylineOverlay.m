//
//  GradientPolylineOverlay.m
//  Maps
//
//  Created by OA Wu on 2016/1/5.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "GradientPolylineOverlay.h"
#import <pthread.h>

#define INITIAL_POINT_SPACE 1000
#define MINIMUM_DELTA_METERS 10.0

@implementation GradientPolylineOverlay

//@synthesize points, pointCount, velocity;

//-(id) initWithCenterCoordinate:(CLLocationCoordinate2D)coord{
//    self = [super init];
//
//    if (self){
//        pointSpace = INITIAL_POINT_SPACE;
//        points = malloc(sizeof(MKMapPoint) * pointSpace);
//        points[0] = MKMapPointForCoordinate(coord);
//        pointCount = 1;
//        
//        MKMapPoint origin = points[0];
//        origin.x -= MKMapSizeWorld.width / 8.0f;
//        origin.y -= MKMapSizeWorld.height / 8.0f;
//        MKMapSize size = MKMapSizeWorld;
//        size.width /= 4.0f;
//        size.height /= 4.0f;
//        boundingMapRect = (MKMapRect) {origin, size};
//        MKMapRect worldRect = MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height);
//        boundingMapRect = MKMapRectIntersection(boundingMapRect, worldRect);
//        
//        pthread_rwlock_init(&rwLock,NULL);
//    }
//    return self;
//}
-(id) initWithCoordinates:(NSMutableArray<CLLocation *> *) coordinates {
    self = [super init];
    if (self){
        self.points = coordinates;

        MKMapPoint origin = MKMapPointForCoordinate([self.points firstObject].coordinate);
        origin.x -= MKMapSizeWorld.width / 8.0f;
        origin.y -= MKMapSizeWorld.height / 8.0f;
        MKMapSize size = MKMapSizeWorld;
        size.width /= 4.0f;
        size.height /= 4.0f;
        boundingMapRect = (MKMapRect) {origin, size};
        MKMapRect worldRect = MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height);
        boundingMapRect = MKMapRectIntersection(boundingMapRect, worldRect);

        pthread_rwlock_init(&rwLock,NULL);
    }
    return self;
}
//-(id) initWithPoints:(CLLocationCoordinate2D *)_points velocity:(float *)_velocity count:(NSUInteger)_count{
//    self = [super init];
//
//    if (self){
//        pointCount = _count;
//        self.points = malloc(sizeof(MKMapPoint) * pointCount);
//        
//        for (int i=0; i < _count; i++) self.points[i] = MKMapPointForCoordinate(_points[i]);
//
//        self.velocity = malloc(sizeof(float) * pointCount);
//        for (int i=0; i < _count;i++) self.velocity[i] = _velocity[i];
//        
//        MKMapPoint origin = points[0];
//        origin.x -= MKMapSizeWorld.width / 8.0f;
//        origin.y -= MKMapSizeWorld.height / 8.0f;
//        MKMapSize size = MKMapSizeWorld;
//        size.width /= 4.0f;
//        size.height /= 4.0f;
//        boundingMapRect = (MKMapRect) {origin, size};
//        MKMapRect worldRect = MKMapRectMake(0, 0, MKMapSizeWorld.width, MKMapSizeWorld.height);
//        boundingMapRect = MKMapRectIntersection(boundingMapRect, worldRect);
//
//        pthread_rwlock_init(&rwLock,NULL);
//    }
//    return self;
//}

-(void)dealloc{
    pthread_rwlock_destroy(&rwLock);
}

//center
-(CLLocationCoordinate2D)coordinate{
    return [self.points firstObject].coordinate;
}

-(MKMapRect)boundingMapRect{
    return boundingMapRect;
}

-(void) lockForReading{
    pthread_rwlock_rdlock(&rwLock);
}

-(void) unlockForReading{
    pthread_rwlock_unlock(&rwLock);
}
@end
