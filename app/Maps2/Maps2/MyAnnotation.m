//
//  MyAnnotation.m
//  CustomAnnotation
//
//  Created by Joeswind on 2014/8/7.
//  Copyright (c) 2014年 Joeswind. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

@synthesize coordinate, image;

-(id)initWithLocation:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

@end
