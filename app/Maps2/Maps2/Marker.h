//
//  Marker.h
//  Maps2
//
//  Created by OA Wu on 2015/12/28.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface Marker : UIView

+ (Marker *) create;
@end
