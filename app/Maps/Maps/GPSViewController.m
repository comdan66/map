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
    self.isMapload = NO;
    self.width = 100;
    self.buttonTopConstantColse = 200;
    self.buttonTopConstantOpen = 30;
    self.loadLabelTopConstantColse = 20;
    self.loadLabelTopConstantOpen = -100;
    [self initUI];
}

-(void)initUI {
    [self.view setBackgroundColor:[UIColor colorWithRed:0.04 green:0.62 blue:0.46 alpha:1]];
    
    [self initMapView];
    [self initInfo];
    [self initLogLabel];
    [self initButton];
}
- (void)initInfo {
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [self.visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.visualEffectView setOpaque:NO];
    [self.visualEffectView.layer setZPosition:2];
    [self.visualEffectView.layer setOpacity:0];
    [self.view addSubview:self.visualEffectView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.visualEffectView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.visualEffectView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    self.visualTopConstant = [NSLayoutConstraint constraintWithItem:self.visualEffectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeTop multiplier:1 constant:-self.width / 2];
    [self.view addConstraint:self.visualTopConstant];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.visualEffectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.width / 2]];
    
    UILabel *line = [UILabel new];
    [line setTranslatesAutoresizingMaskIntoConstraints:NO];
    [line setBackgroundColor:[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:1]];
    
    [self.visualEffectView addSubview:line];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1 / [UIScreen mainScreen].scale]];
    
    self.lngLable = [UILabel new];
    [self.lngLable setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.lngLable setText:[NSString stringWithFormat:@"經度：%.5f", 0.0]];
    [self.lngLable setFont:[UIFont systemFontOfSize:13]];
    [self.lngLable setTextAlignment:NSTextAlignmentLeft];
    [self.lngLable setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
    
    [self.visualEffectView addSubview:self.lngLable];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.lngLable attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.lngLable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView attribute:NSLayoutAttributeTop multiplier:1 constant:2]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.lngLable attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView attribute:NSLayoutAttributeWidth multiplier:.5 constant:0]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.lngLable attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.width / 4]];
    
    self.latLable = [UILabel new];
    [self.latLable setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.latLable setText:[NSString stringWithFormat:@"緯度：%.5f", 0.0]];
    [self.latLable setFont:[UIFont systemFontOfSize:13]];
    [self.latLable setTextAlignment:NSTextAlignmentLeft];
    [self.latLable setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
    
    [self.visualEffectView addSubview:self.latLable];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.latLable attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.lngLable attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.latLable attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.lngLable attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.latLable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lngLable attribute:NSLayoutAttributeBottom multiplier:1 constant:-2]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.latLable attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.width / 4]];
    
    
    self.speedLabel = [UILabel new];
    [self.speedLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.speedLabel setText:[NSString stringWithFormat:@"速度：%.3f Km/H", 0.0]];
    [self.speedLabel setFont:[UIFont systemFontOfSize:13]];
    [self.speedLabel setTextAlignment:NSTextAlignmentRight];
    [self.speedLabel setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
    
    [self.visualEffectView addSubview:self.speedLabel];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.speedLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.speedLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView attribute:NSLayoutAttributeTop multiplier:1 constant:2]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.speedLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.visualEffectView attribute:NSLayoutAttributeWidth multiplier:.5 constant:0]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.speedLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.width / 4]];
    
    self.accuracyLabel = [UILabel new];
    [self.accuracyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.accuracyLabel setText:[NSString stringWithFormat:@"準度：%.1f 公尺", 0.0]];
    [self.accuracyLabel setFont:[UIFont systemFontOfSize:13]];
    [self.accuracyLabel setTextAlignment:NSTextAlignmentRight];
    [self.accuracyLabel setTextColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1]];
    
    [self.visualEffectView addSubview:self.accuracyLabel];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.accuracyLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.speedLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.accuracyLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.speedLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.accuracyLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.speedLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-2]];
    [self.visualEffectView addConstraint:[NSLayoutConstraint constraintWithItem:self.accuracyLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.width / 4]];
    
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
    [self.topLabel.layer setZPosition:3];
    [self.topLabel.layer setOpacity:0];
    
    [self.topLabel.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5].CGColor];
    [self.topLabel.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.topLabel.layer setShadowRadius:1.0f];
    [self.topLabel.layer setShadowOpacity:0.5f];
    
    [self.view addSubview:self.topLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:self.buttonTopConstantOpen + self.width / 2]];
}
- (void)initButton {
    self.runLabel = [UILabel new];
    [self.runLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.runLabel.layer setZPosition:4];
    [self.runLabel.layer setBackgroundColor:[UIColor colorWithRed:0.04 green:0.62 blue:0.46 alpha:1].CGColor];
    
    [self.runLabel.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor];
    [self.runLabel.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.runLabel.layer setShadowRadius:0.5f];
    [self.runLabel.layer setShadowOpacity:0.5f];
    [self.runLabel.layer setCornerRadius:self.width / 2];
    [self.runLabel.layer setOpacity:.5];
    
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
    [self.loadLabel setText:@"初始中.."];
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
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.visualTopConstant setConstant:0];
            [self.visualEffectView.layer setOpacity:1];
            [self.view layoutIfNeeded];
        }];
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
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.visualTopConstant setConstant:-self.width / 2];
        [self.visualEffectView.layer setOpacity:0];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            [self.topLabel.layer setOpacity:0];
            [self.mapView.layer setOpacity:0];
            [self.loadLabel.layer setOpacity:1];
            [self.view layoutIfNeeded];
        }];
    }];
}
- (void)touchesBegan:(UITapGestureRecognizer *)tapGesture {
    if (!self.isMapload)
        return;

    self.isOn = !self.isOn;

    if (self.isOn) {
        [self.loadLabel setText:@"開啟中.."];
        [PathGPS start:self.mapView.userLocation.location.coordinate
               success:^{
                   [self.loadLabel setText:@"已開啟!"];
                   [self open];
               } failure:^{
                   [self touchesBegan:nil];
               } gps: self];
    }
    else {
        [PathGPS stop:^{
            [self.loadLabel setText:@"關閉中.."];
            [self close];
            [self.loadLabel setText:@"已關閉!"];
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    self.isMapload = YES;
    [self.runLabel.layer setOpacity:1];
    [self.loadLabel setText:@"初始完成！"];
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
