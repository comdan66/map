//
//  GpsViewController.h
//  Maps
//
//  Created by OA Wu on 2015/12/23.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Header.h"
#import "AFHTTPRequestOperationManager.h"
#import "MemoView.h"
#import "MyAnnotation.h"
#import "Marker.h"
#import "PathGPS.h"

@interface GpsViewController : UIViewController <MKMapViewDelegate>

//@property NSString *polylineId;

@property UISwitch *switchButton;
@property UILabel *switchLabel;
@property UIStepper *stepperButton;
@property UILabel *stepperLabel;
@property UILabel *horizontalDivider1;
@property UILabel *horizontalDivider2;
@property MKMapView *mapView;
@property MemoView *memo;
@property MKPointAnnotation *point;

@property MyAnnotation *user;
@property MKPolyline *line;
@property BOOL isLoadData;
@property NSTimer *timer;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;

@end
