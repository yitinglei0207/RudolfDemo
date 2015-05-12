//
//  HotelConfirmViewController.h
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/12.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelConfirmViewController : UIViewController
//@property(nonatomic,strong)NSString *receivedDestination;
//@property(nonatomic,strong)NSString *receivedPhone;
@property(nonatomic,strong)NSString *receivedPickupSpot;
@property(nonatomic,strong)NSDictionary *sendingDic;

@property (weak, nonatomic) IBOutlet UILabel *fromPickupLabel;
@property (weak, nonatomic) IBOutlet UITextField *hotelNametext;
@property (weak, nonatomic) IBOutlet UITextField *reserveNameText;

@end
