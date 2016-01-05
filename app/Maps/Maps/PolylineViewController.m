//
//  PolylineViewController.m
//  Maps
//
//  Created by OA Wu on 2016/1/4.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "PolylineViewController.h"

@interface PolylineViewController ()

@end

@implementation PolylineViewController

-(PolylineViewController *)initWithId:(NSString *)id {
    self = [super init];
    if (self) self.id = id;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];


    [self initUI];

    self.isLoadData = NO;
    [self loadPaths];
//    if (self.timer) { [self.timer invalidate]; self.timer = nil; }
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:PATH_FETCH_TIMER target:self selector:@selector(loadPaths) userInfo:nil repeats:YES];
}
- (void)loadPaths {
    if ((int)[self.id integerValue] < 1) [self.navigationController popToRootViewControllerAnimated:YES];

    if (self.isLoadData) return; else self.isLoadData = YES;

    if (DEV) NSLog(@"------->Load Paths!");

    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager GET:[NSString stringWithFormat:API_GET_POLYLINE_PATHS, (int)[self.id integerValue]]
          parameters:[NSMutableDictionary new]
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"Success");
//                 if ([[responseObject objectForKey:@"status"] boolValue]) {

//                     [self setMap:[responseObject objectForKey:@"paths"]
//                         isFinish: [[responseObject objectForKey:@"is_finished"] boolValue]
//                           length:[responseObject objectForKey:@"length"]
//                          runTime:[responseObject objectForKey:@"run_time"]
//                           avatar:[NSURL URLWithString:[responseObject objectForKey:@"avatar"]]
//                            alert:alert];
//                     
//                     if (alert) [alert dismissViewControllerAnimated:YES completion:nil];
//                 } else {
//                     [self failure:alert];
//                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  NSLog(@"Failure %@", error);
//                 [self failure:alert];
             }
     ];
}
//
//- (void)setMap:(NSMutableDictionary*)paths isFinish:(BOOL)isFinish length:(NSString *)length runTime:(NSString *)runTime avatar:(NSURL *)avatar alert:(UIAlertController *)alert {
//    if (paths.count > 0) {
//        if (self.line)
//            [self.mapView removeOverlay:self.line];
//        
//        [self.memo setLeftText:length rightText:runTime];
//        
//        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * paths.count);
//        
//        int caIndex = 0;
//        for (NSMutableDictionary *path in paths)
//            coordinateArray[caIndex++] = CLLocationCoordinate2DMake([[path objectForKey:@"lat"] doubleValue], [[path objectForKey:@"lng"] doubleValue]);
//        
//        if (alert) {
//            [self.mapView setRegion:MKCoordinateRegionMake(coordinateArray[0], MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
//        }
//        
//        if (!self.user && ([paths count] > 0)) {
//            self.user = [[MyAnnotation alloc] initWithLocation:coordinateArray[0]];
//            [self.user setImageUrl:avatar];
//            [self.mapView addAnnotation:self.user];
//        } else {
//            [self.user setCoordinate:coordinateArray[0]];
//        }
//        
//        self.line = [MKPolyline polylineWithCoordinates:coordinateArray count:[paths count]];
//        [self.mapView addOverlay:self.line];
//    }
//    
//    self.isLoadData = NO;
//    
//    if (isFinish && self.timer) {
//        self.isLoadData = YES;
//        [self.timer invalidate];
//        self.timer = nil;
//        if (DEV) NSLog(@"------->Finish!");
//    }
//}

- (void)initUI {
    [self.view.layer setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1].CGColor];
    [self initMapView];
    [self initLocationButton];
}
- (void)goToMyLocation:(id)sender {
    //    NSLog(@"2222%@", self.mapView.userLocation.coordinate);
    [self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
}
- (void)initLocationButton {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [visualEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [visualEffectView setOpaque:NO];
    [visualEffectView.layer setZPosition:2];
    [self.view addSubview:visualEffectView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:visualEffectView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:35]];

    UILabel *bH = [UILabel new];
    [bH setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bH setBackgroundColor:[UIColor colorWithRed:0.83 green:0.82 blue:0.82 alpha:1]];
    [bH.layer setZPosition:4];
    
    [self.view addSubview:bH];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bH attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:visualEffectView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bH attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bH attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bH attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1.0f / [UIScreen mainScreen].scale]];
    
    UILabel *bV = [UILabel new];
    [bV setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bV setBackgroundColor:[UIColor colorWithRed:0.83 green:0.82 blue:0.82 alpha:1]];
    [bV.layer setZPosition:4];
    
    [self.view addSubview:bV];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bV attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bH attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1.0f / [UIScreen mainScreen].scale]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bV attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1.0f / 2 constant:0]];
    

    self.myLocationButton = [UIButton new];
    [self.myLocationButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.myLocationButton setTitle:@"我的位置" forState:UIControlStateNormal];
    [self.myLocationButton setTitleColor:[UIColor colorWithRed:0.26 green:0.61 blue:0.99 alpha:1] forState:UIControlStateNormal];
    [self.myLocationButton setTitleColor:[UIColor colorWithRed:0 green:0.46 blue:1 alpha:1] forState:UIControlStateHighlighted];
    [self.myLocationButton setTitleColor:[UIColor colorWithRed:0.26 green:0.61 blue:0.99 alpha:.4] forState:UIControlStateDisabled];
    [self.myLocationButton setEnabled:NO];
    [self.myLocationButton.layer setZPosition:3];
    [self.myLocationButton addTarget:self action:@selector(goToMyLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.myLocationButton];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.myLocationButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:visualEffectView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.myLocationButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bV attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.myLocationButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.myLocationButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:visualEffectView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    self.uLocationButton = [UIButton new];
    [self.uLocationButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.uLocationButton setTitle:@"他的位置" forState:UIControlStateNormal];
    [self.uLocationButton setTitleColor:[UIColor colorWithRed:0.26 green:0.61 blue:0.99 alpha:1] forState:UIControlStateNormal];
    [self.uLocationButton setTitleColor:[UIColor colorWithRed:0 green:0.46 blue:1 alpha:1] forState:UIControlStateHighlighted];
    [self.uLocationButton setTitleColor:[UIColor colorWithRed:0.26 green:0.61 blue:0.99 alpha:.4] forState:UIControlStateDisabled];
    [self.uLocationButton setEnabled:NO];
    [self.uLocationButton.layer setZPosition:3];
    
    [self.view addSubview:self.uLocationButton];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.uLocationButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:visualEffectView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.uLocationButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.uLocationButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bV attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.uLocationButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:visualEffectView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
}
- (void)initMapView {
    self.mapView = [MKMapView new];
    [self.mapView setRotateEnabled:NO];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setDelegate:self];
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(25.0335, 121.5651), MKCoordinateSpanMake(0.1, 0.1)) animated:YES];

    
    [self.mapView.layer setZPosition:1];
    [self.mapView setShowsUserLocation:YES];
    
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.mapView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    [self.myLocationButton setEnabled:YES];
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
