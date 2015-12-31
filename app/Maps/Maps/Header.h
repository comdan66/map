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
#define USER_ID 2
#define FOLLOW_USER_ID 1
#define PATH_FETCH_TIMER 10 //sec
#define UPLOAD_PATHS_TIMER 5 //sec

#define API_GET_USER_NEWEST_POLYLINE (API_URL @"users/%d/polylines/newest")
#define API_GET_POLYLINE_PATHS (API_URL @"polylines/%d/paths")
#define API_GET_USER_CREATE_POLYLINE (API_URL @"users/%d/polylines")
#define API_GET_USER_FINISH_POLYLINE (API_URL @"users/%d/polylines/%d/finish")
#define API_POST_POLYLINES_PAYHS (API_URL @"polylines/%d/paths")


#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

#endif /* Header_h */
