//
//  MapViewController.h
//  Maps
//
//  Created by OA Wu on 2015/12/23.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "UIAlertView+Blocks.h"
#import "Header.h"

@interface MapViewController : ViewController <MKMapViewDelegate>

@property MKMapView *mapView;

@property UIAlertController *alert;
@property MKPointAnnotation *user;
@property MKPolyline *line;
@property BOOL isLoadData;
@property BOOL isAlert;
@property NSTimer *timer;

@end
