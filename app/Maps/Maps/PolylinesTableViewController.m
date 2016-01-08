//
//  PolylinesTableViewController.m
//  Maps
//
//  Created by OA Wu on 2016/1/3.
//  Copyright © 2016年 OA Wu. All rights reserved.
//

#import "PolylinesTableViewController.h"

@interface PolylinesTableViewController ()

@end

@implementation PolylinesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1]];
    [self.tableView.layer setBackgroundColor:[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor];

    
//     setBackgroundColor:[UIColor blueColor]];
//    self.pa.window.backgroundColor = [UIColor colorWithRed:0.78f green:0.13f blue:0.11f alpha:1];
//    [self]

    //    [self.navigationController.navigationBar setBarStyle:<#(UIBarStyle)#>:UIBarStyleBlack];
//    NSLog(@"~~~~~~~~~~~~~~~~~~~~~%@", self.view);
//    [self setStatusBarHidden:NO];
//    [self setStatusBarStyle:UIStatusBarStyleLightContent];
//    
    //    [(MyNavigationController *)self.navigationController setTableViewController:self];

    //    [self.na setBarStyle:UIBarStyleBlack];
//    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
//    [self.parentViewController.view.layer setBackgroundColor:[UIColor redColor].CGColor];
//    [self.parentViewController.parentViewController.view.layer setBackgroundColor:[UIColor redColor].CGColor];
//    NSLog(@"%@", self.parentViewController.parentViewController.parentViewController);
//    [self.tableView reloadData];
    

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取得資料中" message:@"請稍候..." preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        self.isLoading = NO;
        self.nextId = @"0";
        self.polylines = [NSMutableArray new];
        [self loadData:alert];
    }];
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return NO;
}
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxx");
////    if (self.viewControllers.count > 1) {
////        return YES;
////    }
//    return NO;
//}
- (void)refreshAction {
    if (DEV) NSLog(@"------->RefreshAction!");

    [self loadNewData:nil
           callbackBlock: ^(UITableView *tableView){
               [self.refreshControl endRefreshing];
           }];
}
- (void)loadNewData:(UIAlertController *)alert callbackBlock:(void (^)(UITableView *tableView))callbackBlock {

    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setValue:[self.polylines count] > 0 ? [NSString stringWithFormat:@"%li", [[[self.polylines objectAtIndex:0] objectForKey:@"id"] integerValue] + 1] : @"0" forKey:@"prev_id"];

    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager GET:[NSString stringWithFormat:API_GET_USER_NEW_POLYLINES, FOLLOW_USER_ID]
          parameters:data
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 for (NSDictionary *polyline in [responseObject objectForKey:@"polylines"])
                     [self.polylines insertObject: polyline atIndex:0];
                 
                  if (alert) [alert dismissViewControllerAnimated:YES completion:nil];

                 [self.tableView reloadData];
                 callbackBlock(self.tableView);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 callbackBlock(self.tableView);
             }
     ];
}
- (void)loadDataFailure:(UIAlertController *)alert title:(NSString *) title message:(NSString *) message {
    
    if (DEV) NSLog(@"------->LoadData Failure!");
    
    UIAlertController *error = [UIAlertController
                                alertControllerWithTitle:title ? title : @"錯誤"
                                message:message ? message : @"取得資料錯誤！"
                                preferredStyle:UIAlertControllerStyleAlert];
    [error addAction:[UIAlertAction
                      actionWithTitle:@"確定"
                      style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction * action)
                      {
                          [error dismissViewControllerAnimated:YES completion:^{
                              self.isLoading = NO;
                          }];
                      }]];
    if (alert)
        [alert dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:error animated:YES completion:nil];
        }];
    else
        self.isLoading = NO;
}
- (void)loadData:(UIAlertController *)alert {
    if (self.isLoading) return;
    self.isLoading = YES;
    
    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setValue:self.nextId forKey:@"next_id"];
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/json"]];
    [httpManager GET:[NSString stringWithFormat:API_GET_USER_POLYLINES, FOLLOW_USER_ID]
           parameters:data
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (DEV) NSLog(@"~~~~~~>LoadData success");

                  for (NSDictionary *polyline in [responseObject objectForKey:@"polylines"])
                      [self.polylines addObject: polyline];

                  self.nextId = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"next_id"]];
                  
                  if ([self.nextId integerValue] >= 0)
                      self.isLoading = NO;
                  
                  [self.tableView reloadData];

                  if (alert) [alert dismissViewControllerAnimated:YES completion:nil];
                  
                  
                  if (DEV) NSLog(@"~~~~~~>Next ID: %@!", [self.nextId integerValue] >= 0 ? self.nextId : @"NO Next ID!");
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self loadDataFailure:alert title:nil message:nil];
              }
     ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"PolylineTableViewCell_%@", [[self.polylines objectAtIndex:indexPath.row] objectForKey:@"id"]];
    PolylineTableViewCell *cell = (PolylineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil) {
        if (DEV) NSLog(@"~~~~~~>CellForRowAtIndexPath!");
        cell = [[PolylineTableViewCell alloc] initCellWithStyle: [self.polylines objectAtIndex:indexPath.row] style:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isLoading) return;
    
    if ((scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height * 2)) {
        self.isLoading = YES;
        [self loadData:nil];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[PolylineViewController alloc] initWithId:[[self.polylines objectAtIndex:indexPath.row] objectForKey:@"id"]] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%ld", [self.polylines count]);
    return [self.polylines count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 250;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
