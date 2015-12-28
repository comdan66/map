//
//  ViewController.h
//  Maps2
//
//  Created by OA Wu on 2015/12/25.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//@MKAnnotationView+WebCache
#import "MyMKAnnotationView.h"
#import "MyAnnotation.h"
#import "Marker.h"

@interface ViewController : UIViewController<MKMapViewDelegate>


@property MKMapView *mapView;

@property MyAnnotation *annotation;
@end

