//
//  MemoView.m
//  Maps
//
//  Created by OA Wu on 2015/12/25.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "MemoView.h"

@implementation MemoView

- (void) initUI {
    UIView *tempView = [UIView new];
    [tempView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tempView setClipsToBounds:YES];
    [self addSubview:tempView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    UILabel *tmepLabel = [UILabel new];
    [tmepLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tmepLabel setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.5f]];
    [tempView addSubview:tmepLabel];

    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:tmepLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:tempView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
    
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:tmepLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:tempView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1 constant:0]];
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:tmepLabel
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:tempView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1 constant:0]];
    
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:tmepLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:1.0f / [UIScreen mainScreen].scale]];
    
    
    self.left = [UILabel new];
    [self.left setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.left setText:@""];
    [self.left setFont:[UIFont systemFontOfSize:14.0]];
    [self.left setTextAlignment:NSTextAlignmentCenter];
    
    [tempView addSubview:self.left];
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tmepLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    self.right = [UILabel new];
    [self.right setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.right setText:@""];
    [self.right setFont:[UIFont systemFontOfSize:14.0]];
    [self.right setTextAlignment:NSTextAlignmentCenter];
    
    [tempView addSubview:self.right];
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:tmepLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [tempView addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tempView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}
- (void)drawRect:(CGRect)rect {
    [self initUI];
}
- (void)setLeftText:(NSString *) l rightText:(NSString *)r {
    
    CGFloat d = 30.0f;
    if ((l.length < 1) && (l.length < 1)) {
        d = 1.0f;
    } else {
        [self.left setText:[NSString stringWithFormat:@"長度：%@", l]];
        [self.right setText:[NSString stringWithFormat:@"耗時：%@", r]];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.constraintHeight setConstant:d];
        [self layoutIfNeeded];
    }];
}

@end
