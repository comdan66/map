//
//  MemoView.h
//  Maps
//
//  Created by OA Wu on 2015/12/25.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MemoStyle) {
    MemoStyleDefault,
    MemoStyleGradient
};

@interface MemoView : UIView

@property UILabel *left, *right;
@property (nonatomic)NSLayoutConstraint *constraintHeight;

- (void)setLeftText:(NSString *) l rightText:(NSString *)r;
- (void)setLeftText:(NSString *) l rightText:(NSString *)r animate:(BOOL)animate;

@end
