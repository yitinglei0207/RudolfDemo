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

@interface TrackingTableViewController ()
{
    NSString *currentCreatedAt;
    NSString *currentStatus;
    NSString *currentDestination;
    PFObject *currentData;
    NSMutableArray *deliveryList;
    
    NSMutableArray *receivedMutableArray;
    NSMutableArray *arrivalMutableArray;
    NSMutableArray *pendingMutableArray;
    
    UIImageView *indicatorBackground;
}
@property(nonatomic,strong) UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end

@implementation TrackingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //deliveryList = [[NSMutableArray alloc]init];
    receivedMutableArray = [[NSMutableArray alloc]init];
    arrivalMutableArray = [[NSMutableArray alloc]init];
    pendingMutableArray = [[NSMutableArray alloc]init];
    
    [_segmentedControl addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents: UIControlEventValueChanged];
    //_segmentedControl.segIndex = 0;
    _segmentedControl.selectedSegmentIndex = 0;
    CGRect frame= _segmentedControl.frame;
    [_segmentedControl setFrame:CGRectMake(frame.origin.x, frame.origin.y, 336, 47)];
    
    //[self.view addSubview:_segmentedControl];
    self.trackingTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    _trackingTable.delegate = self;
    _trackingTable.dataSource = self;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }


}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [receivedMutableArray removeAllObjects];
    [arrivalMutableArray removeAllObjects];
    [pendingMutableArray removeAllObjects];
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)trackingTable
{
    return 1;
}


- (NSInteger)tableView:(UITableView*)trackingTable numberOfRowsInSection:(NSInteger)section
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return pendingMutableArray.count;
    }else if(_segmentedControl.selectedSegmentIndex == 1){
        return receivedMutableArray.count;
    }else {
        return arrivalMutableArray.count;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)trackingTable cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"trackingCell";
    TrackingTableViewCell *cell = [trackingTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TrackingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    } else {
        NSLog(@"I have been initialize. Row = %li", (long)indexPath.row);
    }
    
    PFObject *tempDic;
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        tempDic = [pendingMutableArray objectAtIndex:indexPath.row];
    } else if(_segmentedControl.selectedSegmentIndex == 1) {
        tempDic = [receivedMutableArray objectAtIndex:indexPath.row];
    }else{
        tempDic = [arrivalMutableArray objectAtIndex:indexPath.row];
    }
    
    
    //========set date format and convert to string===============
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:tempDic.createdAt];
    NSLog(@"%@", strDate);
    //============================================================
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.createdAtLabel.text = strDate;
    //cell.statusLabel.text = [tempDic objectForKey:@"status"];
    cell.destinationLabel.text = [tempDic objectForKey:@"Destination"];
    
    cell.backgroundColor =[UIColor clearColor];
    cell.destinationLabel.textColor = [UIColor grayColor];
    cell.destinationLabel.font =[UIFont systemFontOfSize:15];
    
    cell.createdAtLabel.textColor = [UIColor lightGrayColor];
    cell.createdAtLabel.font =[UIFont systemFontOfSize:15];
    
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
                
                //[deliveryList addObject:object];
           
                NSLog(@"%@",object);
                
                if ([[object objectForKey:@"status"] isEqualToString:@"pending"] ) {
                    [pendingMutableArray addObject:object];
                }else if ([[object objectForKey:@"status"] isEqualToString:@"received"]){
                    [receivedMutableArray addObject:object];
                }else{
                    [arrivalMutableArray addObject:object];
                }
            }
            //NSLog(@"%@",trackDateArray);
            
        }else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
//        for (PFObject *object  in deliveryList) {
//            if ([[object objectForKey:@"status"] isEqualToString:@"pending"] ) {
//                [pendingMutableArray addObject:object];
//            }else if ([[object objectForKey:@"status"] isEqualToString:@"received"]){
//                [receivedMutableArray addObject:object];
//            }else{
//                [arrivalMutableArray addObject:object];
//            }
//        }
        [self.trackingTable reloadData];
        [self activityStop];
        
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"checkStatusSegue"]) {
        NSIndexPath *indexPath = [self.trackingTable indexPathForSelectedRow];
        if (_segmentedControl.selectedSegmentIndex == 0) {
            currentData = [pendingMutableArray objectAtIndex:indexPath.row];
        }else if (_segmentedControl.selectedSegmentIndex == 1){
            currentData = [receivedMutableArray objectAtIndex:indexPath.row];
        }else if (_segmentedControl.selectedSegmentIndex == 2){
            currentData = [arrivalMutableArray objectAtIndex:indexPath.row];
        }
//        currentData = [deliveryList objectAtIndex:indexPath.row];
        CheckStatusViewController *nextView = segue.destinationViewController;
        nextView.receivedDic = currentData;
    }
}



-(IBAction) segmentedControlIndexChanged: (UISegmentedControl *)segmentedControl
{
    [pendingMutableArray removeAllObjects];
    [receivedMutableArray removeAllObjects];
    [arrivalMutableArray removeAllObjects];

    [self startQuery];

}



@end

