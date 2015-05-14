//
//  HotelConfirmViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/12.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//
#import <Parse.h>
#import "HotelConfirmViewController.h"
#import "SWRevealViewController.h"
#import <UIKit/UIKit.h>

@interface HotelConfirmViewController ()
{
    UIImageView *indicatorBackground;
    
}
@property(nonatomic,strong)UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation HotelConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fromPickupLabel.text = self.receivedPickupSpot;
    
    
    
    //set side menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    //set gesture for dismiss keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (IBAction)confirmButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"確認呼叫Rudolf?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        
    }else{
        [self sendingDelivery];
    }
}

- (void)sendingDelivery{
    NSNumber *serialNumber = [[NSNumber alloc]initWithInt:arc4random()%100000000];
    NSLog(@"%@",serialNumber);
    //set indicator
    [self activityIndicatorSetup];
    [_indicator startAnimating];
    self.view.userInteractionEnabled = NO;
    
    PFObject *delivery = [PFObject objectWithClassName:@"Delivery"];
    delivery[@"PickupSpot"]  = _fromPickupLabel.text;
    if (_hotelNametext.text) {
        delivery[@"Destination"] = _hotelNametext.text;
    }else{
        delivery[@"Destination"] = @"";
    }
    if (_reserveNameText.text) {
        delivery[@"AdditionalInfo"] = _reserveNameText.text;
    }else{
        delivery[@"AdditionalInfo"] = @"";
    }
    
    delivery[@"status"] = @"pending";
    delivery[@"BoardingORHotelTime"] = _hotelDate.date;
    delivery[@"Username"] = [[PFUser currentUser] objectForKey:@"name"];
    delivery[@"Email"] = [[PFUser currentUser] objectForKey:@"email"];
    delivery[@"SerialNumber"] = serialNumber;
    delivery[@"assign"] = @"000001";
    [delivery saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"訂單已送出" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSLog(@"There was a problem, check error.description");
        }
    }];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dismissKeyboard {
    [_hotelNametext resignFirstResponder];
    [_reserveNameText resignFirstResponder];
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
