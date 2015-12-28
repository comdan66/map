//
//  MyAnnotation.h
//  Maps
//
//  Created by OA Wu on 2015/12/25.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>

@property CLLocationCoordinate2D coordinate;

-(id) initWithLocation:(CLLocationCoordinate2D) coord;
@property (nonatomic) NSURL *imageUrl;

@end
