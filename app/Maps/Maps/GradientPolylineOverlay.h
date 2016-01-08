//
//  GradientPolylineOverlay.h
//  Maps
//
//  Created by OA Wu on 2016/1/5.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CalculateSpeed.h"

@interface GradientPolylineOverlay : NSObject <MKOverlay> {
    MKMapRect boundingMapRect;
    pthread_rwlock_t rwLock;
}
@property NSMutableArray<CLLocation *> *locations;
@property CalculateSpeed *calculate;

-(id) initWithLocations:(NSMutableArray<CLLocation *> *) locations calculate:(CalculateSpeed *)c;
-(void) lockForReading;
-(void) unlockForReading;

@end
