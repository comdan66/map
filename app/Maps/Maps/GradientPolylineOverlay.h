//
//  GradientPolylineOverlay.h
//  Maps
//
//  Created by OA Wu on 2016/1/5.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GradientPolylineOverlay : NSObject <MKOverlay> {
    MKMapRect boundingMapRect;
    pthread_rwlock_t rwLock;
}
@property NSMutableArray<CLLocation *> *points;

-(id) initWithCoordinates:(NSMutableArray *) coordinates;
-(void) lockForReading;
-(void) unlockForReading;
@end
