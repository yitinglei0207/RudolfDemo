//
//  CheckStatusViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/8.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import "CheckStatusViewController.h"
#import "ReceivedQRController.h"

@interface CheckStatusViewController ()

@end

@implementation CheckStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    //========set date format and convert to string===============
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:self.receivedDic.updatedAt];
    NSLog(@"%@", strDate);
    //============================================================
    
    self.fromLabel.text = [self.receivedDic objectForKey:@"PickupSpot"];
    self.destinationLabel.text = [self.receivedDic objectForKey:@"Destination"];
    self.createdAtLabel.text = strDate;
    self.statusLabel.text = [self.receivedDic objectForKey:@"status"];
    self.additionalInfoContent.text = [self.receivedDic objectForKey:@"AdditionalInfo"];
    
    if ([[self.receivedDic objectForKey:@"status"] isEqualToString:@"pending"]) {
        UIButton *qrCodeScanButton = [UIButton buttonWithType:UIButtonTypeSystem ];
        [qrCodeScanButton setTitle:@"Scan QR Code" forState:UIControlStateNormal];
        qrCodeScanButton.frame = CGRectMake(16, self.view.frame.size.height - 60, self.view.frame.size.width-32, 44);
        [qrCodeScanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        qrCodeScanButton.backgroundColor = [UIColor darkGrayColor];
        [qrCodeScanButton addTarget:self action:@selector(qrCodeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:qrCodeScanButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)backButtonPressed:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)qrCodeButtonPressed{
    [self performSegueWithIdentifier:@"ScanQRcodeSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ReceivedQRController *nextView = segue.destinationViewController;
    nextView.deliveryToBeUpdate = self.receivedDic;
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
