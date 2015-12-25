//
//  MyUILabel.m
//  Maps
//
//  Created by OA Wu on 2015/12/24.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "MyUILabel.h"

@implementation MyUILabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGSize)intrinsicContentSize{
    CGSize contentSize = [super intrinsicContentSize];
    return CGSizeMake(contentSize.width + 20, contentSize.height + 8);
}

@end
