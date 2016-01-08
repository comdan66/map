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
#import "CalculateSpeed.h"
#import "GradientPolylineOverlay.h"
#import "GradientPolylineRenderer.h"

@interface GPSViewController : UIViewController<MKMapViewDelegate>


@property UIButton *runButton;

@property CAShapeLayerAnim *runLabelLayer;
@property UIBezierPath *trianglePath, *rectanglePath;
@property float width, speedsLabelHeight, buttonTopConstantColse, buttonTopConstantOpen, loadLabelTopConstantColse, loadLabelTopConstantOpen;
@property NSLayoutConstraint *buttonTopConstraint, *speedsLabelTopConstraint, *loadLabelTopConstant, *visualTopConstant;
@property UILabel *runLabel, *ballLabel, *speedsLabel, *loadLabel, *topLabel, *latLable, *lngLable, *speedLabel, *accuracyLabel;

@property MKMapView *mapView;
@property NSMutableArray<UILabel *> *colorLabels;
@property BOOL isOn, isMapload;

@property UIVisualEffectView *visualEffectView;
- (void)rotateSpinningView;
- (void)setMap:(NSArray *)paths;
@end
