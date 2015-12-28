//
//  MyMKAnnotationView.m
//  Maps2
//
//  Created by OA Wu on 2015/12/25.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "MyMKAnnotationView.h"

@implementation MyMKAnnotationView

- (void)drawRect:(CGRect)rect {
//    self.image = nil;
//   [ self addSubview:];/
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        CGRect  viewRect = CGRectMake(0, 0, 60, 60);
        
        self.circleView = [[UIView alloc] initWithFrame:viewRect];
        [self.circleView setBackgroundColor:[UIColor redColor]];
        
        [self addSubview:self.circleView];
        
        self.imageView = [UIImageView new];
        [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self addSubview:self.imageView];

    }
    return self;
}
- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}
//
//- (void)stickerColor:(float)color {
//    NSString
//    NSLog(@"rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
//    self.circleView .green = color;
//    [_circleView setNeedsDisplay];
//}


@end
