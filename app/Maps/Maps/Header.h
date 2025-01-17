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
#define PATH_FETCH_TIMER 7 //sec
#define UPLOAD_PATHS_TIMER 13 //sec
#define UPLOAD_PATHS_LIMIT 50

#define API_GET_POLYLINE_PATHS (API_URL @"polylines/%d/paths")
#define API_POST_POLYLINES_PAYHS (API_URL @"polylines/%d/paths")

#define API_GET_USER_NEWEST_POLYLINE  (API_URL @"users/%d/polylines/newest")
#define API_POST_USER_CREATE_POLYLINE (API_URL @"users/%d/polylines")
#define API_GET_USER_POLYLINES        (API_URL @"users/%d/polylines")
#define API_GET_USER_NEW_POLYLINES    (API_URL @"users/%d/new/polylines")
#define API_POST_USER_FINISH_POLYLINE (API_URL @"users/%d/polylines/%d/finish")




#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

#endif /* Header_h */
