//
//  MapViewController.m
//  Maps
//
//  Created by OA Wu on 2015/12/23.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [OAHUD show];
    [self initUI];
    
    [self performSelector:@selector(look) withObject:nil afterDelay:2.0f];
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(look) userInfo:nil repeats:YES];
}

- (void)look {
//    [OAHUD hide];
    NSLog(@"=");
//    [self performSelector:@selector(look) withObject:nil afterDelay:2.0f];
}
- (void)initUI {
    [self initMapView];
}

- (void)initMapView {
    self.mapView = [MKMapView new];
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mapView setRotateEnabled:NO];
    [self.mapView setZoomEnabled:YES];
//    [self.mapView setDelegate:self];

    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(25.0335, 121.5651), MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    [self.mapView.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor];
//    [self.mapView.layer setZPosition:1];
    [self.mapView setShowsUserLocation:YES];
    

    [self.view addSubview:self.mapView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    進來
    NSLog(@"2");

}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    離開
    NSLog(@"1");

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
