//
//  ViewController.h
//  Maps
//
//  Created by OA Wu on 2015/12/22.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>


@property CLLocationManager *locationManager;

@end

