//
//  ReceivedQRController.h
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/11.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ReceivedQRController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *previewCode;
@property (weak, nonatomic) IBOutlet UIButton *startScan;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) PFObject *deliveryToBeUpdate;

@end
