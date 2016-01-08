//
//  GradientPolylineRenderer.m
//  Maps
//
//  Created by OA Wu on 2016/1/5.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "GradientPolylineRenderer.h"

@implementation GradientPolylineRenderer{
    pthread_rwlock_t rwLock;
}

-(id) initWithOverlay:(GradientPolylineOverlay *)overlay {
    self = [super initWithOverlay:overlay];
    
    if (self) {
        pthread_rwlock_init(&rwLock,NULL);
        
        self.gradientOverlay = overlay;
        [self createPath];
    }
    return self;
}

-(void) createPath{
    CGMutablePathRef path = CGPathCreateMutable();
    BOOL pathIsEmpty = YES;

    for (int i = 0; i < [self.gradientOverlay.locations count]; i++) {
        CGPoint point = [self pointForMapPoint:MKMapPointForCoordinate ([self.gradientOverlay.locations objectAtIndex:i].coordinate)];

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

-(void)dealloc{
    pthread_rwlock_destroy(&rwLock);
}
-(void) drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context{
    CGRect pointsRect = CGPathGetBoundingBox(self.path);
    CGRect mapRectCG = [self rectForMapRect:mapRect];
    if (!CGRectIntersectsRect(pointsRect, mapRectCG))return;

    UIColor *pcolor, *ccolor;
    for (int i = 0; i < [self.gradientOverlay.locations count]; i++) {
        CGPoint point = [self pointForMapPoint:MKMapPointForCoordinate ([self.gradientOverlay.locations objectAtIndex:i].coordinate)];
        CGMutablePathRef path = CGPathCreateMutable();
        ccolor = [self.gradientOverlay.calculate.colors objectAtIndex:i];

        if (i == 0){
            CGPathMoveToPoint(path, nil, point.x, point.y);
        } else {
            CGPoint prevPoint = [self pointForMapPoint:MKMapPointForCoordinate ([self.gradientOverlay.locations objectAtIndex:i - 1].coordinate)];
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
