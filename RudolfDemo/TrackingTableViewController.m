//
//  TrackingTableViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/6.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <Parse/Parse.h>
#import "TrackingTableViewController.h"
#import "TrackingTableViewCell.h"
#import "CheckStatusViewController.h"


@interface TrackingTableViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>
{
    //NSString *username;
    NSString *currentCreatedAt;
    NSString *currentStatus;
    NSString *currentDestination;
    
    NSDictionary *currentData;
    NSMutableArray *trackDateArray;
    NSMutableArray *addressArray;
    NSMutableArray *statusArray;
}
@end

@implementation TrackingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    addressArray = [[NSMutableArray alloc]init];
    trackDateArray = [[NSMutableArray alloc]init];
    statusArray = [[NSMutableArray alloc]init];
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
    TrackingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TrackingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    } else {
        NSLog(@"I have been initialize. Row = %li", (long)indexPath.row);
    }
    //========set date format and convert to string===============
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:[trackDateArray objectAtIndex:indexPath.row]];
    NSLog(@"%@", strDate);
    //============================================================
    
    
    cell.createdAtLabel.text = strDate;
    cell.statusLabel.text = [statusArray objectAtIndex:indexPath.row];
    cell.destinationLabel.text = [addressArray objectAtIndex:indexPath.row];
    
    cell.backgroundColor =[UIColor clearColor];
    cell.destinationLabel.textColor = [UIColor grayColor];
    cell.destinationLabel.font =[UIFont systemFontOfSize:15];
    
    cell.createdAtLabel.textColor = [UIColor lightGrayColor];
    cell.createdAtLabel.font =[UIFont systemFontOfSize:14];
    
    if ([cell.statusLabel.text isEqualToString: @"received"]) {
        cell.statusLabel.textColor = [UIColor greenColor];
    }
    else if ([cell.statusLabel.text  isEqualToString: @"pending"]) {
        cell.statusLabel.textColor = [UIColor redColor];
    }
    else if ([cell.statusLabel.text  isEqualToString: @"arrival"]) {
        cell.statusLabel.textColor = [UIColor blueColor];
    }
    cell.statusLabel.font =[UIFont systemFontOfSize:14];
    
    return cell;
}

- (void)startQuery{
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    //query for number of events
    PFQuery *trackQuery = [PFQuery queryWithClassName:@"Delivery"];
    //NSInteger trackNumber = [trackQuery countObjects];
    [trackQuery whereKey:@"Email" equalTo:[userInfo objectForKey:@"email"]];
    [trackQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            for (PFObject *object in objects) {
                [addressArray addObject:[object objectForKey:@"Destination"]];
                [trackDateArray addObject:object.createdAt];
                //NSLog(@"%@",[object objectForKey:@"status"]);
                [statusArray addObject:[object objectForKey:@"status"]];
                
                //NSLog(@"%@",trackDateArray);
            }
            //NSLog(@"%@",trackDateArray);
            [self.tableView reloadData];
        }else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        
    }];
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"checkStatusSegue"]) {
//        CheckStatusViewController *nextView = segue.destinationViewController;
////        nextView.fromLabel = _addressReturn;
//    }
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:[trackDateArray objectAtIndex:indexPath.row]];
    NSLog(@"%@", strDate);
    currentCreatedAt = strDate;
    currentDestination = addressArray[indexPath.row];
    currentStatus = statusArray[indexPath.row];
    
    currentData = @{@"CreatedAt":currentCreatedAt ,
                    @"Destination":currentDestination,
                    @"Status":currentStatus};
    
    CheckStatusViewController *checkVC = [self.storyboard instantiateViewControllerWithIdentifier:@"checkStatusVC"];
    checkVC.receivedDic = currentData;
    [self.navigationController presentViewController:checkVC animated:YES completion:nil];
//    [self performSegueWithIdentifier:@"checkStatusSegue" sender:self];
}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Make sure your segue name in storyboard is the same as this line
//    if ([[segue identifier] isEqualToString:@"checkStatusSegue"])
//    {
//        //if you need to pass data to the next controller do it here
////        CheckStatusViewController *checkVC = [self.storyboard instantiateViewControllerWithIdentifier:@"checkStatusVC"];
//        
//    }
//}

@end

