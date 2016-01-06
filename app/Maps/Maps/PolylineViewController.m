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

    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated {
    if (DEV) NSLog(@"------->viewWillAppear!");

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取得資料中" message:@"請稍候..." preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        self.isLoadData = NO;
        [self loadPaths:alert];
        
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:PATH_FETCH_TIMER target:self selector:@selector(loadPathsByTimer) userInfo:nil repeats:YES];
    }];
}
- (void)clean {
    [self.mapView removeOverlays:self.mapView.overlays];
    
    if (self.user) {
        [self.mapView removeAnnotation:self.user];
        self.user = nil;
    }
    
    self.isLoadData = YES;
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (DEV) NSLog(@"------->Clean!");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self clean];
}
- (void)loadPathsByTimer {
    [self loadPaths:nil];
}
- (void)loadPaths:(UIAlertController *)alert {
    if (DEV) NSLog(@"------->Load Paths!");
    
    if ((int)[self.id integerValue] < 1) {
        if (DEV) NSLog(@"-------> ID < 1!");

        if (alert) [alert dismissViewControllerAnimated:YES completion:^{ [self.navigationController popToRootViewControllerAnimated:YES]; }];
        else [self.navigationController popToRootViewControllerAnimated:YES];
    }

    if (self.isLoadData) return; else self.isLoadData = YES;

    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager GET:[NSString stringWithFormat:API_GET_POLYLINE_PATHS, (int)[self.id integerValue]]
          parameters:[NSMutableDictionary new]
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (DEV) NSLog(@"-------> Success!");

                 [self setMap:responseObject alert:alert];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if (DEV) NSLog(@"-------> Failure!");
                 [self failure:alert title:nil message:nil];
             }
     ];
}
- (void)failure:(UIAlertController *)alert title:(NSString *) title message:(NSString *) message {
    UIAlertController *error = [UIAlertController
                                alertControllerWithTitle:title ? title : @"錯誤"
                                message:message ? message : @"地圖模式錯誤！"
                                preferredStyle:UIAlertControllerStyleAlert];
    [error addAction:[UIAlertAction
                      actionWithTitle:@"確定"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * action)
                      {
                          [error dismissViewControllerAnimated:YES completion:^{
                              [self.navigationController popToRootViewControllerAnimated:YES];
                          }];
                      }]];

    if (alert) [alert dismissViewControllerAnimated:YES completion:^{ [self presentViewController:error animated:YES completion:nil]; }];
    else self.isLoadData = NO;
}
- (void)setMap:(NSDictionary *)responseObject alert:(UIAlertController *)alert {
    NSArray *paths = [responseObject objectForKey:@"paths"];
    NSURL *avatar = [NSURL URLWithString:[responseObject objectForKey:@"avatar"]];
    BOOL isFinish = [[responseObject objectForKey:@"is_finished"] boolValue];
    
    [self.mapView removeOverlays:self.mapView.overlays];

    if (paths.count > 0) {
        
        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * paths.count);
        float *velocity = malloc(sizeof(float) * paths.count);
        
        int caIndex = 0;
        for (NSMutableDictionary *path in paths) {
            velocity[caIndex] = [[path objectForKey:@"sd"] doubleValue];
            coordinateArray[caIndex++] = CLLocationCoordinate2DMake([[path objectForKey:@"lat"] doubleValue], [[path objectForKey:@"lng"] doubleValue]);
        }
        
        if (!self.user && ([paths count] > 0)) {
            self.user = [[MyAnnotation alloc] initWithLocation:coordinateArray[0]];
            [self.user setImageUrl:avatar];
            [self.mapView addAnnotation:self.user];
        } else {
            [self.user setCoordinate:coordinateArray[0]];
        }
        
        [self.mapView addOverlay:[[GradientPolylineOverlay alloc] initWithPoints:coordinateArray velocity:velocity count:paths.count]];
        [self.uLocationButton setEnabled:YES];
        if (alert) [self.mapView setRegion:MKCoordinateRegionMake(coordinateArray[0], MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    } else {
        [self.uLocationButton setEnabled:NO];
    }

    self.isLoadData = NO;

    if (isFinish && self.timer) {
        self.isLoadData = YES;
        [self.timer invalidate];
        self.timer = nil;
        if (DEV) NSLog(@"------->Finish!");
    }

    if (alert) [alert dismissViewControllerAnimated:YES completion:nil];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    GradientPolylineRenderer *polylineRenderer = [[GradientPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRenderer.lineWidth = 8.0f;
    return polylineRenderer;
    
}
- (void)initUI {
    [self.view.layer setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1].CGColor];
    [self initMapView];
    [self initLocationButton];
}

- (void)goToULocation:(id)sender {
    [self.mapView setRegion:MKCoordinateRegionMake([[self.mapView.overlays lastObject] coordinate], MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
}
- (void)goToMyLocation:(id)sender {
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
    [self.uLocationButton addTarget:self action:@selector(goToULocation:) forControlEvents:UIControlEventTouchUpInside];
    
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
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MyAnnotation *)annotation {
    if (![annotation isKindOfClass:[MyAnnotation class]])
        return nil;

    MKAnnotationView *annView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"userMarker"];
    if (annView == nil) {
        annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"userMarker"];
        UserMarker *userMarker = [UserMarker create:annotation];
        [annView addSubview:userMarker];
        [annView setFrame:CGRectMake(0, 0, 60, 70)];
        [annView setCenterOffset:CGPointMake(0,-35)];
        [annView setCanShowCallout:NO];
        [annView setDraggable:NO];
    }
    
    return annView;
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
