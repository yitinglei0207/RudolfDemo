//
//  ConfirmationViewController.h
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/4.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirportConfirmController : UIViewController
//@property(nonatomic,strong)NSString *receivedDestination;

@property(nonatomic,strong)NSString *receivedPickupSpot;
@property (weak, nonatomic) IBOutlet UILabel *fromPickupLabel;
//@property (weak, nonatomic) IBOutlet UILabel *toDestinationLabel;

@end
