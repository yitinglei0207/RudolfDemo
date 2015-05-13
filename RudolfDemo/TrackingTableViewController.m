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
#import "SWRevealViewController.h"

@interface TrackingTableViewController ()<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>
{
    //NSString *username;
    NSString *currentCreatedAt;
    NSString *currentStatus;
    NSString *currentDestination;
    
    PFObject *currentData;
    NSMutableArray *deliveryList;

}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end

@implementation TrackingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    addressArray = [[NSMutableArray alloc]init];
//    trackDateArray = [[NSMutableArray alloc]init];
    deliveryList = [[NSMutableArray alloc]init];
//    
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    //[self startQuery];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
    [deliveryList removeAllObjects];
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
    return deliveryList.count;
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
    
    PFObject *tempDic = [deliveryList objectAtIndex:indexPath.row];
    
    //========set date format and convert to string===============
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:tempDic.updatedAt];
    NSLog(@"%@", strDate);
    //============================================================
    
    
    cell.createdAtLabel.text = strDate;
    cell.statusLabel.text = [tempDic objectForKey:@"status"];
    cell.destinationLabel.text = [tempDic objectForKey:@"Destination"];
    
    cell.backgroundColor =[UIColor clearColor];
    cell.destinationLabel.textColor = [UIColor grayColor];
    cell.destinationLabel.font =[UIFont systemFontOfSize:15];
    
    cell.createdAtLabel.textColor = [UIColor lightGrayColor];
    cell.createdAtLabel.font =[UIFont systemFontOfSize:14];
    
    //if ([cell.statusLabel.text isEqualToString: @"received"]) {
        cell.statusLabel.textColor = [UIColor darkGrayColor];
//    }
//    else if ([cell.statusLabel.text  isEqualToString: @"pending"]) {
//        cell.statusLabel.textColor = [UIColor redColor];
//    }
//    else if ([cell.statusLabel.text  isEqualToString: @"arrival"]) {
//        cell.statusLabel.textColor = [UIColor blueColor];
//    }
    cell.statusLabel.font =[UIFont systemFontOfSize:14];
    
    return cell;
}

- (void)startQuery{
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    //query for number of events
    PFQuery *trackQuery = [PFQuery queryWithClassName:@"Delivery"];
    //NSInteger trackNumber = [trackQuery countObjects];
    [trackQuery whereKey:@"Email" equalTo:[userInfo objectForKey:@"email"]];
    [trackQuery findObjectsInBackgroundWithBlock:^(NSArray *objectArray, NSError *error){
        if (!error) {
            for (PFObject *object in objectArray) {
                
                [deliveryList addObject:object];
           
                NSLog(@"%@",object);
            }
            //NSLog(@"%@",trackDateArray);
            [self.tableView reloadData];
        }else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"checkStatusSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        currentData = [deliveryList objectAtIndex:indexPath.row];

        CheckStatusViewController *nextView = segue.destinationViewController;
        nextView.receivedDic = currentData;
    }
    
}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
////    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
////    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
////    NSString *strDate = [dateFormatter stringFromDate:[trackDateArray objectAtIndex:indexPath.row]];
////    //NSLog(@"%@", strDate);
////    currentCreatedAt = strDate;
////    currentDestination = addressArray[indexPath.row];
////    currentStatus = statusArray[indexPath.row];
////    
//    currentData = [deliveryList objectAtIndex:indexPath.row];
//
//    //CheckStatusViewController *checkVC = [self.storyboard instantiateViewControllerWithIdentifier:@"checkStatusVC"];
//    //checkVC.receivedDic = currentData;
//    //[self.navigationController presentViewController:checkVC animated:YES completion:nil];
//    [self performSegueWithIdentifier:@"checkStatusSegue" sender:self];
//}
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

