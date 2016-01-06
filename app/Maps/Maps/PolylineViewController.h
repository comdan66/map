//
//  PolylineViewController.h
//  Maps
//
//  Created by OA Wu on 2016/1/4.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Header.h"
#import "AFHTTPRequestOperationManager.h"
#import "GradientPolylineOverlay.h"
#import "GradientPolylineRenderer.h"
#import "MyAnnotation.h"
#import "UserMarker.h"

@interface PolylineViewController : UIViewController<MKMapViewDelegate>

@property NSString *id;
@property MKMapView *mapView;
@property UIButton *myLocationButton, *uLocationButton;
@property BOOL isLoadData;

@property MyAnnotation *user;

@property NSTimer *timer;

-(PolylineViewController *)initWithId:(NSString *)id;
@end
