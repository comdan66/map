//
//  PolylineTableViewCell.m
//  Maps
//
//  Created by OA Wu on 2016/1/3.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "PolylineTableViewCell.h"

@implementation PolylineTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (PolylineTableViewCell *)initBaseData {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView.layer setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor];
    [self initBorderView];
    return self;
}
- (void)initBorderView {
    self.borderView = [UIView new];
    
    [self.borderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.borderView.layer setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor];
    
    [self.borderView.layer setShadowColor:[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1].CGColor];
    [self.borderView.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.borderView.layer setShadowRadius:1.0f];
    [self.borderView.layer setShadowOpacity:0.5f];
    
//    CALayer *TopBorder = [CALayer layer];
//    TopBorder.frame = CGRectMake(0.0f, 0.0f, self.borderView.frame.size.width, 3.0f);
//    TopBorder.backgroundColor = [UIColor redColor].CGColor;
//    [self.borderView.layer addSublayer:TopBorder];
    

//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.borderView.bounds.size.width, 1.0f / [UIScreen mainScreen].scale)];
//    [topView setOpaque:YES];
//    [topView setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
//    [topView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin ];
//    [self.borderView addSubview :topView];
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.borderView.bounds.size.height, self.borderView.bounds.size.width, 1.0f / [UIScreen mainScreen].scale)];
//    [bottomView setOpaque:YES];
//    [bottomView setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
//    [bottomView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin ];
//        NSLog(@"%f", self.borderView.bounds.size.height);
//    
//    [self.borderView addSubview :bottomView];
    
    
//    [self.borderView.layer setBorderColor:[UIColor colorWithRed:0.79 green:0.74 blue:0.72 alpha:1.0].CGColor];
//    [self.borderView.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
//    [self.borderView.layer setCornerRadius:2];
//    [self.borderView setClipsToBounds:YES];
    
    [self.contentView addSubview:self.borderView];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.borderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10.0]];    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.borderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.borderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.borderView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.borderView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.borderView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

@end
