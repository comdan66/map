//
//  GpsViewController.m
//  Maps
//
//  Created by OA Wu on 2015/12/23.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "GpsViewController.h"

@interface GpsViewController ()

@end

@implementation GpsViewController
+ (BOOL) isDebug {
    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [self initSwitchButton];
    [self initSwitchLabel];
    [self initStepperButton];
    [self initStepperLabel];
    [self initHorizontalDivider1];
    [self initHorizontalDivider2];
    [self initMapView];
    
//    if ([CLLocationManager locationServicesEnabled] )
//    {
//        if (self.locationManager == nil )
//        {
//            self.locationManager = [[CLLocationManager alloc] init];
//            self.locationManager.delegate = self;
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
////            self.locationManager.distanceFilter = kDistanceFilter; //kCLDistanceFilterNone// kDistanceFilter;
//        }
//        
//        [self.locationManager startUpdatingLocation];
//    }
//    
    // 設定在台北的大頭針
//    self.point = [[MKPointAnnotation alloc]init];
//    self.point.coordinate = CLLocationCoordinate2DMake(25.0335, 121.5651);
//    self.point.title = @"台北市";
//    self.point.subtitle = @"中華民國首都";
//    [self.mapView addAnnotation:self.point];

    
//    [self performSelector:@selector(hideClick2) withObject:nil afterDelay:2.0f];
}
//- (void)hideClick2 {
//    self.point.coordinate = CLLocationCoordinate2DMake(25.0235, 121.5651);
//    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(25.0235, 121.5651), MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
//}



- (void)initSwitchButton {
    self.switchButton = [UISwitch new];
    [self.switchButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.switchButton addTarget:self action:@selector(switchChangeAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.switchButton];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:20]];
}
- (void)initSwitchLabel {
    self.switchLabel = [UILabel new];
    
    [self.switchLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.switchLabel setText:@"關閉"];
    
    if ([GpsViewController isDebug]) {
        [self.switchLabel.layer setBorderColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor];
        [self.switchLabel.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
    }
    
    [self.view addSubview:self.switchLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.switchButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.switchLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.switchButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}
- (void)initStepperButton {
    self.stepperButton = [UIStepper new];
    [self.stepperButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.stepperButton setMaximumValue:100];
    [self.stepperButton setMinimumValue:0];
    [self.stepperButton setStepValue:5];
    [self.stepperButton addTarget:self action:@selector(stepperChangedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.stepperButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.stepperButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.switchButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.stepperButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-20]];
}
- (void)initStepperLabel {
    self.stepperLabel = [UILabel new];
    
    [self.stepperLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.stepperLabel setText:@"0 公尺"];
    [self.stepperLabel setTextAlignment:NSTextAlignmentRight];
    
    if ([GpsViewController isDebug]) {
        [self.stepperLabel.layer setBorderColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1].CGColor];
        [self.stepperLabel.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
    }
    [self.view addSubview:self.stepperLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.stepperLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.stepperLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:80.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.stepperLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.stepperButton attribute:NSLayoutAttributeLeading multiplier:1 constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.stepperLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.stepperButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}
- (void)initHorizontalDivider1 {
    self.horizontalDivider1 = [UILabel new];
    [self.horizontalDivider1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.horizontalDivider1 setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8f]];
    
    [self.horizontalDivider1.layer setShadowColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor];
    [self.horizontalDivider1.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.horizontalDivider1.layer setShadowRadius:1.0f];
    [self.horizontalDivider1.layer setShadowOpacity:1.0f];
    [self.horizontalDivider1.layer setZPosition:2];
    
    [self.view addSubview:self.horizontalDivider1];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.switchButton attribute:NSLayoutAttributeBottom multiplier:1 constant:20.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
    
}
- (void)initHorizontalDivider2 {
    self.horizontalDivider2 = [UILabel new];
    [self.horizontalDivider2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.horizontalDivider2 setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8f]];
    
    [self.horizontalDivider2.layer setShadowColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor];
    [self.horizontalDivider2.layer setShadowOffset:CGSizeMake(0, -1)];
    [self.horizontalDivider2.layer setShadowRadius:1.0f];
    [self.horizontalDivider2.layer setShadowOpacity:1.0f];
    [self.horizontalDivider2.layer setZPosition:2];
    
    [self.view addSubview:self.horizontalDivider2];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
}
- (void)initMapView {
    self.mapView = [MKMapView new];
//    [self.mapView setDelegate:self];
    [self.mapView setRotateEnabled:NO];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setDelegate:self];
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(25.0335, 121.5651), MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    [self.mapView.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor];
//    [self.mapView.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
//    [self.mapView.layer setCornerRadius:3];
    //    [self.mapView setShowsCompass:NO];
    [self.mapView.layer setZPosition:1];
    [self.mapView setShowsUserLocation:YES];
    
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.mapView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.horizontalDivider1 attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.horizontalDivider2 attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
}
- (void)switchChangeAction:(UISwitch *)sender {
    NSLog(@"xxxx");
}
- (void)stepperChangedAction:(UIStepper*)sender {
    double value = [sender value];
    
    [self.stepperLabel setText:[NSString stringWithFormat:@"%d 公尺", (int)value]];
//    NSLog(@"%@", [NSString stringWithFormat:@"%d", (int)value]);
}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    NSLog(@"xxx");
    // Image creation code here
    
}
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    self.currentLocation = [locations lastObject];
//    [self.locationManager stopUpdatingLocation];
//    // here we get the current location
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
