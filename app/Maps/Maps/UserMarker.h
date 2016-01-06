//
//  Marker.h
//  Maps2
//
//  Created by OA Wu on 2015/12/28.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "MyAnnotation.h"
#import "Header.h"


@interface UserMarker : UIView

+ (UserMarker *) create:(MyAnnotation *)annotation;
@end
