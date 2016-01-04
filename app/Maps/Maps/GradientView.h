//
//  GradientView.h
//  Maps
//
//  Created by OA Wu on 2016/1/4.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView

typedef NS_ENUM(NSInteger, GradientViewPosition) {
    GradientViewPositionTop,
    GradientViewPositionBottom
};

@property CAGradientLayer *gradient;
@property UILabel *left, *right;

- (GradientView *)initWithPosition:(GradientViewPosition)positon;
- (void)setLeftText:(NSString *) l rightText:(NSString *)r;
- (void)setTitleText:(NSString *)text;
@end
