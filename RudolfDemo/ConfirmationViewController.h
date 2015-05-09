//
//  ConfirmationViewController.h
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/4.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmationViewController : UIViewController
@property(nonatomic,strong)NSString *receivedDestination;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property(nonatomic,strong)NSString *receivedPhone;
@property(nonatomic,strong)NSString *receivedPickupSpot;
@property (weak, nonatomic) IBOutlet UILabel *fromPickupLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDestinationLabel;

@end
