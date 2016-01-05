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

@interface PolylineViewController : UIViewController<MKMapViewDelegate>

@property NSString *id;
@property MKMapView *mapView;
@property UIButton *myLocationButton, *uLocationButton;
@property BOOL isLoadData;

-(PolylineViewController *)initWithId:(NSString *)id;
@end
