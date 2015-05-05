//
//  ConfirmationViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/4.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import "ConfirmationViewController.h"
#import <Parse/Parse.h>

@interface ConfirmationViewController ()

@end

@implementation ConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fromPickupLabel.text = self.receivedPickupSpot;
    self.toDestinationLabel.text = self.receivedDestination;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmButtonPressed:(id)sender {
    PFObject *delivery = [PFObject objectWithClassName:@"Delivery"];
    delivery[@"PickupSpot"]  = _fromPickupLabel.text;
    delivery[@"Destination"] = _toDestinationLabel.text;
    delivery[@"Username"] = [[PFUser currentUser] objectForKey:@"name"];
    delivery[@"Email"] = [[PFUser currentUser] objectForKey:@"email"];
    
    [delivery saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"The object has been saved.");
        } else {
            NSLog(@"There was a problem, check error.description");
        }
    }];
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
