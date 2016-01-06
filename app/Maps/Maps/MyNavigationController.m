//
//  MyNavigationController.m
//  Maps
//
//  Created by OA Wu on 2016/1/3.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.04 green:0.62 blue:0.46 alpha:1];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]}];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setBarStyle:UIBarStyleBlack];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyTransparentBackgroundToTheNavigationBar:(UIColor *)color {
    UIImage *transparentBackground;
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, self.navigationBar.layer.contentsScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, components[0], components[1], components[2], CGColorGetAlpha(color.CGColor));
    UIRectFill(CGRectMake(0, 0, 1, 1));
    transparentBackground = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    id navigationBarAppearance = self.navigationBar;
    
    [navigationBarAppearance setBackgroundImage:transparentBackground forBarMetrics:UIBarMetricsDefault];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
