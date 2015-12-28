//
//  MyAnnotation.m
//  Maps
//
//  Created by OA Wu on 2015/12/25.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate, imageUrl;

-(id)initWithLocation:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

@end
