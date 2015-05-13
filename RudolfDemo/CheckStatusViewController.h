//
//  CheckStatusViewController.h
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/8.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//
#import <Parse.h>
#import <UIKit/UIKit.h>

@interface CheckStatusViewController : UIViewController
//@property (weak, nonatomic) IBOutlet UILabel *additionalInfo;
@property (weak, nonatomic) IBOutlet UILabel *additionalInfoContent;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic,strong) PFObject *receivedDic;
@end
