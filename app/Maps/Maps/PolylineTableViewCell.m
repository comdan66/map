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

- (PolylineTableViewCell *) initCellWithStyle:(NSDictionary *)polyline style:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI:polyline];
    }
    return self;
}
- (void)initUI:(NSDictionary *)polyline {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.contentView.layer setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor];
    [self initBorder];
    [self initContent];
    [self initCover:polyline];
    [self initTop:polyline];
    [self initBottom:polyline];
    [self initAvatar:polyline];
}
- (void)initAvatar:(NSDictionary *)polyline {
    int w = 50, s = 3;
    
    UIView *avatar = [UIView new];
    [avatar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [avatar.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3].CGColor];
    [avatar.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
    [avatar setBackgroundColor:[UIColor whiteColor]];
    [avatar.layer setCornerRadius:3];
    
    [self.contentView addSubview:avatar];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:avatar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeTop multiplier:1 constant:-10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:avatar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:avatar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:w]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:avatar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:w]];
    
    
    UIImageView *avatarImageView = [UIImageView new];
    [avatarImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [avatarImageView.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.2].CGColor];
//    [avatarImageView.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:[polyline objectForKey:@"avatar"]]];
    [avatarImageView setContentMode:UIViewContentModeScaleAspectFill];
    [avatarImageView setClipsToBounds:YES];
    [avatarImageView.layer setCornerRadius:1];
    
    [avatar addSubview:avatarImageView];
    [avatar addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:avatar attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [avatar addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:avatar attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [avatar addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:avatar attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-s * 2]];
    [avatar addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:avatar attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-s * 2]];
    
//    
//    UIView *avatarView = [UIView new];
//    [avatarView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [avatarView.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3].CGColor];
//    [avatarView.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
//    [avatarView setBackgroundColor:[UIColor whiteColor]];
//    [avatarView.layer setZPosition:4];
//    
//    [avatarView.layer setShadowColor:[UIColor colorWithRed:0.15 green:0.16 blue:0.13 alpha:1].CGColor];
//    [avatarView.layer setShadowOffset:CGSizeMake(0, 0)];
//    [avatarView.layer setShadowRadius:2.0f];
//    [avatarView.layer setShadowOpacity:0.25f];
//    [avatarView.layer setCornerRadius:w / 2 - s];
//    
//    [avatar addSubview:avatarView];
//;
//    
//    [avatarView addSubview:avatarImageView];
//    [avatarView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:avatarView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
//    [avatarView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:avatarView attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0]];
//    [avatarView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:avatarView attribute:NSLayoutAttributeRight multiplier:1 constant:0.0]];
//    [avatarView addConstraint:[NSLayoutConstraint constraintWithItem:avatarImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:avatarView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];    
}
- (void)initTop:(NSDictionary *)polyline {
    GradientView *gradient = [[GradientView alloc] initWithPosition:GradientViewPositionTop];
    
    [self.content addSubview:gradient];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeTop multiplier:1 constant:-1]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeRight multiplier:1 constant:1]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeLeft multiplier:1 constant:60]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    
    [gradient setTitleText:[NSString stringWithFormat:@"%@ - %@", [polyline objectForKey:@"id"], [polyline objectForKey:@"name"]]];
}
- (void)initBottom:(NSDictionary *)polyline {
    GradientView *gradient = [[GradientView alloc] initWithPosition:GradientViewPositionBottom];
    
    [self.content addSubview:gradient];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeBottom multiplier:1 constant:1]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeRight multiplier:1 constant:1]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeLeft multiplier:1 constant:-1]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:35]];
    
    [gradient setLeftText:[NSString stringWithFormat:@"%@", [polyline objectForKey:@"length"]] rightText:[NSString stringWithFormat:@"%@", [polyline objectForKey:@"run_time"]]];
}

- (void)initCover:(NSDictionary *)polyline {
    self.cover = [UIImageView new];
    [self.cover setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self.cover sd_setImageWithURL:[NSURL URLWithString:[polyline objectForKey:@"cover"]]];
    [self.cover setContentMode:UIViewContentModeScaleAspectFill];
    [self.cover setClipsToBounds:YES];
    
    [self.content addSubview:self.cover];
    
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeTop multiplier:1 constant:0.0]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:self.cover attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0]];
}
- (void)initContent {
    self.content = [UIView new];
    [self.content setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.content.layer setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor];
    [self.content setClipsToBounds:YES];
    [self.border addSubview:self.content];

    [self.border addConstraint:[NSLayoutConstraint constraintWithItem:self.content attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.border attribute:NSLayoutAttributeTop multiplier:1 constant:0.0]];
    [self.border addConstraint:[NSLayoutConstraint constraintWithItem:self.content attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.border attribute:NSLayoutAttributeBottom multiplier:1 constant:0.0]];
    [self.border addConstraint:[NSLayoutConstraint constraintWithItem:self.content attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.border attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0]];
    [self.border addConstraint:[NSLayoutConstraint constraintWithItem:self.content attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.border attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0]];
}
- (void)initBorder {
    self.border = [UIView new];
    
    [self.border setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.border.layer setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor];
    
//    [self.border.layer setShadowColor:[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1].CGColor];
//    [self.border.layer setShadowOffset:CGSizeMake(0, 1)];
//    [self.border.layer setShadowRadius:1.0f];
//    [self.border.layer setShadowOpacity:1.0f];

    [self.border.layer setBorderColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.5].CGColor];
    [self.border.layer setBorderWidth:1.0f / [UIScreen mainScreen].scale];
    [self.border.layer setCornerRadius:2];
    [self.border setClipsToBounds:YES];
    
    [self.contentView addSubview:self.border];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:5.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.borderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
}

@end
