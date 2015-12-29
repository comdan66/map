//
//  ViewController.m
//  Maps4
//
//  Created by OA Wu on 2015/12/29.
//  Copyright © 2015年 OA Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (NSString *)stringWithFormatWithArrayArgs:(NSString *)format args:(NSArray *)arguments {
    NSRange range = NSMakeRange(0, [arguments count]);
    NSMutableData *data = [NSMutableData dataWithLength:sizeof(id) * [arguments count]];
    [arguments getObjects:(__unsafe_unretained id *)data.mutableBytes range:range];
    
    NSLog(@"%@", data.mutableBytes);
    NSString *result = [[NSString alloc] initWithFormat:format arguments:data.mutableBytes];
    return result;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self stringWithFormatWithArrayArgs:@"%@, %@" args: @[@"123", @"333333"]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
