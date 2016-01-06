//
//  GPSViewController.m
//  Maps
//
//  Created by OA Wu on 2016/1/6.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "GPSViewController.h"

@interface GPSViewController ()

@end

@implementation GPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isOn = NO;
    self.width = 100;
    self.buttonTopConstantColse = 200;
    self.buttonTopConstantOpen = 50;
    self.loadLabelTopConstantColse = 10;
    self.loadLabelTopConstantOpen = -100;
    [self initUI];
}

-(void)initUI {
    [self.view setBackgroundColor:[UIColor colorWithRed:0.04 green:0.62 blue:0.46 alpha:1]];
    
    [self initMapView];
    [self initLogLabel];
    [self initButton];
}
- (void)initMapView {
    self.mapView = [MKMapView new];
    [self.mapView setRotateEnabled:NO];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setDelegate:self];
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(25.0335, 121.5651), MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    [self.mapView.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor];
    
    [self.mapView.layer setZPosition:1];
    [self.mapView.layer setOpacity:0];
    [self.mapView setShowsUserLocation:YES];
    
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.view addSubview:self.mapView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:self.buttonTopConstantOpen + self.width / 2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}
-(void)initLogLabel {
    self.topLabel = [UILabel new];
    [self.topLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.topLabel setBackgroundColor:[UIColor colorWithRed:0 green:0.62 blue:0.45 alpha:1]];
    [self.topLabel.layer setZPosition:2];
    [self.topLabel.layer setOpacity:0];
    
    [self.topLabel.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5].CGColor];
    [self.topLabel.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.topLabel.layer setShadowRadius:1.0f];
    [self.topLabel.layer setShadowOpacity:0.5f];
    
    [self.view addSubview:self.topLabel];
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.topLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                              toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.topLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                              toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.topLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                              toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:self.buttonTopConstantOpen + self.width / 2]];
}
- (void)initButton {
    
    self.runLabel = [UILabel new];
    [self.runLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.runLabel.layer setZPosition:3];
    [self.runLabel.layer setBackgroundColor:[UIColor colorWithRed:0.04 green:0.62 blue:0.46 alpha:1].CGColor];
    
    [self.runLabel.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor];
    [self.runLabel.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.runLabel.layer setShadowRadius:0.5f];
    [self.runLabel.layer setShadowOpacity:0.5f];
    [self.runLabel.layer setCornerRadius:self.width / 2];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchesBegan:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.runLabel setUserInteractionEnabled:YES];
    [self.runLabel addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.runLabel];
    self.buttonTopConstraint = [NSLayoutConstraint constraintWithItem:self.runLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:self.buttonTopConstantColse];
    [self.view addConstraint:self.buttonTopConstraint];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.runLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.runLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.width]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.runLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.runLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    self.trianglePath = [UIBezierPath bezierPath];
    [self.trianglePath moveToPoint:CGPointMake(self.width / 3, self.width / 4)];
    [self.trianglePath addLineToPoint:CGPointMake(self.width * 3 / 4 + 3, self.width / 2)];
    [self.trianglePath addLineToPoint:CGPointMake(self.width / 3, self.width * 3 / 4)];
    [self.trianglePath closePath];
    
    self.rectanglePath = [UIBezierPath bezierPath];
    [self.rectanglePath moveToPoint:CGPointMake(self.width / 3 - 5, self.width / 3 - 5)];
    [self.rectanglePath addLineToPoint:CGPointMake(self.width * 2 / 3 + 5, self.width / 3 - 5)];
    [self.rectanglePath addLineToPoint:CGPointMake(self.width * 2 / 3 + 5, self.width * 2 / 3 + 5)];
    [self.rectanglePath addLineToPoint:CGPointMake(self.width / 3 - 5, self.width * 2 / 3 + 5)];
    [self.rectanglePath closePath];
    
    self.triangleLayer = [CAShapeLayerAnim layer];
    [self.triangleLayer setFillColor:[UIColor colorWithRed:0.03 green:0.53 blue:0.39 alpha:1].CGColor];
    [self.triangleLayer setPath:self.trianglePath.CGPath];
    
    [self.triangleLayer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor];
    [self.triangleLayer setShadowOffset:CGSizeMake(0, 0)];
    [self.triangleLayer setShadowRadius:0.0f];
    [self.triangleLayer setShadowOpacity:1.0f];
    
    [self.runLabel.layer addSublayer:self.triangleLayer];
    
    self.loadLabel = [UILabel new];
    [self.loadLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.loadLabel.layer setZPosition:1];
    [self.loadLabel setText:@""];
    [self.loadLabel.layer setOpacity:1];
    [self.loadLabel setTextAlignment:NSTextAlignmentCenter];
    [self.loadLabel setTextColor:[UIColor colorWithRed:0.49 green:0.82 blue:0.73 alpha:1]];
    
    if (LAY) {
        [self.loadLabel.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor];
        [self.loadLabel.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
    }
    [self.view addSubview:self.loadLabel];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.runLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    self.loadLabelTopConstant = [NSLayoutConstraint constraintWithItem:self.loadLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.runLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:self.loadLabelTopConstantColse];
    [self.view addConstraint:self.loadLabelTopConstant];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:120]];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (void)open {
    [self.runLabel.layer setBackgroundColor:[UIColor colorWithRed:0.04 green:0.62 blue:0.46 alpha:1].CGColor];
    [self.triangleLayer setPath:self.rectanglePath.CGPath];
    [self.triangleLayer setFillColor:[UIColor colorWithRed:0 green:0.53 blue:0.38 alpha:1].CGColor];
    [self.buttonTopConstraint setConstant:self.buttonTopConstantOpen];
    [self.loadLabelTopConstant setConstant:self.loadLabelTopConstantOpen];
    [self.runLabel.layer setShadowOffset:CGSizeMake(0, 0.5)];
    [self.runLabel.layer setShadowRadius:2.0f];
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.topLabel.layer setOpacity:1];
        [self.mapView.layer setOpacity:1];
        [self.loadLabel.layer setOpacity:0];
        [self.view layoutIfNeeded];
    }];
}
- (void)close {
    [self.runLabel.layer setBackgroundColor:[UIColor colorWithRed:0.04 green:0.62 blue:0.46 alpha:1].CGColor];
    [self.triangleLayer setPath:self.trianglePath.CGPath];
    [self.triangleLayer setFillColor:[UIColor colorWithRed:0.03 green:0.53 blue:0.39 alpha:1].CGColor];
    [self.buttonTopConstraint setConstant:self.buttonTopConstantColse];
    [self.loadLabelTopConstant setConstant:self.loadLabelTopConstantColse];
    [self.runLabel.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.runLabel.layer setShadowRadius:0.5f];

    [UIView animateWithDuration:0.5f animations:^{
        [self.topLabel.layer setOpacity:0];
        [self.mapView.layer setOpacity:0];
        [self.loadLabel.layer setOpacity:1];
        [self.view layoutIfNeeded];
    }];
}
- (void)touchesBegan:(UITapGestureRecognizer *)tapGesture {
    self.isOn = !self.isOn;

    if (self.isOn) {
            [self open];
//        [PathGPS start:^{
//            [self open];
//        } failure:^{
////            [self close];
//        }];
    }
    else [self close];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
