//
//  PolylineTableViewCell.h
//  Maps
//
//  Created by OA Wu on 2016/1/3.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
//#import "MemoView.h"
#import "GradientView.h"

@interface PolylineTableViewCell : UITableViewCell

@property  UIView *border;
@property  UIView *content;
@property  UIImageView *cover;
//@property  MemoView *memo;
//@property GradientView *gradient;

- (PolylineTableViewCell *)initBaseData;
- (PolylineTableViewCell *) initCellWithStyle:(NSDictionary *)polyline style:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;

@end
