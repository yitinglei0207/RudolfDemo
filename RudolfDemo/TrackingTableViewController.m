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
    NSString *currentCreatedAt;
    NSString *currentStatus;
    NSString *currentDestination;
    PFObject *currentData;
    NSMutableArray *deliveryList;
    UIImageView *indicatorBackground;
}
@property(nonatomic,strong)UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end

@implementation TrackingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    deliveryList = [[NSMutableArray alloc]init];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }


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


- (void)activityStart{
    [self activityIndicatorSetup];
    [_indicator startAnimating];
}

- (void)activityStop{
    [_indicator stopAnimating];
    [indicatorBackground removeFromSuperview];
}


- (void)activityIndicatorSetup{
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.center = self.view.center;
    indicatorBackground = [[UIImageView alloc]init];
    indicatorBackground.backgroundColor = [UIColor darkGrayColor];
    indicatorBackground.alpha = 0.5;
    [indicatorBackground setFrame:CGRectMake(self.view.center.x-25, self.view.center.y-25, 50, 50)];
    indicatorBackground.layer.cornerRadius = 5;
    indicatorBackground.layer.masksToBounds = YES;
    [self.view addSubview:indicatorBackground];
    [self.view addSubview:_indicator];
}

#pragma tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


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
    NSString *strDate = [dateFormatter stringFromDate:tempDic.createdAt];
    NSLog(@"%@", strDate);
    //============================================================
    
    
    cell.createdAtLabel.text = strDate;
    cell.statusLabel.text = [tempDic objectForKey:@"status"];
    cell.destinationLabel.text = [tempDic objectForKey:@"Destination"];
    
    cell.backgroundColor =[UIColor clearColor];
    cell.destinationLabel.textColor = [UIColor grayColor];
    cell.destinationLabel.font =[UIFont systemFontOfSize:15];
    
    cell.createdAtLabel.textColor = [UIColor lightGrayColor];
    cell.createdAtLabel.font =[UIFont systemFontOfSize:15];
    
    if ([cell.statusLabel.text isEqualToString: @"received"]) {
        cell.statusLabel.textColor = [UIColor darkGrayColor];
        //cell.statusLabel.font = [UIFont ]
    }
    else if ([cell.statusLabel.text  isEqualToString: @"pending"]) {
        cell.statusLabel.textColor = [UIColor blackColor];
        cell.statusLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    else if ([cell.statusLabel.text  isEqualToString: @"arrival"]) {
        cell.statusLabel.textColor = [UIColor lightGrayColor];
    }
    cell.statusLabel.font =[UIFont systemFontOfSize:15];
    
    return cell;
}

- (void)startQuery{
    //set the indicator
    
    [self activityStart];
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    //query for number of events
    PFQuery *trackQuery = [PFQuery queryWithClassName:@"Delivery"];
    
    [trackQuery orderByDescending:@"createdAt"];
    
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
        [self activityStop];
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


@end

