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
    [self initUI];
}

- (void)initUI {
    [self initMapView];
}

- (void)initMapView {
    self.mapView = [MKMapView new];
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.mapView setRotateEnabled:NO];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setDelegate:self];
    
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

    self.isLoadData = NO;

    [self loadData];
    if (self.timer) { [self.timer invalidate]; self.timer = nil; }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:PATH_FETCH_TIMER target:self selector:@selector(loadData) userInfo:nil repeats:YES];
}

- (void)loadData {
    if (self.isLoadData) return;

    self.isLoadData = YES;
    
    if (DEV) NSLog(@"------->Load Data!");


    if (![USER_DEFAULTS objectForKey:@"polylineId"]) {
        
        if (DEV) NSLog(@"------->NO polylineId!");

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取得資料中" message:@"請稍候..." preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            [self loadNewest:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([[responseObject objectForKey:@"status"] boolValue]) {
                    [USER_DEFAULTS setValue:[responseObject objectForKey:@"id"] forKey:@"polylineId"];
                    [self loadPaths:alert];
                } else {
                    [self failure:alert];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self failure:alert];
            }];
        }];
    } else {
        if (DEV) NSLog(@"------->Has polylineId!");
        [self loadPaths:nil];
    }
}
- (void)loadNewest:(void (^)(AFHTTPRequestOperation *operation, id responseObject))callbackBlock failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary *data = [NSMutableDictionary new];
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager GET:[NSString stringWithFormat:API_GET_USER_NEWEST_POLYLINE, FOLLOW_USER_ID]
          parameters:data
             success:callbackBlock
             failure:failure
     ];
}
- (void)loadPaths:(UIAlertController *)alert {
    NSMutableDictionary *data = [NSMutableDictionary new];
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager GET:[NSString stringWithFormat:API_GET_POLYLINE_PATHS, (int)[[USER_DEFAULTS objectForKey:@"polylineId"] integerValue]]
          parameters:data
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if ([[responseObject objectForKey:@"status"] boolValue]) {
                    [self setMap:[responseObject objectForKey:@"paths"] isFinish: [[responseObject objectForKey:@"is_finished"] boolValue]];
                     if (alert) [alert dismissViewControllerAnimated:YES completion:nil];
                 } else {
                    [self failure:alert];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self failure:alert];
             }
     ];
}

- (void)setMap:(NSMutableDictionary*)paths isFinish:(BOOL)isFinish {
    if (paths.count > 0) {
        if (self.line)
            [self.mapView removeOverlay:self.line];
        if (self.user)
            [self.mapView removeAnnotation:self.user];
        
        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * paths.count);

        int caIndex = 0;
        for (NSMutableDictionary *path in paths)
            coordinateArray[caIndex++] = CLLocationCoordinate2DMake([[path objectForKey:@"lat"] doubleValue], [[path objectForKey:@"lng"] doubleValue]);
        
        [self.mapView setRegion:MKCoordinateRegionMake(coordinateArray[0], MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
        
        self.user = [MKPointAnnotation new];
        [self.user setCoordinate:coordinateArray[0]];
        [self.mapView addAnnotation:self.user];
        
        self.line = [MKPolyline polylineWithCoordinates:coordinateArray count:paths.count];
        [self.mapView addOverlay:self.line];
    }

    self.isLoadData = NO;

    if (isFinish && self.timer) {
        self.isLoadData = YES;
        [self.timer invalidate];
        self.timer = nil;
        if (DEV) NSLog(@"------->Finish!");
    }
}
- (void)failure:(UIAlertController *)alert {
    
    if (DEV) NSLog(@"------->Failure!");

    UIAlertController *error = [UIAlertController
                                alertControllerWithTitle:@"錯誤"
                                message:@"地圖模式錯誤！"
                                preferredStyle:UIAlertControllerStyleAlert];
    [error addAction:[UIAlertAction
                      actionWithTitle:@"確定"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * action)
                      {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"goToTabIndex0" object:nil];
                          [error dismissViewControllerAnimated:YES completion:nil];
                      }]];
    if (alert)
        [alert dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:error animated:YES completion:nil];
        }];
    else
        self.isLoadData = NO;
}
- (void)clean {
    [self.mapView removeOverlay:self.line];
    [self.mapView removeAnnotation:self.user];
    self.isLoadData = YES;

    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (DEV) NSLog(@"------->Clean!");
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *overView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        overView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
        overView.lineWidth = 3;
        return overView;
    }
    return nil;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self clean];
    
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
