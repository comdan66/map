//
//  CAShapeLayerAnim.m
//  Maps
//
//  Created by OA Wu on 2016/1/6.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "CAShapeLayerAnim.h"

@implementation CAShapeLayerAnim

- (id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"path"]) {
        CABasicAnimation *animation = [CABasicAnimation
                                       animationWithKeyPath:event];
        animation.duration = [CATransaction animationDuration];
        animation.timingFunction = [CATransaction
                                    animationTimingFunction];
        return animation;
    }
    return [super actionForKey:event];
}
@end
