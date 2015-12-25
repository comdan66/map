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
    UIView *temp = [UIView new];
    [temp setTranslatesAutoresizingMaskIntoConstraints:NO];
    [temp setClipsToBounds:YES];
    [self addSubview:temp];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:temp attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:temp attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:temp attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:temp attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    self.left = [UILabel new];
    [self.left setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.left setText:@""];
    [self.left setFont:[UIFont systemFontOfSize:14.0]];
    [self.left setTextAlignment:NSTextAlignmentCenter];
    
    [temp addSubview:self.left];
    [temp addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [temp addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeRight multiplier:0.5f constant:0]];
    [temp addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [temp addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    self.right = [UILabel new];
    [self.right setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.right setText:@""];
    [self.right setFont:[UIFont systemFontOfSize:14.0]];
    [self.right setTextAlignment:NSTextAlignmentCenter];
    
    [temp addSubview:self.right];
    [temp addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [temp addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [temp addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.left attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [temp addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}
- (void)drawRect:(CGRect)rect {
    [self initUI];
}
- (void)setLeftText:(NSString *) l rightText:(NSString *)r {
    [self.left setText:l];
    [self.right setText:r];
    
    CGFloat d = 30.0f;
    if ((l.length < 1) && (l.length < 1)) d = 1.0f;
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.constraintHeight setConstant:d];
        [self layoutIfNeeded];
    }];
}

@end
