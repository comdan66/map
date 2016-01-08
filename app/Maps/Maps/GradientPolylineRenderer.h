//
//  GradientPolylineRenderer.h
//  Maps
//
//  Created by OA Wu on 2016/1/5.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <pthread.h>
#import "GradientPolylineOverlay.h"
#import "CalculateSpeed.h"

@interface GradientPolylineRenderer : MKOverlayPathRenderer

//+ (NSArray *) d4Colors;
//@property NSMutableArray *colors;
-(id) initWithOverlay:(GradientPolylineOverlay *)overlay;

@property GradientPolylineOverlay *gradientPolylineOverlay;
//@property NSMutableArray<MKMapPoint *> *point;

@end
