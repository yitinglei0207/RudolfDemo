//
//  TrackingTableViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/6.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <Parse/Parse.h>
#import "TrackingTableViewController.h"

@interface TrackingTableViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>
{
    NSString *username;
    NSDate *createdAt;
    NSString *status;
    NSDictionary *trackDic;
    NSMutableArray *trackArrayList;
    NSMutableArray *addressArray ;
}
@end

@implementation TrackingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    addressArray = [[NSMutableArray alloc]init];
    [self startQuery];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return ;
//}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"trackingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor =[UIColor clearColor];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font =[UIFont systemFontOfSize:15];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        
    } else {
        NSLog(@"I have been initialize. Row = %li", (long)indexPath.row);
    }
    cell.textLabel.text = [addressArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)startQuery{
    //query for number of events
    PFQuery *trackQuery = [PFQuery queryWithClassName:@"Delivery"];
    //NSInteger trackNumber = [trackQuery countObjects];
    [trackQuery whereKey:@"Destination" equalTo:@"SongShan Airport"];
    [trackQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            
            
            for (NSDictionary *object in objects) {
                [addressArray addObject:[object objectForKey:@"Destination"]];
            }
            NSLog(@"%@",addressArray);
            [self.tableView reloadData];
        }else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        
    }];
}


@end

