//
//  CalculateSpeed.h
//  Maps
//
//  Created by OA Wu on 2016/1/7.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CalculateSpeed : NSObject

+ (float) max;
+ (void) setMax:(float)m;
+ (float) min;
+ (void) setMin:(float)m;
+ (NSMutableArray<UIColor *> *) colors;
+ (void) setColors:(NSMutableArray<UIColor *> *)c;

+ (NSArray *) d4Colors;
+ (void) calculate:(NSMutableArray *)velocity;

+ (NSMutableArray<NSDictionary *> *) speeds;
+ (void) setSpeeds:(NSMutableArray<NSDictionary *> *)s;
@end
