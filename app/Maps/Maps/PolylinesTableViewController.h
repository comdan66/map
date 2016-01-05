//
//  PolylinesTableViewController.h
//  Maps
//
//  Created by OA Wu on 2016/1/3.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "PolylineTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "PolylineViewController.h"
#import "AppDelegate.h"


@interface PolylinesTableViewController : UITableViewController <UIScrollViewDelegate>

@property BOOL isLoading;
@property NSString *nextId;
@property NSMutableArray *polylines;
@property(nonatomic, getter = shouldHideStatusBar) BOOL hideStatusBar;

@end
