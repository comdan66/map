//
//  GradientPolylineRenderer.m
//  Maps
//
//  Created by OA Wu on 2016/1/5.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "GradientPolylineRenderer.h"
#import <pthread.h>
#import "GradientPolylineOverlay.h"

@implementation GradientPolylineRenderer{
    pthread_rwlock_t rwLock;
    GradientPolylineOverlay* polyline;
}
+ (NSArray *) d4Colors {
    return [[NSArray alloc] initWithObjects:
            [UIColor colorWithRed:0.8 green:0.867 blue:1 alpha:1],
            [UIColor colorWithRed:0.6 green:0.733 blue:1 alpha:1],
            [UIColor colorWithRed:0.333 green:0.6 blue:1 alpha:1],
            [UIColor colorWithRed:0 green:0.4 blue:1 alpha:1],
            [UIColor colorWithRed:0 green:0.267 blue:0.733 alpha:1],
            [UIColor colorWithRed:0 green:0.235 blue:0.616 alpha:1],
            [UIColor colorWithRed:0 green:0.2 blue:0.467 alpha:1],
            [UIColor colorWithRed:0.333 green:0 blue:0.533 alpha:1],
            [UIColor colorWithRed:0.467 green:0 blue:0.467 alpha:1],nil];
}

-(id) initWithOverlay:(id<MKOverlay>)overlay{
    self = [super initWithOverlay:overlay];
    if (self){
        pthread_rwlock_init(&rwLock,NULL);
        polyline = ((GradientPolylineOverlay*)self.overlay);
        [self velocity:polyline.velocity count:(int)polyline.pointCount];
        [self createPath];
    }
    return self;
}

-(void) velocity:(float*)velocity count:(int)count{
    float max = -1, min = 99999;

    for (int i = 0; i < count; i++) {
        if (max < velocity[i]) max = velocity[i];
        if ((velocity[i] > 0) && (min > velocity[i])) min = velocity[i];
    }

    NSArray *colors = [GradientPolylineRenderer d4Colors];

    self.colors = [NSMutableArray new];
    float temp = (([colors count] - 1) / max);
    for (int i = 0; i < count; i++) [self.colors addObject:colors[(unsigned int)round(temp * velocity[i])]];
}

-(void) createPath{
    CGMutablePathRef path = CGPathCreateMutable();
    BOOL pathIsEmpty = YES;

    for (int i = 0; i < polyline.pointCount; i++) {
        CGPoint point = [self pointForMapPoint:polyline.points[i]];
        if (pathIsEmpty){
            CGPathMoveToPoint(path, nil, point.x, point.y);
            pathIsEmpty = NO;
        } else {
            CGPathAddLineToPoint(path, nil, point.x, point.y);
        }
    }
    
    pthread_rwlock_wrlock(&rwLock);
    self.path = path;
    pthread_rwlock_unlock(&rwLock);
}

//-(BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale{
//    CGRect pointsRect = CGPathGetBoundingBox(self.path);
//    CGRect mapRectCG = [self rectForMapRect:mapRect];
//    return CGRectIntersectsRect(pointsRect, mapRectCG);
//}


-(void) drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context{
    CGRect pointsRect = CGPathGetBoundingBox(self.path);
    CGRect mapRectCG = [self rectForMapRect:mapRect];
    if (!CGRectIntersectsRect(pointsRect, mapRectCG))return;

    UIColor *pcolor, *ccolor;
    for (int i = 0; i < polyline.pointCount; i++) {
        CGPoint point = [self pointForMapPoint:polyline.points[i]];
        CGMutablePathRef path = CGPathCreateMutable();
        ccolor = self.colors[i];

        if (i == 0){
            CGPathMoveToPoint(path, nil, point.x, point.y);
        } else {
            CGPoint prevPoint = [self pointForMapPoint:polyline.points[i-1]];
            CGPathMoveToPoint(path, nil, prevPoint.x, prevPoint.y);
            CGPathAddLineToPoint(path, nil, point.x, point.y);
            
            CGFloat pc_r, pc_g, pc_b, pc_a, cc_r, cc_g, cc_b, cc_a;
            
            [pcolor getRed:&pc_r green:&pc_g blue:&pc_b alpha:&pc_a];
            [ccolor getRed:&cc_r green:&cc_g blue:&cc_b alpha:&cc_a];
            
            CGFloat gradientColors[8] = {pc_r, pc_g, pc_b, pc_a, cc_r, cc_g, cc_b, cc_a};
            
            CGFloat gradientLocation[2] = {0,1};
            CGContextSaveGState(context);
            CGFloat lineWidth = CGContextConvertSizeToUserSpace(context, (CGSize){self.lineWidth,self.lineWidth}).width;
            CGPathRef pathToFill = CGPathCreateCopyByStrokingPath(path, NULL, lineWidth, self.lineCap, self.lineJoin, self.miterLimit);
            CGContextAddPath(context, pathToFill);
            CGContextClip(context);
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradientColors, gradientLocation, 2);
            CGColorSpaceRelease(colorSpace);
            CGPoint gradientStart = prevPoint;
            CGPoint gradientEnd = point;
            CGContextDrawLinearGradient(context, gradient, gradientStart, gradientEnd, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            CGContextRestoreGState(context);
        }
        pcolor = [UIColor colorWithCGColor:ccolor.CGColor];
    }
}
@end
