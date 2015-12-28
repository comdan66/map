//
//  Header.h
//  Maps
//
//  Created by OA Wu on 2015/12/24.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define API_URL @"http://maps.ioa.tw/api/v2/"

#define DEV YES
#define LAY NO
#define USER_ID 1
#define FOLLOW_USER_ID 1
#define MAP_TIMER 5

#define API_GET_USER_NEWEST_POLYLINE (API_URL @"users/%d/polylines/newest")
#define API_GET_POLYLINE_PATHS (API_URL @"polylines/%d/paths")

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

#endif /* Header_h */
