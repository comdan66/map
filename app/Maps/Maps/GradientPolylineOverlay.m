//
//  GradientPolylineOverlay.m
//  Maps
//
//  Created by OA Wu on 2016/1/5.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "GradientPolylineOverlay.h"
#import <pthread.h>

@implementation GradientPolylineOverlay

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

-(void)dealloc{
    pthread_rwlock_destroy(&rwLock);
}

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
