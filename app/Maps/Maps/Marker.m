//
//  Marker.m
//  Maps2
//
//  Created by OA Wu on 2015/12/28.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "Marker.h"

@implementation Marker

+ (Marker *) create:(MyAnnotation *)annotation {
    Marker *marker = [[[NSBundle mainBundle] loadNibNamed:@"Marker" owner:nil options:nil] lastObject];
    
    if ([marker isKindOfClass:[Marker class]])
        return [marker initUIByCode:annotation];
    else
        return nil;

}
- (Marker *) initUIByCode:(MyAnnotation *)annotation {
    [self setFrame:CGRectMake(0, 0, 0, 0)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    UIView *bgView = [UIView new];
    [bgView setTranslatesAutoresizingMaskIntoConstraints:NO];
 
    if (LAY) {
        [bgView.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5].CGColor];
        [bgView.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
    }
    
    [self addSubview:bgView];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    UIView *circle = [UIView new];
    [circle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [circle.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5].CGColor];
    [circle.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
    [circle setBackgroundColor:[UIColor whiteColor]];
    [circle.layer setZPosition:2];

    [circle.layer setShadowColor:[UIColor colorWithRed:0.15 green:0.16 blue:0.13 alpha:1].CGColor];
    [circle.layer setShadowOffset:CGSizeMake(0, 0)];
    [circle.layer setShadowRadius:2.5f];
    [circle.layer setShadowOpacity:0.4f];
    [circle.layer setCornerRadius:30];

    [bgView addSubview:circle];
    
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:circle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:circle attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:circle attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeRight multiplier:1 constant:0.0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:circle attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:circle attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];

    
    UIView *avatarView = [UIView new];
    [avatarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [avatarView.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3].CGColor];
    [avatarView.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
    [avatarView setBackgroundColor:[UIColor whiteColor]];
    [avatarView.layer setZPosition:4];
    
    [avatarView.layer setShadowColor:[UIColor colorWithRed:0.15 green:0.16 blue:0.13 alpha:1].CGColor];
    [avatarView.layer setShadowOffset:CGSizeMake(0, 0)];
    [avatarView.layer setShadowRadius:2.0f];
    [avatarView.layer setShadowOpacity:0.25f];
    [avatarView.layer setCornerRadius:30 - 5];
    
    [bgView addSubview:avatarView];
    
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:avatarView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:circle attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:avatarView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:circle attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:avatarView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:circle attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-10]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:avatarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:circle attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-10]];
    
    UIImageView *avatar = [UIImageView new];
    [avatar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [avatar sd_setImageWithURL:annotation.imageUrl];
    [avatar setContentMode:UIViewContentModeScaleAspectFill];
    [avatar setClipsToBounds:YES];
    [avatar.layer setCornerRadius:30 - 5];

    [avatarView addSubview:avatar];
    [avatarView addConstraint:[NSLayoutConstraint constraintWithItem:avatar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:avatarView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [avatarView addConstraint:[NSLayoutConstraint constraintWithItem:avatar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:avatarView attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0]];
    [avatarView addConstraint:[NSLayoutConstraint constraintWithItem:avatar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:avatarView attribute:NSLayoutAttributeRight multiplier:1 constant:0.0]];
    [avatarView addConstraint:[NSLayoutConstraint constraintWithItem:avatar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:avatarView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    UIView *arrow1 = [UIView new];
    [arrow1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [arrow1.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5].CGColor];
    [arrow1.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
    [arrow1 setBackgroundColor:[UIColor whiteColor]];
    [arrow1.layer setZPosition:1];
    
    [arrow1.layer setShadowColor:[UIColor colorWithRed:0.15 green:0.16 blue:0.13 alpha:1].CGColor];
    [arrow1.layer setShadowOffset:CGSizeMake(0, 0)];
    [arrow1.layer setShadowRadius:2.5f];
    [arrow1.layer setShadowOpacity:0.4f];

    [arrow1 setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45))];
    
    [bgView addSubview:arrow1];

    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:arrow1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeLeft multiplier:1 constant:30 - 15 / 2]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:arrow1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0 - 15 * 1.414 / 4]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:arrow1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:arrow1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:15]];
    
    UIView *arrow2 = [UIView new];
    [arrow2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [arrow2 setBackgroundColor:[UIColor whiteColor]];
    [arrow2.layer setZPosition:3];
    
    [arrow2 setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45))];
    
    [bgView addSubview:arrow2];
    
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:arrow2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:arrow1 attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:arrow2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:arrow1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-2/1.414]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:arrow2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:arrow1 attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [bgView addConstraint:[NSLayoutConstraint constraintWithItem:arrow2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:arrow1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:-1/1.414]];

    
    
    
//    UIView *bg = [UIView new];
//    
//    [bg setTranslatesAutoresizingMaskIntoConstraints:NO];
//
//    [bg.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5].CGColor];
//    [bg.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
//    //    [bg.layer setCornerRadius:30];
////    [self.layer setMasksToBounds:YES];
//    [bg.layer setMasksToBounds:YES];
//    [bg setBackgroundColor:[UIColor whiteColor]];
//    [bg.layer setShadowColor:[UIColor greenColor].CGColor];
//    [bg.layer setShadowOffset:CGSizeMake(0.5f, 0.5f)];
//    [bg.layer setShadowRadius:3.0f];
//    [bg.layer setShadowOpacity:1];
//
//    [bg setTransform:CGAffineTransformMakeRotation(0.18)];
//
//    
//    [self addSubview:bg];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:bg attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:bg attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:bg attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0.0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:bg attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:bg attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
//
//    
//    UIView *t1 = [UIView new];
//    
//    
//    [t1 setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [t1.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5].CGColor];
//    [t1.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
//    [t1 setBackgroundColor:[UIColor whiteColor]];
//    [t1.layer setShadowColor:[UIColor greenColor].CGColor];
//    [t1.layer setShadowOffset:CGSizeMake(0.5f, 0.5f)];
//    [t1.layer setShadowRadius:1.0f];
//    [t1.layer setShadowOpacity:1];
//    
//    [bg addSubview:t1];
//    [bg addConstraint:[NSLayoutConstraint constraintWithItem:t1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bg attribute:NSLayoutAttributeTop multiplier:1.0 constant:10]];
//    [bg addConstraint:[NSLayoutConstraint constraintWithItem:t1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:bg attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
//    [bg addConstraint:[NSLayoutConstraint constraintWithItem:t1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:bg attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10]];
//    [bg addConstraint:[NSLayoutConstraint constraintWithItem:t1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bg attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];

    return  self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
