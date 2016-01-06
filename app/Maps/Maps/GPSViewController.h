//
//  GPSViewController.h
//  Maps
//
//  Created by OA Wu on 2016/1/6.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CAShapeLayerAnim.h"
#import "PathGPS.h"

@interface GPSViewController : UIViewController<MKMapViewDelegate>


@property UIButton *runButton;

@property CAShapeLayerAnim *triangleLayer;
@property UIBezierPath *trianglePath, *rectanglePath;
@property float width, buttonTopConstantColse, buttonTopConstantOpen, loadLabelTopConstantColse, loadLabelTopConstantOpen;
@property NSLayoutConstraint *buttonTopConstraint, *loadLabelTopConstant, *visualTopConstant;
@property UILabel *runLabel, *loadLabel, *topLabel, *latLable, *lngLable, *speedLabel, *accuracyLabel;

@property MKMapView *mapView;

@property BOOL isOn, isMapload;

@property UIVisualEffectView *visualEffectView;

@end
