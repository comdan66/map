//
//  ViewController.m
//  Maps
//
//  Created by OA Wu on 2015/12/22.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.locationManager = [CLLocationManager new];
//    [self.locationManager setDelegate:self];
//    [self.locationManager setDistanceFilter:0];
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    self.locationManager.allowsBackgroundLocationUpdates = YES;
//    // Do any additional setup after loading the view, typically from a nib.
//    [self.locationManager requestAlwaysAuthorization];
//    [self.locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations firstObject];
//    NSLog(@"%@", location);
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!(error)) {
            CLPlacemark *placemark = [placemarks firstObject];

            NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            NSString *Address = [[NSString alloc]initWithString:locatedAt];
            NSString *Area = [[NSString alloc]initWithString:placemark.locality];
            NSString *Country = [[NSString alloc]initWithString:placemark.country];
            NSLog(@"%@ - %@ - %@ - %@", locatedAt, Address, Area, Country);
            
        } else {
            NSLog(@"Geocode failed with error %@", error);
            NSLog(@"\nCurrent Location Not Detected\n");
            //return;
        }
     }];
    
//    NSString *lat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
//    NSString *lng = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
//    NSString *altitude = [NSString stringWithFormat:@"%f", location.altitude];
//    NSString *horizontalAccuracy = [NSString stringWithFormat:@"%f", location.horizontalAccuracy];
//    NSString *verticalAccuracy = [NSString stringWithFormat:@"%f", location.verticalAccuracy];
//    NSString *speed = [NSString stringWithFormat:@"%f", location.speed];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
