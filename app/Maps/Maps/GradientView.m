//
//  GradientView.m
//  Maps
//
//  Created by OA Wu on 2016/1/4.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (GradientView *)initWithPosition:(GradientViewPosition)positon {
    self = [super init];
    if (self) {
        if (positon == GradientViewPositionBottom)
            [self initBottomUI];
        else
            [self initTopUI];
    }
    return self;
}

- (void)initUI {
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setClipsToBounds:YES];
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.bounds;
    [self.layer insertSublayer:self.gradient atIndex:0];
    
}
- (void)setTitleText:(NSString *)text {
    [self.left setText:text];
}
- (void)initTopUI {
    [self initUI];

    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:.7] CGColor], (id)[[UIColor clearColor] CGColor], nil];
    
    self.left = [UILabel new];
    [self.left setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.left setText:@"qwe"];
    [self.left setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self.left setFont:[UIFont systemFontOfSize:14.0]];
    [self.left setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:self.left];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];

}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradient.frame = self.bounds;
}
- (void)initBottomUI {
    [self initUI];
    
    self.gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:.7] CGColor], nil];
    
    UILabel *tmepLabel = [UILabel new];
    [tmepLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [tmepLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:tmepLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tmepLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tmepLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tmepLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:tmepLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1.0f / [UIScreen mainScreen].scale]];
    
    
    self.left = [UILabel new];
    [self.left setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.left setText:@""];
    [self.left setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self.left setFont:[UIFont systemFontOfSize:14.0]];
    [self.left setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:self.left];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:tmepLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.left attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    self.right = [UILabel new];
    [self.right setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.right setText:@""];
    [self.right setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    [self.right setFont:[UIFont systemFontOfSize:14.0]];
    [self.right setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:self.right];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:tmepLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.right attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}
- (void)setLeftText:(NSString *) l rightText:(NSString *)r{
    [self.left setText:[NSString stringWithFormat:@"長度：%@", l]];
    [self.right setText:[NSString stringWithFormat:@"耗時：%@", r]];
}

@end
