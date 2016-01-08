//
//  CalculateSpeed.m
//  Maps
//
//  Created by OA Wu on 2016/1/7.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "CalculateSpeed.h"

@implementation CalculateSpeed

//static float max = -1, min = 99999;
//static NSMutableArray<UIColor *> *colors;
//static NSMutableArray<NSDictionary *> *speeds;

//+ (float) max { return max; }
//+ (void) setMax:(float)m { max = m; }
//+ (float) min { return min; }
//+ (void) setMin:(float)m { min = m; }
//+ (NSMutableArray<UIColor *> *) colors { return colors; }
//+ (void) setColors:(NSMutableArray<UIColor *> *)c { colors = c; }
//
//+ (NSMutableArray<NSDictionary *> *) speeds { return speeds; }
//+ (void) setSpeeds:(NSMutableArray<NSDictionary *> *)s { speeds = s; }


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
+ (CalculateSpeed *) calculate:(NSMutableArray *)velocity {
    CalculateSpeed *calculateSpeed = [CalculateSpeed new];
    
    [calculateSpeed setMax:[[velocity valueForKeyPath:@"@max.floatValue"] doubleValue]];
    [calculateSpeed setMin:[[velocity valueForKeyPath:@"@min.floatValue"] doubleValue]];
    
    NSArray *d4Colors = [CalculateSpeed d4Colors];
    float unit = (([d4Colors count] - 1) / calculateSpeed.max);
    
    NSMutableArray<UIColor *> *colors = [NSMutableArray new];
    for (int i = 0; i < [velocity count]; i++)
        [colors addObject:d4Colors[(unsigned int)round(unit * [velocity[i] doubleValue])]];
    [calculateSpeed setColors:colors];

    NSMutableArray<NSDictionary *> *speeds = [NSMutableArray new];
    for (int i = 0; i < [d4Colors count]; i++)
        [speeds addObject:@{
                            @"speed":[NSNumber numberWithFloat:calculateSpeed.max * 3.6 / [d4Colors count] * i],
                            @"color": d4Colors[i]
                            }];
    [calculateSpeed setSpeeds:speeds];
    
    return calculateSpeed;
}

@end
