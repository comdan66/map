//
//  GradientPolylineRenderer.h
//  Maps
//
//  Created by OA Wu on 2016/1/5.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface GradientPolylineRenderer : MKOverlayPathRenderer

+ (NSArray *) d4Colors;
@property NSMutableArray *colors;

@end
