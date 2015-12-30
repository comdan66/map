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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    //[self performSelector:@selector(hideClick1) withObject:nil afterDelay:5.0f];
}
//- (void)hideClick1 {
//    if (self.user) {
//        NSLog(@"------------------x");
//        self.user.coordinate = CLLocationCoordinate2DMake(25.0435, 121.5751);
//    }
//    
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.isLoadData = NO;
    
    [self loadData];
    if (self.timer) { [self.timer invalidate]; self.timer = nil; }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:MAP_TIMER target:self selector:@selector(loadData) userInfo:nil repeats:YES];
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
                
                if (DEV) NSLog(@"------->LoadNewest!");
                
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
                     [self setMap:[responseObject objectForKey:@"paths"]
                         isFinish: [[responseObject objectForKey:@"is_finished"] boolValue]
                           length:[responseObject objectForKey:@"length"]
                          runTime:[responseObject objectForKey:@"run_time"]
                           avatar:[NSURL URLWithString:[responseObject objectForKey:@"avatar"]]
                            alert:alert];
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
- (void)setMap:(NSMutableDictionary*)paths isFinish:(BOOL)isFinish length:(NSString *)length runTime:(NSString *)runTime avatar:(NSURL *)avatar alert:(UIAlertController *)alert {
    if (paths.count > 0) {
        if (self.line)
            [self.mapView removeOverlay:self.line];
//        if (self.user)
//            [self.mapView removeAnnotation:self.user];
        
        [self.memo setLeftText:length rightText:runTime];
        
        CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * paths.count);
        
        int caIndex = 0;
        for (NSMutableDictionary *path in paths)
            coordinateArray[caIndex++] = CLLocationCoordinate2DMake([[path objectForKey:@"lat"] doubleValue], [[path objectForKey:@"lng"] doubleValue]);
        
        if (alert) {
            [self.mapView setRegion:MKCoordinateRegionMake(coordinateArray[0], MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
        }
        
        if (!self.user) {
            self.user = [[MyAnnotation alloc] initWithLocation:coordinateArray[0]];
            [self.user setImageUrl:avatar];
            [self.mapView addAnnotation:self.user];
        } else {
            [self.user setCoordinate:coordinateArray[0]];
        }
        
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
//                          [[NSNotificationCenter defaultCenter] postNotificationName:@"goToTabIndex0" object:nil];
                          [error dismissViewControllerAnimated:YES completion:^{
                              self.isLoadData = NO;
                          }];
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
    //    離開
    [self clean];
    
}

- (void) startGPS {
    [self.switchLabel setText:@"開啟中.."];

    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setValue:@"xxx" forKey:@"name"];

    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager POST:[NSString stringWithFormat:API_GET_USER_CREATE_POLYLINE, USER_ID]
          parameters:data
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if ([[responseObject objectForKey:@"status"] boolValue]) {
                     self.polylineId = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"id"]];
                     [self.switchLabel setText:@"開啟"];
                     [GPS start];
                 } else {
                     [self stopGPS];
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self stopGPS];
             }
     ];

}
- (void) stopGPS {
    if (self.polylineId) {
        [self finish:(int)[self.polylineId integerValue]
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 self.polylineId = nil;
                 [self stopGPS];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 self.polylineId = nil;
                 [self stopGPS];
             }];
    } else {
        [self.switchButton setOn:NO animated:YES];
        [self.switchLabel setText:@"關閉"];
        [GPS stop];
    }
}
- (void)finish:(int)id success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSLog(@"%d", id);
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager POST:[NSString stringWithFormat:API_GET_USER_FINISH_POLYLINE, USER_ID, id]
           parameters:[NSMutableDictionary new]
              success:success
              failure:failure
     ];
}
- (void)switchChangeAction:(UISwitch *)sender {
    if ([sender isOn])
        [self startGPS];
    else
        [self stopGPS];
}
- (void)stepperChangedAction:(UIStepper*)sender {
    double value = [sender value];
    
    [self.stepperLabel setText:[NSString stringWithFormat:@"%d 公尺", (int)value]];
//    NSLog(@"%@", [NSString stringWithFormat:@"%d", (int)value]);
}
- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    [self viewWillAppear:NO];
//    NSLog(@"xxx");
    // Image creation code here
    
}
- (void)initUI {
    [self initSwitchButton];
    [self initSwitchLabel];
    [self initStepperButton];
    [self initStepperLabel];
    [self initHorizontalDivider1];
    [self initHorizontalDivider2];
    [self initMapView];
    [self initMemo];
//    [self initLength];
}
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
    
    if (LAY) {
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
    
    if (LAY) {
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
    
//    [self.horizontalDivider1.layer setShadowColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor];
//    [self.horizontalDivider1.layer setShadowOffset:CGSizeMake(0, 1)];
//    [self.horizontalDivider1.layer setShadowRadius:1.0f];
//    [self.horizontalDivider1.layer setShadowOpacity:1.0f];
    [self.horizontalDivider1.layer setZPosition:2];
    
    [self.view addSubview:self.horizontalDivider1];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.switchButton attribute:NSLayoutAttributeBottom multiplier:1 constant:20.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1.0f / [UIScreen mainScreen].scale]];
    
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
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.horizontalDivider2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1.0f / [UIScreen mainScreen].scale]];
}
- (void)initMapView {
    self.mapView = [MKMapView new];
    //    [self.mapView setDelegate:self];
    [self.mapView setRotateEnabled:NO];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setDelegate:self];
    [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(25.0335, 121.5651), MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
    [self.mapView.layer setBorderColor:[UIColor colorWithRed:0.84 green:0.84 blue:0.84 alpha:1].CGColor];

    [self.mapView.layer setZPosition:1];
    [self.mapView setShowsUserLocation:YES];
    
    [self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.mapView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.horizontalDivider1 attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.horizontalDivider2 attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
}
- (void)initMemo {
    self.memo = [MemoView new];
    
    [self.memo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.memo setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];

    
    [self.memo.layer setShadowColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor];
    [self.memo.layer setShadowOffset:CGSizeMake(0, 2)];
    [self.memo.layer setShadowRadius:2.0f];
    [self.memo.layer setShadowOpacity:1.0f];
    [self.memo.layer setOpacity:0.9f];
    
    [self.mapView addSubview:self.memo];
    [self.mapView addConstraint:[NSLayoutConstraint constraintWithItem:self.memo attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
    [self.mapView addConstraint:[NSLayoutConstraint constraintWithItem:self.memo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeRight multiplier:1 constant:1]];
    [self.mapView addConstraint:[NSLayoutConstraint constraintWithItem:self.memo attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeLeft multiplier:1 constant:-1]];
    [self.memo setConstraintHeight:[NSLayoutConstraint constraintWithItem:self.memo attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
    [self.mapView addConstraint:self.memo.constraintHeight];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MyAnnotation *)annotation
{
//    NSLog(@"---------------------------1-%@", [annotation isKindOfClass:[MyAnnotation class]] ? :);
    
    if (![annotation isKindOfClass:[MyAnnotation class]]) {
        return nil;
    }
    
    NSLog(@"---------------------------2");
    MKAnnotationView *annView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"aaa"];
    if (annView == nil) {
        NSLog(@"---------------------------3");
        annView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"aaa"];
        Marker *marker = [Marker create:annotation];
        [annView addSubview:marker];

        
        [annView setFrame:CGRectMake(0, 0, 60, 70)];
        [annView setCenterOffset:CGPointMake(0,-35)];
        [annView setCanShowCallout:NO];
        [annView setDraggable:NO];
    }

    return annView;
}
//
//
//    [self.memo.constraintHeight setConstant:35];
//    [self.view updateConstraints];
//    
//    //    [self.view updateConstraints];
//}
//- (void)drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = {0, 5, 0, 5};
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}
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
