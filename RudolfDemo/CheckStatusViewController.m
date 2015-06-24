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
    [self setUpNavigationBarButtons];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
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
        qrCodeScanButton.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width/2, 44);
        [qrCodeScanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        qrCodeScanButton.backgroundColor = [UIColor darkGrayColor];
        [qrCodeScanButton addTarget:self action:@selector(qrCodeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
        [self.view addSubview:qrCodeScanButton];
    
        UIButton *cancelDelivery = [UIButton buttonWithType:UIButtonTypeSystem ];
        [cancelDelivery setTitle:@"取消訂單" forState:UIControlStateNormal];
        cancelDelivery.frame = CGRectMake(self.view.frame.size.width/2 +1, self.view.frame.size.height - 44, self.view.frame.size.width/2, 44);
        [cancelDelivery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelDelivery.backgroundColor = [UIColor darkGrayColor];
        [cancelDelivery addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:cancelDelivery];
    }
}

- (void)setUpNavigationBarButtons
{
    UIImage *leftIcon = [[UIImage imageNamed:@"left207"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:leftIcon
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(goBack:)];
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

-(void)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)qrCodeButtonPressed{
    [self performSegueWithIdentifier:@"ScanQRcodeSegue" sender:self];
}

- (void)cancelButtonPressed {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"確認刪除訂單？" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        
    }else{
        
        PFQuery *query = [PFQuery queryWithClassName:@"Delivery"];
        [query whereKey:@"SerialNumber" equalTo:[_receivedDic objectForKey:@"SerialNumber"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *orderArray, NSError *error) {
            if (!error){
                PFObject *orderObject;
                orderObject = orderArray[0];
                [orderObject deleteInBackground];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
                
            }
        }];
    }
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
