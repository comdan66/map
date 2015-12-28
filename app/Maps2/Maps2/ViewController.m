//
//  ViewController.m
//  Maps2
//
//  Created by OA Wu on 2015/12/25.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.mapView = [MKMapView new];
    [self.mapView setRotateEnabled:NO];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setDelegate:self];
    
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(25.0335, 121.5651), MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
//    [self.mapView.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor];
    
    [self.mapView.layer setZPosition:1];
    [self.mapView setShowsUserLocation:YES];
    
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.mapView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0.0]];
    
    
    NSObject *x = [MKAnnotation new];
//    self.annotation.image = [UIImage imageNamed:@"loading.png"];
//    [self.mapView addAnnotation:self.annotation];
//
    MKPointAnnotation *point;
    
    // 設定在台北的大頭針
//    point = [[MKPointAnnotation alloc]init];
//    point.coordinate = CLLocationCoordinate2DMake(25.0335, 121.5651);
//
//    point.title = @"台北市";
//    point.subtitle = @"中華民國首都";
//    [self.mapView addAnnotation:point];
//    

//        [self performSelector:@selector(hideClick1) withObject:nil afterDelay:2.0f];
}
- (void)hideClick1 {
    self.annotation.coordinate =CLLocationCoordinate2DMake(25.0435, 121.5751);
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    // 判斷這個annotation是不是屬於顯示目前所在位置的那一個註解
    if (![annotation isKindOfClass:[MyAnnotation class]]) {
        return nil;
    }
    
    
    MKAnnotationView *annView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"xxx"];
    if (annView == nil) {
        annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"xxx"];
        Marker *marker = [Marker create];
//        [annView setBackgroundColor:[UIColor grayColor]];
//        [annView.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5].CGColor];
//        [annView.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];

        [annView addSubview:marker];


        [annView setFrame:CGRectMake(0, 0, 60, 70)];
        [annView setCenterOffset:CGPointMake(0,-35)];
        [annView setCanShowCallout:NO];
        [annView setDraggable:NO];
    }
//    MyMKAnnotationView *annView = (MyMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"xxx"];
//    if (annView == nil) {
//        annView = [[MyMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"xxx"];
//    }
//
//    NSURL *ImageURL = [NSURL URLWithString:@"http://maps.ioa.tw/upload/users/avatar/0/0/0/1/100x100c_1508708305_567bab9039351.jpg"];
//
//    [annView sd_setImageWithURL:ImageURL placeholderImage:nil options:0 completed:nil];;
    
    return annView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
