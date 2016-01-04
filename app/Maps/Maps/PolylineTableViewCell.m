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


//- (PolylineTableViewCell *)initBaseData {
//    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [self.contentView.layer setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor];
//    [self initBorderView];
//    return self;
//}
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
    [self initMemo:polyline];
}
- (void)initMemo:(NSDictionary *)polyline {
    GradientView *gradient = [[GradientView alloc] initWithPosition:GradientViewPositionBottom];
    
    [self.content addSubview:gradient];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeBottom multiplier:1 constant:1]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeRight multiplier:1 constant:1]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeLeft multiplier:1 constant:-1]];
    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:gradient attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:40]];
    
//    self.memo = [MemoView new];
//    
//    [self.memo setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.memo setBackgroundColor:[UIColor clearColor]];
//
//    
////    [self.memo.layer setShadowColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor];
////    [self.memo.layer setShadowOffset:CGSizeMake(0, 2)];
////    [self.memo.layer setShadowRadius:2.0f];
////    [self.memo.layer setShadowOpacity:1.0f];
////    [self.memo.layer setOpacity:0.9f];
//    
//    [self.content addSubview:self.memo];
//    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:self.memo attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeBottom multiplier:1 constant:1]];
//    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:self.memo attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeRight multiplier:1 constant:1]];
//    [self.content addConstraint:[NSLayoutConstraint constraintWithItem:self.memo attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.content attribute:NSLayoutAttributeLeft multiplier:1 constant:-1]];
//    [self.memo setConstraintHeight:[NSLayoutConstraint constraintWithItem:self.memo attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1]];
//    [self.content addConstraint:self.memo.constraintHeight];
//    
//    [self.memo setLeftText: @"123" rightText:@"234" animate:NO];
//    [self.memo setStyle:MemoStyleGradient];
//
    
//    [self performSelector:@selector(hideClick1) withObject:nil afterDelay:3.0f];
}
//- (void)hideClick1 {
//    [self.memo setLeftText: @"123" rightText:@"234" animate:YES];
//}
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
    
    [self.border.layer setShadowColor:[UIColor colorWithRed:0.67 green:0.67 blue:0.67 alpha:1].CGColor];
    [self.border.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.border.layer setShadowRadius:1.0f];
    [self.border.layer setShadowOpacity:1.0f];
    
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
    
    [self.contentView addSubview:self.border];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.border attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.borderView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0]];
}

@end
