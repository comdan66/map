//
//  MyAnnotation.h
//  CustomAnnotation
//
//  Created by Joeswind on 2014/8/7.
//  Copyright (c) 2014年 Joeswind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>

// 可根據MKAnnotation的規範，直接複製過來
@property CLLocationCoordinate2D coordinate;

-(id) initWithLocation:(CLLocationCoordinate2D) coord;

@property (nonatomic) UIImage *image;
@end
