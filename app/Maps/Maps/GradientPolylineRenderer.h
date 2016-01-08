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

@property GradientPolylineOverlay *gradientOverlay;


-(id) initWithOverlay:(GradientPolylineOverlay *)overlay;

@end
